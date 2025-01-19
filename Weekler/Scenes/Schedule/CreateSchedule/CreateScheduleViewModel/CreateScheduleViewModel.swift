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
    private var plannedDatesArray: [Date] = []
    
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
            plannedDatesArray = task.dates
        }
    }
    
    // MARK: - public methods
    func createTask() {
        if taskDescription != L10n.Localizable.CreateSchedule.placeholder && taskDescription != "" && taskDescription != " " {
            let notification = isNotificationEnabled
            plannedDatesArray.append(dateAndTimeOfTask)
            let task = ScheduleTask(
                id: UUID(),
                dates: plannedDatesArray,
                description: taskDescription,
                isNotificationEnabled: notification,
                completed: false
            )
            delegate?.didAddTask(task, mode: .task)
        }
    }
    
    /// Method called when Save button tapped after editing task.
    /// Creates array of current planned dates of task
    func editTask() {
        plannedDatesArray = []
        plannedDatesArray.append(dateAndTimeOfTask)
        print(plannedDatesArray)
        if taskDescription != L10n.Localizable.CreateSchedule.placeholder,
           taskDescription != "",
           taskDescription != " ",
           let taskToEdit = taskToEdit {
            let task = ScheduleTask(
                id: taskToEdit.id,
                dates: plannedDatesArray,
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
    
    func saveDateRange() {
        print("saving date range")
    }
    
    private func extractFirstDate(from dateArray: [Date]) -> Date {
        return dateArray.first ?? Date()
    }
}
