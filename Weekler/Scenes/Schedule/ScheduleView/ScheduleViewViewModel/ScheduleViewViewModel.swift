//
//  ScheduleViewViewModel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.05.2024.
//

import Foundation
import RxSwift
import RxCocoa

final class ScheduleViewViewModel: ScheduleViewViewModelProtocol {
    //MARK: - public properties
    var tasks: [ScheduleTask] = [
        ScheduleTask(id: UUID(), date: Date(), description: "Buy 10 eggs in supermarket"),
        ScheduleTask(id: UUID(), date: Date(), description: "Do homewark"),
        ScheduleTask(id: UUID(), date: Date(), description: "Call grandma")
    ]
    
    var priorities: [Priority] = [
        Priority(id: UUID(), date: Date(), description: "Study"),
        Priority(id: UUID(), date: Date(), description: "Sport"),
        Priority(id: UUID(), date: Date(), description: "Relax")
    ]
    
    var goals: [Goal] = [
        Goal(id: UUID(), date: Date(), description: "Sport 3 times"),
        Goal(id: UUID(), date: Date(), description: "Listen 5 lectures"),
        Goal(id: UUID(), date: Date(), description: "10000 steps every day")
    ]
    
    var data: [SourceItem]
    var mainMode: ScheduleMode = .task
    
    init() {
        data = []
        print("ScheduleViewModel init")
    }
}
