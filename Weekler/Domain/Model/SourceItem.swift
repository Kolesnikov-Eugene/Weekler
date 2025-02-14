//
//  SourceItem.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.07.2024.
//

import Foundation

enum SourceItem: Hashable, Comparable {
    case task(ScheduleTask)
    case priority(Priority)
    case goal(Goal)
    case completedTask(ScheduleTask)
    
    static func < (lhs: SourceItem, rhs: SourceItem) -> Bool {
        let left: SourceItemProtocol? = lhs.castSelfToModel
        let right: SourceItemProtocol? = rhs.castSelfToModel
        
        guard let left,
              let right else { return false }
        
//        return left.date < right.date
        return left.id < right.id
    }
    
    var castSelfToModel: SourceItemProtocol? {
        switch self {
        case .goal(let goal):
            return goal
        case .priority(let priority):
            return priority
        case .task(let task):
            return task
        case .completedTask(let completedTask):
            return completedTask
        }
    }
}
