//
//  ScheduleStorageDataProvider.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 30.09.2024.
//

import Foundation
import SwiftData

@ModelActor
final actor ScheduleDataSource: ScheduleDataSourceProtocol {
    
    // MARK: - private properties
    private var context: ModelContext { modelExecutor.modelContext }
    
    // MARK: - lifecycle
    init() {
        do {
            let container = try ModelContainer(for: TaskItem.self, ScheduleDate.self)
            self.modelContainer = container
            let context = ModelContext(container)
            modelExecutor = DefaultSerialModelExecutor(modelContext: context)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - public methods
    func fetchTaskItems<T: PersistentModel>(
        predicate: Predicate<T>,
        sortDescriptor: SortDescriptor<T>
    ) -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: [sortDescriptor])
        
        do {
            let scheduleForSelectedDate = try context.fetch(descriptor)
            return scheduleForSelectedDate
        } catch {
            fatalError("Error fetching schedule for selected date: \(error.localizedDescription)")
        }
    }
    
    func insert<T: PersistentModel>(_ model: T) {
        do {
            context.insert(model)
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func delete<T: PersistentModel>(with predicate: Predicate<T>) {
        do {
            try self.context.delete(model: T.self, where: predicate)
            try context.save()
        } catch {
            fatalError("Error deleting task: \(error.localizedDescription)")
        }
    }
    
    func saveContext() {
        do {
            try self.context.save()
        } catch {
            fatalError("Error saving context: \(error.localizedDescription)")
        }
    }
}

// MARK: - StatisticsDataSourceProtocol
extension ScheduleDataSource: StatisticsDataSourceProtocol {}
