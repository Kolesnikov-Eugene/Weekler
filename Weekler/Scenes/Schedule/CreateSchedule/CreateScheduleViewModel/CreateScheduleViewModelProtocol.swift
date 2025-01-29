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
    var viewNeedsResetToDefault: PublishRelay<Bool> { get set }
    var textFieldNeedsToBecomeFirstResponder: PublishRelay<Bool> { get set }
    var hideView: PublishRelay<Bool> { get set }
    var delegate: CreateScheduleDelegate? { get set }
    var taskDescription: String { get set }
    var needsPresentView: PublishRelay<SelectRepeatedDaysViewController> { get set }
    var processSavingTask: PublishRelay<Bool> { get set }
    func createTask()
    func editTask()
    func set(_ date: Date)
    func set(_ notification: Bool)
    // protocol
    func saveDateRange()
    func viewDidDisappear()
    func viewWillAppear()
    func hideCreateView()
    func presentViewController(_ vc: SelectRepeatedDaysViewController)
    func saveTask()
}
