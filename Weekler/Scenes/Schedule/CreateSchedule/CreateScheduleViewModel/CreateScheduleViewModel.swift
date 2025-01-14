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
    private var dateAndTimeOfTask: [Date] = [Date()]
    private var isNotificationEnabled: Bool = false
    private var taskToEdit: ScheduleTask?
    
    // MARK: - lifecycle
    init(
        delegate: CreateScheduleDelegate?,
        taskToEdit: ScheduleTask?
    ) {
        self.delegate = delegate
        self.taskToEdit = taskToEdit
        if let task = taskToEdit {
            let date = extractFirstDate(from: task.dates)
            
            textFieldValue.accept(task.description)
            notificationSwitchValue.accept(task.isNotificationEnabled)
            isNotificationEnabled = task.isNotificationEnabled
            
            datePickerValue.accept(date)
            dateAndTimeOfTask = task.dates
//            datePickerValue.accept(task.date)
//            dateAndTimeOfTask = task.date
        }
    }
    
    // MARK: - public methods
    func createTask() {
        if taskDescription != L10n.Localizable.CreateSchedule.placeholder && taskDescription != "" && taskDescription != " " {
            let notification = isNotificationEnabled
            let task = ScheduleTask(
                id: UUID(),
                dates: dateAndTimeOfTask,
                description: taskDescription,
                isNotificationEnabled: notification,
                completed: false
            )
            print("create", task.dates, task.description)
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
                dates: dateAndTimeOfTask,
                description: taskDescription,
                isNotificationEnabled: isNotificationEnabled,
                completed: taskToEdit.completed
            )
            delegate?.edit(task)
        }
    }
    
    func set(_ date: Date) {
        dateAndTimeOfTask.append(date)
    }
    
    func set(_ notification: Bool) {
        isNotificationEnabled = notification
    }
    
    private func extractFirstDate(from dateArray: [Date]) -> Date {
        return dateArray.first ?? Date()
    }
}
