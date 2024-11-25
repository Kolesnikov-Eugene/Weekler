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
    var shouldRemoveStatistics: PublishRelay<Bool> { get set }
    var selectedInterval: PublishRelay<Int> { get set }
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
    func viewWillAppear()
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    // MARK: output
    var shouldAnimateStatistics: PublishRelay<CGFloat> = .init()
    var shouldRemoveStatistics: PublishRelay<Bool> = .init()
    
    
    // MARK: - Input
    var selectedInterval: PublishRelay<Int> = .init()
    
    // MARK: private properties
    private let statisticsService: StatisticsServiceProtocol
    private let bag = DisposeBag()
    private var currentWeekDates = [String]()
    private var currentWeekSchedule: [ScheduleTask]? // FIXME: store Int instead of tasks
    private var completedTasks: [ScheduleTask]?
    private var progress: CGFloat = 0.0
    
    init(
        statisticsService: StatisticsServiceProtocol
    ) {
        self.statisticsService = statisticsService
        currentWeekDates = Calendar.getCurrentWeekDatesArray()
        selectedInterval
            .subscribe(onNext: { [weak self] interval in
                print(interval)
        })
            .disposed(by: bag)
    }
    
    func viewDidLoad() {
        fetchScheduleProgress(for: currentWeekDates)
    }
    
    func viewWillAppear() {
        fetchScheduleProgress(for: currentWeekDates)
    }
    
    func viewDidAppear() {
        shouldAnimateStatistics.accept(progress)
    }
    
    func viewDidDisappear() {
        shouldRemoveStatistics.accept(true)
    }
    
    private func fetchScheduleProgress(for interval: [String]) {
        Task.detached {
            self.currentWeekSchedule = await self.statisticsService.fetchCurrentWeekStatistics(for: interval)
            if let curSchedule = self.currentWeekSchedule {
                self.completedTasks = curSchedule.filter { $0.completed }
            }
            self.calculateProgress()
        }
    }
    
    private func calculateProgress() {
        guard let completedTasks,
              let currentWeekSchedule,
              !currentWeekSchedule.isEmpty else {
            progress = 0.0
            return
        }
        progress = CGFloat(completedTasks.count) / CGFloat(currentWeekSchedule.count)
    }
}
