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
    var shouldAnimateStatistics: PublishRelay<Bool> { get set }
    var shouldRemoveStatistics: PublishRelay<Bool> { get set }
    var selectedInterval: PublishRelay<Int> { get set }
    func viewDidLoad()
    func viewDidAppear()
    func viewDidDisappear()
    func viewWillAppear()
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    
    // MARK: output
    var shouldAnimateStatistics: PublishRelay<Bool> = .init()
    var shouldRemoveStatistics: PublishRelay<Bool> = .init()
    
    
    // MARK: - Input
    var selectedInterval: PublishRelay<Int> = .init()
    
    // MARK: private properties
    private let statisticsService: StatisticsServiceProtocol
    private let bag = DisposeBag()
    private var currentWeekDates = [String]()
    private var currentWeekSchedule: [ScheduleTask]?
    private var completedTasks: [ScheduleTask]?
    
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
        fetch()
    }
    
    func viewWillAppear() {
        fetch()
    }
    
    func viewDidAppear() {
        shouldAnimateStatistics.accept(true)
    }
    
    func viewDidDisappear() {
        shouldRemoveStatistics.accept(true)
    }
    
    private func fetch() {
        Task.detached {
            self.currentWeekSchedule = await self.statisticsService.fetchCurrentWeekStatistics(for: self.currentWeekDates)
            if let curSchedule = self.currentWeekSchedule {
                self.completedTasks = curSchedule.filter { $0.completed }
            }
            
            self.printStat()
        }
    }
    
    private func printStat() {
        print("Current stat -> done: \(completedTasks?.count) / all: \(currentWeekSchedule?.count)")
        
    }
}
