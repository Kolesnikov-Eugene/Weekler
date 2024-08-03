//
//  CreateScheduleViewModelProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.08.2024.
//

import Foundation

protocol CreateScheduleViewModelProtocol: AnyObject {
    var dateAndTimeOfTask: Date { get set }
    var taskDescription: String { get set }
    var isNotificationEnabled: Bool { get set }
}
