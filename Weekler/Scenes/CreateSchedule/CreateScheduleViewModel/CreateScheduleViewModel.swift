//
//  CreateScheduleViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.08.2024.
//

import Foundation

final class CreateScheduleViewModel: CreateScheduleViewModelProtocol {
    var dateAndTimeOfTask: Date = Date()
    
    var taskDescription: String = ""
    
    var isNotificationEnabled: Bool = false
    
    
    init() {
        print("Inited")
    }
}
