//
//  SceneFactoryDIContainer.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.11.2024.
//

import Foundation

final class SceneFactoryDIContainer: SceneFactoryProtocol {
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func makeScheduleViewController() -> ScheduleViewController {
        let scheduleUseCase: ScheduleUseCaseProtocol = container.resolve()
        let scheduleViewModel: ScheduleViewModelProtocol = container.resolve(argument: scheduleUseCase)
        let scheduleVC: ScheduleViewController = container.resolve(argument: scheduleViewModel)
        return scheduleVC
    }
    
    func makeTaskEditorViewController() -> TaskEditorViewController {
        let taskEditorVC: TaskEditorViewController = container.resolve()
        return taskEditorVC
    }
    
    func makeConfigViewController() -> ConfigViewController {
        let configVC: ConfigViewController = container.resolve()
        return configVC
    }
    
    func makeStatisticsView() -> StatisticsViewController {
        let statisticsVC: StatisticsViewController = container.resolve()
        return statisticsVC
    }
}
