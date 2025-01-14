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
    var calendarHeightValue: PublishRelay<Double?> { get set }
    var navigationTitle: BehaviorRelay<String> { get set }
    func task(at index: Int) -> ScheduleTask
    func didTapAddNewEventButton() // delete
}

protocol ScheduleMainViewModelProtocol: AnyObject {
    var selectedDate: Date { get }
    var data: [SourceItem] { get set }
    var dataList: BehaviorRelay<[SourceItem]> { get }
    var emptyStateIsActive: Driver<Bool> { get set }
    func completeTask(with id: UUID)
    func unCompleteTask(with id: UUID)
    func deleteTask(at index: Int)
    func prepareCreateView(at index: Int)
    func playAddTask()
    func didTapAddNewEventButton()
}

protocol CalendarViewModelProtocol: AnyObject {
    var selectedDate: Date { get }
    var currentDateChangesObserver: PublishRelay<Date> { get set }
    func updateNavTitle(with date: [Date])
    func setCalendarViewWith(_ height: Double)
}

protocol SelectTaskViewModelProtocol: AnyObject {
    func reconfigureMode(_ mode: ScheduleMode)
}
