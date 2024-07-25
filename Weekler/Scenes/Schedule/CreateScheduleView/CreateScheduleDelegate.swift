//
//  CreateScheduleDelegate.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 25.07.2024.
//

import Foundation

protocol CreateScheduleDelegate: AnyObject {
    func didAddTask(_ task: ScheduleTask, mode: ScheduleMode)
}
