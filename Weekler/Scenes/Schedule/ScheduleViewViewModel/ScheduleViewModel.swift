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
    private var scheduleFlowCoordinator: ScheduleFlowCoordinator
    private var hapticsManager: CoreHapticsManagerProtocol?
    
    init(
        dependencies: SceneFactoryProtocol,
        scheduleFlowCoordinator: ScheduleFlowCoordinator,
        hapticManager: CoreHapticsManagerProtocol? = nil
    ) {
        self.dependencies = dependencies
        self.scheduleFlowCoordinator = scheduleFlowCoordinator
        self.hapticsManager = hapticManager
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
        currentDate = selectedDate
        fetchSchedule()
    }
    
    @objc func didTapAddNewEventButton() {
        hapticsManager?.playTap()
        scheduleFlowCoordinator.goToCreateScheduleView(for: nil, with: .create)
    }
    
    // MARK: - private methods
    private func fetchSchedule() {
        print("fetch")
        let currentDateOnly = currentDate.onlyDate
        Task.detached {
            let scheduleItems = await self.scheduleUseCase.fetchTaskItems(for: currentDateOnly)
            DispatchQueue.main.async {
                self.tasks = scheduleItems.filter { !$0.completed }
                self.completedTasks = scheduleItems.filter { $0.completed }
                self.populateData()
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
            .subscribe(onNext: { [weak self] selectedDateByUser in
                guard let self = self else { return }
                self.currentDate = selectedDateByUser
                self.fetchSchedule()
            })
            .disposed(by: bag)
    }
}

// MARK: - CreateScheduleDelegate
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
        Task.detached {
            var id = UUID()
            switch self.mainMode {
            case .task:
                id = self.tasks[index].id
            case .completedTask:
                id = self.completedTasks[index].id
            }
            await self.scheduleUseCase.deleteTask(with: id)
        }
    }
    
    func completeTask(with id: UUID) {
        Task.detached {
            await self.scheduleUseCase.completeTask(with: id)
        }
    }
    
    func unCompleteTask(with id: UUID) {
        Task.detached {
            await self.scheduleUseCase.unCompleteTask(with: id)
        }
    }
    
    func prepareCreateView(at index: Int) {
        let task = task(at: index)
        scheduleFlowCoordinator.goToCreateScheduleView(for: task, with: .edit)
    }
    
    func playAddTask() {
        hapticsManager?.playAddTask()
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
