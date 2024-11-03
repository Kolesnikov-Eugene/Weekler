//
//  ScheduleViewVIewModelProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.05.2024.
//

import Foundation
import RxCocoa

protocol ScheduleViewModelProtocol: AnyObject {
    var tasks: [ScheduleTask] { get set }
    var data: [SourceItem] { get set }
    var dataList: BehaviorRelay<[SourceItem]> { get }
    var emptyStateIsActive: Driver<Bool> { get set }
    var setCreateViewNeedsToBePresented: BehaviorRelay<Bool> { get set }
    var presentCreateViewEditingAtIndex: BehaviorRelay<Int?> { get set }
    var calendarHeightValue: BehaviorRelay<Double?> { get set }
    var navigationTitle: BehaviorRelay<String> { get set }
    func reconfigureMode(_ mode: ScheduleMode)
    func deleteTask(at index: Int)
    func task(at index: Int) -> ScheduleTask
    func completeTask(with id: UUID)
    func unCompleteTask(with id: UUID)
    func didTapAddNewEventButton()
    func prepareCreateView(at index: Int)
}

protocol ScheduleMainViewModelProtocol: AnyObject {
    var data: [SourceItem] { get set }
    var dataList: BehaviorRelay<[SourceItem]> { get }
    var emptyStateIsActive: Driver<Bool> { get set }
    func completeTask(with id: UUID)
    func unCompleteTask(with id: UUID)
    func deleteTask(at index: Int)
    func prepareCreateView(at index: Int)
}

protocol CalendarViewModelProtocol: AnyObject {
    var selectedDate: Date { get }
    var currentDateChangesObserver: BehaviorRelay<Date> { get set }
    func updateNavTitle(with date: [Date])
    func setCalendarViewWith(_ height: Double)
}

protocol SelectTaskViewModelProtocol: AnyObject {
    func reconfigureMode(_ mode: ScheduleMode)
}
