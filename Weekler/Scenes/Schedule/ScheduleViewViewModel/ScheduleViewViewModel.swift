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
    
    var data: [SourceItem]
    var dataList = BehaviorRelay<[SourceItem]>(value: [])
    var emptyStateIsActive: Driver<Bool>
    var mainMode: ScheduleMode = .task
    
    // MARK: - private properties
    private let scheduleDataManager: ScheduleDataManagerProtocol
    
    init(scheduleDataManager: ScheduleDataManagerProtocol) {
        self.scheduleDataManager = scheduleDataManager
        
        data = []
        
//        dataList.accept(data)
        emptyStateIsActive = dataList
            .map({ items in
                !items.isEmpty
            })
            .asDriver(onErrorJustReturn: false)
        
        fetchSchedule()
    }
    
    func reconfigureMode(_ mode: ScheduleMode) {
        switch mode {
        case .goal:
            data = goals.map { .goal($0) }
        case .priority:
            data = priorities.map { .priority($0) }
        case .task:
            data = tasks.map { .task($0) }
        }
        dataList.accept(data)
    }
    
    private func fetchSchedule() {
        let sortDescriptor = SortDescriptor<TaskItem>(\.date, order: .forward)
        
        scheduleDataManager.fetchTaskItems(sortDescriptor: sortDescriptor) { [weak self] (result: Result<[TaskItem], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let scheduleItems):
                tasks = scheduleItems.map { ScheduleTask(
                    id: $0.id,
                    date: $0.date,
                    description: $0.taskDescription,
                    isNotificationEnabled: $0.isNotificationEnabled
                ) }
                data = tasks.map { .task($0) }
                dataList.accept(data)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}

extension ScheduleViewViewModel: CreateScheduleDelegate {
    func didAddTask(_ task: ScheduleTask, mode: ScheduleMode) {
        let model = TaskItem(
            id: task.id,
            date: task.date,
            taskDescription: task.description,
            isNotificationEnabled: task.isNotificationEnabled
        )
        scheduleDataManager.insert(model)
        fetchSchedule()
        
//        tasks.append(task)
//        data = tasks.map { .task($0) }
//        dataList.accept(data)
    }
}
