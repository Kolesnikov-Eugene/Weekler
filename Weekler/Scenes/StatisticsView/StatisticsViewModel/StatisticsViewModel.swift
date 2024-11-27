//
//  StatisticsViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.11.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    // MARK: output
    var shouldAnimateStatistics: PublishRelay<CGFloat> = .init()
    
    // MARK: - Input
    var selectedInterval: PublishRelay<Int> = .init()
    
    // MARK: private properties
    private var currentWeekDates = [String]()
    private var currentMonthDates = [String]()
    private var currentWeekScheduleItemsCount: Int?
    private var currentMonthScheduleItemsCount: Int?
    private var completedWeekTasksCount: Int?
    private var completedMonthTasksCount: Int?
    private var progress: CGFloat = 0.0
    private var currentInterval: StatisticsInterval = .week
    private let bag = DisposeBag()
    private let statisticsService: StatisticsServiceProtocol
    
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
    
    // MARK: public methods
    func viewWillAppear() {
        fetchScheduleProgress(for: currentWeekDates, with: .week)
        fetchScheduleProgress(for: currentMonthDates, with: .month)
    }
    
    func viewDidAppear() {
        shouldAnimateStatistics.accept(progress)
    }
    
    // MARK: private methods
    private func bindToIntervalSegmentedControl() {
        selectedInterval
            .subscribe(onNext: { [weak self] interval in
                guard let self = self else { return }
                switch interval {
                case 0:
                    self.currentInterval = .week
                case 1:
                    self.currentInterval = .month
                case 2:
                    print("2")
                default: break
                }
                self.calculateProgress()
                self.shouldAnimateStatistics.accept(self.progress)
            })
            .disposed(by: bag)
    }
    
    private func fetchScheduleProgress(for interval: [String], with mode: StatisticsInterval) {
        Task.detached {
            switch mode {
            case .week:
                let currentWeekSchedule = await self.statisticsService.fetchCurrentWeekStatistics(for: interval)
                self.currentWeekScheduleItemsCount = currentWeekSchedule.count
                self.completedWeekTasksCount = currentWeekSchedule.filter { $0.completed }.count
            case .month:
                let currentMonthSchedule = await self.statisticsService.fetchCurrentWeekStatistics(for: interval)
                self.currentMonthScheduleItemsCount = currentMonthSchedule.count
                self.completedMonthTasksCount = currentMonthSchedule.filter { $0.completed }.count
            }
            self.calculateProgress()
        }
    }
    
    private func calculateProgress() {
        switch currentInterval {
        case .week:
            guard let completedWeekTasksCount,
                  let currentWeekScheduleItemsCount,
                  currentWeekScheduleItemsCount != 0 else {
                progress = 0.0
                return
            }
            progress = CGFloat(completedWeekTasksCount) / CGFloat(currentWeekScheduleItemsCount)
        case .month:
            guard let completedMonthTasksCount,
                  let currentMonthScheduleItemsCount,
                  currentMonthScheduleItemsCount != 0 else {
                progress = 0.0
                return
            }
            progress = CGFloat(completedMonthTasksCount) / CGFloat(currentMonthScheduleItemsCount)
        }
    }
}
