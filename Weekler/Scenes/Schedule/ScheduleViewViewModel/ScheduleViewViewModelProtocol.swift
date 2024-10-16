//
//  ScheduleViewVIewModelProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.05.2024.
//

import Foundation
import RxCocoa

protocol ScheduleViewViewModelProtocol: AnyObject {
    var selectedDate: Date { get }
    var tasks: [ScheduleTask] { get set }
    var priorities: [Priority] { get set }
    var goals: [Goal] { get set }
    var data: [SourceItem] { get set }
    var dataList: BehaviorRelay<[SourceItem]> { get }
    var emptyStateIsActive: Driver<Bool> { get set }
    var currentDateChangesObserver: BehaviorRelay<Date> { get set }
    func reconfigureMode(_ mode: ScheduleMode)
    func deleteTask(at index: Int)
    func task(at index: Int) -> ScheduleTask
    func completeTask(with id: UUID)
    func unCompleteTask(with id: UUID)
//    func getSelectedDate() -> Date
}
