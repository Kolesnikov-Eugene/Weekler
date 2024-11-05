//
//  ScheduleRepository.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 05.11.2024.
//

import Foundation

final class ScheduleRepository {
    private let dataSource: ScheduleDataSourceProtocol
    
    init(dataSource: ScheduleDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchTaskItems<T>(
        taskId: UUID,
        sortDescriptor: SortDescriptor<T>) async where T : ScheduleDataBaseType {
            let predicate = #Predicate<TaskItem> { $0.id == taskId }
    }
    
    func insert<T>(_ model: T) async where T : ScheduleDataBaseType {
        //impl
    }
    
    func delete<T>(_ id: UUID, predicate: Predicate<T>) async where T : ScheduleDataBaseType {
        //impl
    }
    
    func edit(_ task: ScheduleTask) async {
        //impl
    }
    
    func complete(_ task: ScheduleTask) async {
        //impl
    }
    
    func unComplete(_ task: ScheduleTask) async {
        //impl
    }
}

protocol ScheduleDataSourceProtocol {
    
}
