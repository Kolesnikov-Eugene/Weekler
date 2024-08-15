//
//  TabBarFactory.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Foundation

final class TabBarFactory: TabBarFactoryProtocol {
    func createScheduleViewController() -> ScheduleViewController {
        let scheduleDataManager: ScheduleDataManagerProtocol = DIContainer.shared.resolve()
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
