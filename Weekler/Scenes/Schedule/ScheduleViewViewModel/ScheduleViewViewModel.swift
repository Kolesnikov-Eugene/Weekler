//
//  ScheduleViewViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class ScheduleViewViewModel: ScheduleViewViewModelProtocol {
    //MARK: - public properties
    var tasks: [ScheduleTask] = []
    var data: [SourceItem]
    var dataList = BehaviorRelay<[SourceItem]>(value: [])
    var emptyStateIsActive: Driver<Bool>
    var currentDateChangesObserver = BehaviorRelay<Date>(value: Date())
    var mainMode: ScheduleMode = .task
    
    private var completedTasks: [ScheduleTask] = []
    
    var priorities: [Priority] = [
        Priority(id: UUID(), date: Date(), description: "Study"),
        Priority(id: UUID(), date: Date(), description: "Sport"),
        Priority(id: UUID(), date: Date(), description: "Relax")
    ]
    
    var goals: [Goal] = [
        Goal(id: UUID(), date: Date(), description: "Sport 3 times"),
        Goal(id: UUID(), date: Date(), description: "Listen 5 lectures"),
        Goal(id: UUID(), date: Date(), description: "10000 steps every day")
    ]
    
    // MARK: - private properties
    private var scheduleDataManager: ScheduleDataManagerProtocol
    private var currentDate: Date
    private var bag = DisposeBag()
    
    init(scheduleDataManager: ScheduleDataManagerProtocol) {
        self.scheduleDataManager = scheduleDataManager
        currentDate = Date()
        data = []
        emptyStateIsActive = dataList
            .map({ items in
                !items.isEmpty
            })
            .asDriver(onErrorJustReturn: false)
        
        fetchSchedule()
        bindToScheduleUpdates()
    }
    
    // MARK: - public methods
    func task(at index: Int) -> ScheduleTask {
        tasks[index]
    }
    
    func reconfigureMode(_ mode: ScheduleMode) {
        mainMode = mode
        populateData()
    }
    
    func changeDate(for selectedDate: Date) {
        currentDate = selectedDate
        fetchSchedule()
    }
    
    func deleteTask(at index: Int) {
        var taskId = UUID()
        switch mainMode {
        case .task:
            taskId = tasks[index].id
        case .completedTask:
            taskId = completedTasks[index].id
        }
        let predicate = #Predicate<TaskItem> { $0.id == taskId }
        scheduleDataManager.delete(taskId, predicate: predicate)
    }
    
    func completeTask(with id: UUID) {
        let task = tasks.first(where: { $0.id == id })
        if let task = task {
            scheduleDataManager.complete(task)
        }
    }
    
    func unCompleteTask(with id: UUID) {
        let task = completedTasks.first(where: { $0.id == id })
        if let task = task {
            scheduleDataManager.unComplete(task)
        }
    }
    
    // MARK: - private methods
    private func fetchSchedule() {
        let sortDescriptor = SortDescriptor<TaskItem>(\.date, order: .forward)
        let predicate = #Predicate<TaskItem> { $0.onlyDate == currentDate.onlyDate }
        
        scheduleDataManager.fetchTaskItems(
            predicate: predicate,
            sortDescriptor: sortDescriptor) { [weak self] (result: Result<[ScheduleTask], Error>) in
                guard let self = self else { return }
                switch result {
                case .success(let scheduleItems):
                    tasks = scheduleItems.filter { !$0.completed }
                    completedTasks = scheduleItems.filter { $0.completed }
                    populateData()
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
    }
    
    private func populateData() {
        switch mainMode {
        case .task:
            data = tasks.map { .task($0) }
        case .completedTask:
            data = completedTasks.map { .completedTask($0) }
        }
        dataList.accept(data)
    }
    
    private func bindToScheduleUpdates() {
        NotificationCenter.default
            .addObserver(
                forName: .NSManagedObjectContextObjectsDidChange,
                object: nil,
                queue: .main) { [weak self] _ in
                    self?.fetchSchedule()
                }
        
        currentDateChangesObserver
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] selectedDateByUser in
                guard let self = self else { return }
                self.currentDate = selectedDateByUser
                self.fetchSchedule()
            })
            .disposed(by: bag)
    }
}

extension ScheduleViewViewModel: CreateScheduleDelegate {
    func didAddTask(_ task: ScheduleTask, mode: ScheduleMode) {
        scheduleDataManager.insert(task)
    }
    
    func edit(_ task: ScheduleTask) {
        scheduleDataManager.edit(task)
    }
}
