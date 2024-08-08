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
    
    static func < (lhs: SourceItem, rhs: SourceItem) -> Bool {
        let left: SourceItemProtocol? = lhs.castSelfToModel
        let right: SourceItemProtocol? = rhs.castSelfToModel
        
        guard let left = left,
              let right = right else { return false }
        
        return left.date < right.date
    }
    
    var castSelfToModel: SourceItemProtocol? {
        var item: SourceItemProtocol?
        switch self {
        case .goal(let goal):
            item = goal
        case .priority(let priority):
            item = priority
        case .task(let task):
            item = task
        }
        return item
    }
    
    private func getTypeOfSelf() -> SourceItemProtocol? {
        var item: SourceItemProtocol?
        switch self {
        case .goal(let goal):
            item = goal
        case .priority(let priority):
            item = priority
        case .task(let task):
            item = task
        }
        return item
    }
}
