//
//  SourceItem.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.07.2024.
//

import Foundation

enum SourceItem: Hashable {
    case task(ScheduleTask)
    case priority(Priority)
    case goal(Goal)
}
