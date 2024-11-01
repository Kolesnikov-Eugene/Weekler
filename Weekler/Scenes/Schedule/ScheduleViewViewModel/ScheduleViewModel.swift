//
//  ScheduleViewViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class ScheduleViewModel: ScheduleViewModelProtocol {
    //MARK: - public properties
    var tasks: [ScheduleTask] = []
    var data: [SourceItem]
    var dataList = BehaviorRelay<[SourceItem]>(value: [])
    var emptyStateIsActive: Driver<Bool>
    var currentDateChangesObserver = BehaviorRelay<Date>(value: Date())
    var setCreateViewNeedsToBePresented = BehaviorRelay<Bool>(value: false)
    var presentCreateViewEditingAtIndex = BehaviorRelay<Int?>(value: nil)
    var calendarHeightValue = BehaviorRelay<Double?>(value: nil)
    var navigationTitle = BehaviorRelay<String>(value: "")
    var mainMode: ScheduleMode = .task
    var selectedDate: Date { currentDate }
    
    private var completedTasks: [ScheduleTask] = []
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
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
    private var scheduleDataManager: ScheduleUseCaseProtocol
    private var currentDate: Date
    private var bag = DisposeBag()
    
    init(scheduleDataManager: ScheduleUseCaseProtocol) {
        self.scheduleDataManager = scheduleDataManager
        currentDate = Date()
        data = []
        emptyStateIsActive = dataList
            .map({ items in
                !items.isEmpty
            })
            .asDriver(onErrorJustReturn: false)
        
//        fetchSchedule()
        bindToScheduleUpdates()
    }
    
    // MARK: - public methods
//    func getSelectedDate() -> Date {
//         currentDate
//    }
    func task(at index: Int) -> ScheduleTask {
        tasks[index]
    }
    
    func reconfigureMode(_ mode: ScheduleMode) {
        mainMode = mode
        populateData()
    }
    
    func changeDate(for selectedDate: Date) {
        print("changed")
        currentDate = selectedDate
        fetchSchedule()
    }
    
    func deleteTask(at index: Int) {
        Task.detached { [weak self] in
            guard let self = self else { return }
            var taskId = UUID()
            switch mainMode {
            case .task:
                taskId = tasks[index].id
            case .completedTask:
                taskId = completedTasks[index].id
            }
            let predicate = #Predicate<TaskItem> { $0.id == taskId }
            await scheduleDataManager.delete(taskId, predicate: predicate)
        }
    }
    
    func completeTask(with id: UUID) {
        Task.detached {
            let task = self.tasks.first(where: { $0.id == id })
            if let task = task {
                await self.scheduleDataManager.complete(task)
            }
        }
    }
    
    func unCompleteTask(with id: UUID) {
        Task.detached {[weak self] in
            guard let self = self else { return }
            let task = completedTasks.first(where: { $0.id == id })
            if let task = task {
                await scheduleDataManager.unComplete(task)
            }
        }
    }
    
    func prepareCreateView(at index: Int) {
        presentCreateViewEditingAtIndex.accept(index)
    }
    
    func setCalendarViewWith(_ height: Double) {
        calendarHeightValue.accept(height)
    }
    
    func updateNavTitle(with date: [Date]) {
        let title = formatter.string(from: date[0])
        navigationTitle.accept(title)
    }
    
    @objc func didTapAddNewEventButton() {
        setCreateViewNeedsToBePresented.accept(true)
    }
    
    // MARK: - private methods
    private func fetchSchedule() {
        print("fetch")
        let currentDateOnly = currentDate.onlyDate
        Task.detached {
            let sortDescriptor = SortDescriptor<TaskItem>(\.date, order: .forward)
            let predicate = #Predicate<TaskItem> { $0.onlyDate == currentDateOnly }
            await self.scheduleDataManager.fetchTaskItems(
                predicate: predicate,
                sortDescriptor: sortDescriptor) { [weak self] (result: Result<[ScheduleTask], Error>) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let scheduleItems):
                        DispatchQueue.main.async {
                            self.tasks = scheduleItems.filter { !$0.completed }
                            self.completedTasks = scheduleItems.filter { $0.completed }
                            self.populateData()
                        }
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    }
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
                //                forName: .NSManagedObjectContextObjectsDidChange,
                forName: .NSPersistentStoreRemoteChange,
                object: nil,
                queue: .main) { [weak self] _ in
                    self?.fetchSchedule()
                }
        
        currentDateChangesObserver
            .observe(on: MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { [weak self] selectedDateByUser in
                guard let self = self else { return }
                self.currentDate = selectedDateByUser
                self.fetchSchedule()
            })
            .disposed(by: bag)
    }
}

extension ScheduleViewModel: CreateScheduleDelegate {
    func didAddTask(_ task: ScheduleTask, mode: ScheduleMode) {
        Task.detached {
            await self.scheduleDataManager.insert(task)
        }
    }
    
    func edit(_ task: ScheduleTask) {
        Task.detached {
            await self.scheduleDataManager.edit(task)
        }
    }
}
