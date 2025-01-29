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
    var dataList = PublishRelay<[SourceItem]>()
    var emptyStateIsActive: Driver<Bool>
    var navigationTitle = BehaviorRelay<String>(value: "")
    var calendarStateSwitch: PublishRelay<Bool> = .init()
    
    // MARK: - Input
    var currentDateChangesObserver = PublishRelay<Date>()
    
    //MARK: - public properties
    var tasks: [ScheduleTask] = []
    var data: [SourceItem] = []
    var mainMode: ScheduleMode = .task
    var selectedDate: Date { currentDate }
    
    //MARK: - Private properties
    private var completedTasks: [ScheduleTask] = []
    private var currentDate: Date = Date()
    private var bag = DisposeBag()
    private let dependencies: SceneFactoryProtocol
    private var scheduleFlowCoordinator: ScheduleFlowCoordinator
    private var hapticsManager: CoreHapticsManagerProtocol?
    private lazy var scheduleUseCase: ScheduleUseCaseProtocol = {
        dependencies.makeScheduleUseCase()
    }()
    private lazy var notificationService: LocalNotificationServiceProtocol = {
        dependencies.makeNotificationService()
    }()
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    // MARK: - lifecycle
    init(
        dependencies: SceneFactoryProtocol,
        scheduleFlowCoordinator: ScheduleFlowCoordinator,
        hapticManager: CoreHapticsManagerProtocol? = nil
    ) {
        self.dependencies = dependencies
        self.scheduleFlowCoordinator = scheduleFlowCoordinator
        self.hapticsManager = hapticManager
        
        emptyStateIsActive = dataList
            .map({ items in
                !items.isEmpty
            })
            .asDriver(onErrorJustReturn: false)
        
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
    
    func toggleCalendarAppearance() {
        calendarStateSwitch.accept(true)
    }
    
    @objc
    func didTapAddNewEventButton() {
        hapticsManager?.playTap()
        scheduleFlowCoordinator.navigateToCreateScheduleView(for: nil, with: .create)
    }
    
    // MARK: - private methods
    private func fetchSchedule() {
        print("fetch")
        var query: Query?
        switch mainMode {
        case .task:
            query = .init(date: currentDate, taskIsCompleted: false)
        case .completedTask:
            query = .init(date: currentDate, taskIsCompleted: true)
        }
        Task.detached { [weak self] in
            guard let self = self,
                  let query = query else {
                return
            }
            let scheduleItems = await self.scheduleUseCase.fetchTaskItems(with: query)
            
            await MainActor.run {
                self.tasks = scheduleItems.filter { !$0.completed }
                self.completedTasks = scheduleItems.filter { $0.completed }
                self.populateData()
            }
        }
    }
    
    private func populateData() {
        switch mainMode {
        case .task:
            tasks.sortByTime()
            data = tasks.map { .task($0) }
        case .completedTask:
            completedTasks.sortByTime()
            data = completedTasks.map { .completedTask($0) }
        }
        dataList.accept(data)
    }
    
    private func bindToScheduleUpdates() {
        NotificationCenter.default
            .addObserver(
                forName: .NSPersistentStoreRemoteChange, // .NSManagedObjectContextObjectsDidChange
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
        // FIXME: - add try await to use case
        Task.detached {
            do {
                await self.scheduleUseCase.insert(task)
                try await self.notificationService.addNotification(for: task)
            } catch {
                fatalError("Error adding task \(error.localizedDescription)")
            }
            
        }
    }
    
    func edit(_ task: ScheduleTask) {
        Task.detached {
            do {
                await self.scheduleUseCase.edit(task)
                try await self.notificationService.changeNotification(for: task)
            } catch {
                fatalError()
            }
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
            self.notificationService.removeNotifications(with: [id.uuidString])
        }
    }
    
    func completeTask(with id: UUID) {
        Task.detached {
            await self.scheduleUseCase.toggleTaskCompletion(with: id, isCompleted: true)
        }
    }
    
    func unCompleteTask(with id: UUID) {
        Task.detached {
            await self.scheduleUseCase.toggleTaskCompletion(with: id, isCompleted: false)
        }
    }
    
    func prepareCreateView(at index: Int) {
        let task = task(at: index)
        scheduleFlowCoordinator.navigateToCreateScheduleView(for: task, with: .edit)
    }
    
    func playAddTask() {
        hapticsManager?.playAddTask()
    }
}

//MARK: - CalendarViewModelProtocol
extension ScheduleViewModel: CalendarViewModelProtocol {
    
    func updateNavTitle(with date: [Date]) {
        let title = formatter.string(from: date[0])
        navigationTitle.accept(title)
    }
}

// MARK: - SelectTaskViewModelProtocol
extension ScheduleViewModel: SelectTaskViewModelProtocol {
    func reconfigureMode(_ mode: ScheduleMode) {
        mainMode = mode
        fetchSchedule()
    }
}
