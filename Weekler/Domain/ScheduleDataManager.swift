//
//  ScheduleDataManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import SwiftData
import Foundation
import RxSwift
import RxCocoa

final class ScheduleDataManager: ScheduleDataManagerProtocol {
    
    // MARK: - public properties
    var onContextUpdate: (() -> ())?
//    var contextDidUpdate = BehaviorRelay<Bool>(value: false)
    // MARK: - private properties
    private lazy var context: ModelContext = {
        do {
            let container = try ModelContainer(for: TaskItem.self)
            let context = ModelContext(container)
            return context
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    init() {
        subscribeToContextUpdates()
//        contextDidUpdate.accept(true)
    }
    
    // MARK: - public methods
    func fetchTaskItems<T: ScheduleDataBaseType>(
        predicate: Predicate<T>,
        sortDescriptor: SortDescriptor<T>,
        _ completion: (Result<[T], Error>
        ) -> Void) {
        let descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: [sortDescriptor])
        
        do {
            completion(.success(try context.fetch(descriptor)))
        } catch {
            completion(.failure(error))
        }
    }
    
    func insert<T: ScheduleDataBaseType>(_ model: T) {
        context.insert(model)
//        contextDidUpdate.accept(true)
    }
    
    func delete<T: ScheduleDataBaseType>(_ id: UUID, predicate: Predicate<T>) {
        try? context.delete(model: T.self, where: predicate)
//        contextDidUpdate.accept(true)
    }
    
    func edit(_ task: ScheduleTask) {
        let id: UUID = task.id
        let predicate = #Predicate<TaskItem> { $0.id == id }
        let descriptor = FetchDescriptor<TaskItem>(predicate: predicate)
        let items = try? context.fetch(descriptor)
        if let taskToEdit = items?.first {
            taskToEdit.editWithNew(task)
//            contextDidUpdate.accept(true)
        }
    }
    
    func complete(_ task: ScheduleTask) {
        let id: UUID = task.id
        let predicate = #Predicate<TaskItem> { $0.id == id }
        let descriptor = FetchDescriptor<TaskItem>(predicate: predicate)
        let items = try? context.fetch(descriptor)
        if let taskToEdit = items?.first {
            let completedTask = CompletedTask(id: UUID(), task: taskToEdit)
            taskToEdit.completed = completedTask
//            contextDidUpdate.accept(true)
        }
    }
    
    // MARK: - private methods
    private func subscribeToContextUpdates() {
//        NotificationCenter.default
//            .addObserver(
//                self,
//                selector: #selector(modelContextDidUpdate),
//                name: .NSManagedObjectContextDidSaveObjectIDs,
//                object: nil
//            )
        
        NotificationCenter.default
            .addObserver(
                forName: .NSManagedObjectContextObjectsDidChange,
                object: nil,
                queue: .main) { [weak self] _ in
                self?.onContextUpdate?()
            }
    }
    
    @objc private func modelContextDidUpdate() {
//        onContextUpdate?()
//        contextDidUpdate.accept([true])
    }
}

protocol ScheduleDataManagerProtocol {
//    var contextDidUpdate: BehaviorRelay<Bool> { get set }
    var onContextUpdate: (() -> ())? { get set }
    func fetchTaskItems<T: ScheduleDataBaseType>(
        predicate: Predicate<T>,
        sortDescriptor: SortDescriptor<T>,
        _ completion: (Result<[T], Error>) -> Void)
    func insert<T: ScheduleDataBaseType>(_ model: T)
    func delete<T: ScheduleDataBaseType>(_ id: UUID, predicate: Predicate<T>)
    func edit(_ task: ScheduleTask)
    func complete(_ task: ScheduleTask)
}
