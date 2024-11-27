//
//  CreateScheduleViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.08.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class CreateScheduleViewModel: CreateScheduleViewModelProtocol {
    // MARK: - public properties
    var textFieldValue = BehaviorRelay<String>(value: "")
    var datePickerValue = BehaviorRelay<Date>(value: Date())
    var notificationSwitchValue = BehaviorRelay<Bool>(value: false)
    weak var delegate: CreateScheduleDelegate?
    var taskDescription: String = ""
    
    // MARK: - private properties
    private var dateAndTimeOfTask: Date = Date()
    private var isNotificationEnabled: Bool = false
    private var taskToEdit: ScheduleTask?
    
    init(
        delegate: CreateScheduleDelegate?,
        taskToEdit: ScheduleTask?
    ) {
        self.delegate = delegate
        self.taskToEdit = taskToEdit
        if let task = taskToEdit {
            textFieldValue.accept(task.description)
            datePickerValue.accept(task.date)
            notificationSwitchValue.accept(task.isNotificationEnabled)
            dateAndTimeOfTask = task.date
            isNotificationEnabled = task.isNotificationEnabled
        }
    }
    
    // MARK: - public methods
    func createTask() {
        if taskDescription != L10n.Localizable.CreateSchedule.placeholder && taskDescription != "" && taskDescription != " " {
            let date = dateAndTimeOfTask
            let notification = isNotificationEnabled
            let task = ScheduleTask(id: UUID(), date: date, description: taskDescription, isNotificationEnabled: notification, completed: false)
            delegate?.didAddTask(task, mode: .task)
        }
    }
    
    func editTask() {
        if taskDescription != L10n.Localizable.CreateSchedule.placeholder,
           taskDescription != "",
           taskDescription != " ",
           let taskToEdit = taskToEdit {
            let task = ScheduleTask(
                id: taskToEdit.id,
                date: dateAndTimeOfTask,
                description: taskDescription,
                isNotificationEnabled: isNotificationEnabled,
                completed: taskToEdit.completed
            )
            delegate?.edit(task)
        }
    }
    
    func set(_ date: Date) {
        dateAndTimeOfTask = date
    }
    
    func set(_ notification: Bool) {
        isNotificationEnabled = notification
    }
}
