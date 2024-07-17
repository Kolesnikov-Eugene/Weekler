//
//  ScheduleViewVIewModelProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.05.2024.
//

import Foundation

protocol ScheduleViewViewModelProtocol: AnyObject {
    var tasks: [ScheduleTask] { get set }
    var priorities: [Priority] { get set }
    var goals: [Goal] { get set }
    var data: [SourceItem] { get set }
}
