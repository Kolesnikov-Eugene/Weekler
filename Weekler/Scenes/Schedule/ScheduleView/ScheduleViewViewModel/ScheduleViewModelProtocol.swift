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
    var navigationTitle: BehaviorRelay<String> { get set }
    func task(at index: Int) -> ScheduleTask
    func didTapAddNewEventButton() // delete
    func toggleCalendarAppearance()
    
}

protocol ScheduleMainViewModelProtocol: AnyObject {
    var selectedDate: Date { get }
    var data: [SourceItem] { get set }
    var dataList: PublishRelay<[SourceItem]> { get }
    var emptyStateIsActive: Driver<Bool> { get set }
    func completeTask(with id: UUID)
    func unCompleteTask(with id: UUID)
    func deleteTask(at index: Int)
    func prepareCreateView(at index: Int)
    func playAddTask()
    func didTapAddNewEventButton()
    var calendarStateSwitch: PublishRelay<Bool> { get set }
    
}

protocol CalendarViewModelProtocol: AnyObject {
    var selectedDate: Date { get }
    var currentDateChangesObserver: PublishRelay<Date> { get set }
    func updateNavTitle(with date: [Date])
}

protocol SelectTaskViewModelProtocol: AnyObject {
    func reconfigureMode(_ mode: ScheduleMode)
}
