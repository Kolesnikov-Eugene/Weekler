//
//  ScheduleDataManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import SwiftData
import Foundation

final class ScheduleDataManager: ScheduleDataManagerProtocol {
    private lazy var context: ModelContext = {
        do {
            let container = try ModelContainer(for: TaskItem.self)
            let context = ModelContext(container)
            return context
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    init() {}
    
    // MARK: - public methods
    func fetchTaskItems<T: ScheduleDataBaseType>(sortDescriptor: SortDescriptor<T>, _ completion: (Result<[T], Error>) -> Void) {
        let descriptor = FetchDescriptor<T>(sortBy: [sortDescriptor])
        
        do {
            completion(.success(try context.fetch(descriptor)))
        } catch {
            completion(.failure(error))
        }
    }
    
    func insert<T: ScheduleDataBaseType>(_ model: T) {
        context.insert(model)
    }
    
    func delete<T: ScheduleDataBaseType>(_ model: T) {
        context.delete(model)
    }
}

protocol ScheduleDataManagerProtocol {
    func fetchTaskItems<T: ScheduleDataBaseType>(sortDescriptor: SortDescriptor<T>, _ completion: (Result<[T], Error>) -> Void)
    func insert<T: ScheduleDataBaseType>(_ model: T)
}
