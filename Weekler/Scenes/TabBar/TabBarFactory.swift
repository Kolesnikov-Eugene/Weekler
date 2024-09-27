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
        do {
            let container = try ModelContainer(for: TaskItem.self)
            let scheduleDataManager: ScheduleDataManagerProtocol = DIContainer.shared.resolve(argument: container)
            let scheduleViewModel: ScheduleViewViewModelProtocol = DIContainer.shared.resolve(argument: scheduleDataManager)
            let scheduleVC: ScheduleViewController = DIContainer.shared.resolve(argument: scheduleViewModel)
            return scheduleVC
        } catch {
            fatalError(error.localizedDescription)
        }
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
