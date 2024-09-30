//
//  TabBarFactory.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Foundation
import SwiftData

final class TabBarFactory: TabBarFactoryProtocol {
    func createScheduleViewController() -> ScheduleViewController {
//            let container = try ModelContainer(for: TaskItem.self)
//            let scheduleDataManager: ScheduleDataManagerProtocol = DIContainer.shared.resolve(argument: container)
        let dataBuilder = DataBuilder()
        let scheduleDataManager: ScheduleDataManagerProtocol = ScheduleDataManager(dataBulder: dataBuilder)
        let scheduleViewModel: ScheduleViewViewModelProtocol = DIContainer.shared.resolve(argument: scheduleDataManager)
        let scheduleVC: ScheduleViewController = DIContainer.shared.resolve(argument: scheduleViewModel)
        return scheduleVC
    }
    
    func createTaskEditorViewController() -> TaskEditorViewController {
        let taskEditorVC: TaskEditorViewController = DIContainer.shared.resolve()
        return taskEditorVC
    }
    
    func createConfigViewController() -> ConfigViewController {
        let configVC: ConfigViewController = DIContainer.shared.resolve()
        return configVC
    }
    
    func createStatisticsView() -> StatisticsViewController {
        let statisticsVC: StatisticsViewController = DIContainer.shared.resolve()
        return statisticsVC
    }
}

final class DataBuilder: ScheduleDataProviderBuilderProtocol {
    func createDataProvider() -> @Sendable () async -> ScheduleStorageDataProviderProtocol {
        do {
            let container = try ModelContainer(for: TaskItem.self)
            return { ScheduleStorageDataProvider(container: container) }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
