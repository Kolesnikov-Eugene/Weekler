//
//  CreateScheduleViewModelProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.08.2024.
//

import Foundation
import RxCocoa

protocol CreateScheduleViewModelProtocol: AnyObject {
    var textFieldValue: BehaviorRelay<String> { get set }
    var datePickerValue: BehaviorRelay<Date> { get set }
    var notificationSwitchValue: BehaviorRelay<Bool> { get set }
    var delegate: CreateScheduleDelegate? { get set }
    var taskDescription: String { get set }
    func createTask()
    func editTask()
    func set(_ date: Date)
    func set(_ notification: Bool)
    // protocol
    func saveDateRange()
}
