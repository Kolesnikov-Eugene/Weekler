//
//  CreateScheduleViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.08.2024.
//

import Foundation

final class CreateScheduleViewModel: CreateScheduleViewModelProtocol {
    
    weak var delegate: CreateScheduleDelegate?
    var taskDescription: String = ""
    var dateAndTimeOfTask: Date = Date()
    var isNotificationEnabled: Bool = false
    
    
    init() {}
    
    // MARK: - public methods
    func createTask() {
        if taskDescription != "Enter your task..." && taskDescription != "" && taskDescription != " " {
            let date = dateAndTimeOfTask
            let notification = isNotificationEnabled
            let task = ScheduleTask(id: UUID(), date: date, description: taskDescription, isNotificationEnabled: notification)
            delegate?.didAddTask(task, mode: .task)
        }
    }
}
