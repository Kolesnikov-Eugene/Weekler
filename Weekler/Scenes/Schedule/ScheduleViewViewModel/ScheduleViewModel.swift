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

    //MARK: - Output
    var dataList = BehaviorRelay<[SourceItem]>(value: [])
    var emptyStateIsActive: Driver<Bool>
    var setCreateViewNeedsToBePresented = PublishRelay<Bool>()
    var presentCreateViewEditingAtIndex = PublishRelay<Int?>()
    var calendarHeightValue = PublishRelay<Double?>()
    var navigationTitle = BehaviorRelay<String>(value: "")
    
    // MARK: - Input
    var currentDateChangesObserver = PublishRelay<Date>()
    
    //MARK: - public properties
    var tasks: [ScheduleTask] = []
    var data: [SourceItem]
    var mainMode: ScheduleMode = .task
    var selectedDate: Date { currentDate }
    
    //MARK: - Private properties
    private var completedTasks: [ScheduleTask] = []
    private var currentDate: Date
    private var bag = DisposeBag()
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    private let dependencies: SceneFactoryProtocol
    private lazy var scheduleUseCase: ScheduleUseCaseProtocol = {
        dependencies.makeScheduleUseCase()
    }()
    
    init(dependencies: SceneFactoryProtocol) {
        self.dependencies = dependencies
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
    func task(at index: Int) -> ScheduleTask {
        tasks[index]
    }
    
    func changeDate(for selectedDate: Date) {
        print("changed")
        currentDate = selectedDate
        fetchSchedule()
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
            await self.scheduleUseCase.fetchTaskItems(
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
//            .skip(1)
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
            await self.scheduleUseCase.insert(task)
        }
    }
    
    func edit(_ task: ScheduleTask) {
        Task.detached {
            await self.scheduleUseCase.edit(task)
        }
    }
}

//MARK: - ScheduleMainViewModelProtocol
extension ScheduleViewModel: ScheduleMainViewModelProtocol {
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
            await scheduleUseCase.delete(taskId, predicate: predicate)
        }
    }
    
    func completeTask(with id: UUID) {
        Task.detached {
            let task = self.tasks.first(where: { $0.id == id })
            if let task = task {
                await self.scheduleUseCase.complete(task)
            }
        }
    }
    
    func unCompleteTask(with id: UUID) {
        Task.detached {[weak self] in
            guard let self = self else { return }
            let task = completedTasks.first(where: { $0.id == id })
            if let task = task {
                await scheduleUseCase.unComplete(task)
            }
        }
    }
    
    func prepareCreateView(at index: Int) {
        presentCreateViewEditingAtIndex.accept(index)
    }
}

//MARK: - CalendarViewModelProtocol
extension ScheduleViewModel: CalendarViewModelProtocol {
    func setCalendarViewWith(_ height: Double) {
        calendarHeightValue.accept(height)
    }
    
    func updateNavTitle(with date: [Date]) {
        let title = formatter.string(from: date[0])
        navigationTitle.accept(title)
    }
}

// MARK: - SelectTaskViewModelProtocol
extension ScheduleViewModel: SelectTaskViewModelProtocol {
    func reconfigureMode(_ mode: ScheduleMode) {
        mainMode = mode
        populateData()
    }
}
