//
//  StatisticsViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.11.2024.
//

import Foundation
import RxSwift
import RxCocoa


protocol StatisticsViewModelProtocol: AnyObject {
    var shouldAnimateStatistics: PublishRelay<CGFloat> { get set }
    var selectedInterval: PublishRelay<Int> { get set }
    func viewDidAppear()
    func viewWillAppear()
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    // MARK: output
    var shouldAnimateStatistics: PublishRelay<CGFloat> = .init()
    
    
    // MARK: - Input
    var selectedInterval: PublishRelay<Int> = .init()
    
    // MARK: private properties
    private let statisticsService: StatisticsServiceProtocol
    private var currentWeekDates = [String]()
    private var currentMonthDates = [String]()
    private var currentWeekSchedule: [ScheduleTask]? // FIXME: store Int instead of tasks
    private var currentMonthSchedule: [ScheduleTask]?
    private var completedWeekTasks: [ScheduleTask]?
    private var completedMonthTasks: [ScheduleTask]?
    private var progress: CGFloat = 0.0
    private let bag = DisposeBag()
    private var currentInterval: StatisticsInterval = .week
    
    private enum StatisticsInterval {
        case week
        case month
    }
    
    init(
        statisticsService: StatisticsServiceProtocol
    ) {
        self.statisticsService = statisticsService
        currentWeekDates = Calendar.getCurrentWeekDatesArray()
        currentMonthDates = Calendar.getCurrentMonthDatesArray()
        bindToIntervalSegmentedControl()
    }
    
    func viewWillAppear() {
        fetchScheduleProgress(for: currentWeekDates, with: .week)
        fetchScheduleProgress(for: currentMonthDates, with: .month)
    }
    
    func viewDidAppear() {
        shouldAnimateStatistics.accept(progress)
    }
    
    private func bindToIntervalSegmentedControl() {
        selectedInterval
            .subscribe(onNext: { [weak self] interval in
                guard let self = self else { return }
                switch interval {
                case 0:
                    self.currentInterval = .week
                    self.calculateProgress()
                    self.shouldAnimateStatistics.accept(self.progress)
                case 1:
                    self.currentInterval = .month
                    self.calculateProgress()
                    self.shouldAnimateStatistics.accept(self.progress)
                case 2:
                    print("2")
                default: break
                }
            })
            .disposed(by: bag)
    }
    
    private func fetchScheduleProgress(for interval: [String], with mode: StatisticsInterval) {
        Task.detached {
            switch mode {
            case .week:
                self.currentWeekSchedule = await self.statisticsService.fetchCurrentWeekStatistics(for: interval)
                if let curSchedule = self.currentWeekSchedule {
                    self.completedWeekTasks = curSchedule.filter { $0.completed }
                }
            case .month:
                self.currentMonthSchedule = await self.statisticsService.fetchCurrentWeekStatistics(for: interval)
                if let curSchedule = self.currentMonthSchedule {
                    self.completedMonthTasks = curSchedule.filter { $0.completed }
                }
            }
            self.calculateProgress()
        }
    }
    
    private func calculateProgress() {
        switch currentInterval {
        case .week:
            guard let completedWeekTasks,
                  let currentWeekSchedule,
                  !currentWeekSchedule.isEmpty else {
                progress = 0.0
                return
            }
            progress = CGFloat(completedWeekTasks.count) / CGFloat(currentWeekSchedule.count)
        case .month:
            guard let completedMonthTasks,
                  let currentMonthSchedule,
                  !currentMonthSchedule.isEmpty else {
                progress = 0.0
                return
            }
            progress = CGFloat(completedMonthTasks.count) / CGFloat(currentMonthSchedule.count)
        }
    }
}
