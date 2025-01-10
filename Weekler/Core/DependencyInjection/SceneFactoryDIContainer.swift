//
//  SceneFactoryDIContainer.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.11.2024.
//

import Foundation
import UIKit

final class SceneFactoryDIContainer: SceneFactoryProtocol {
    
    // MARK: - public properties
    var createScheduleSceneContainer: CreateScheduleSceneProtocol?
    
    // MARK: - private properties
    private let container: DIContainer
    
    // MARK: - lifecycle
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    // MARK: - public methods
    func makeScheduleViewController(coor: ScheduleFlowCoordinator) -> ScheduleViewController {
        let hapticsManager = makeCoreHapticsManager()
        let scheduleViewModel: ScheduleViewModelProtocol = container.resolve(
            arguments: self as SceneFactoryProtocol, coor, hapticsManager
        )
        createScheduleSceneContainer = makeCreateScheduleSceneDIContainer(viewModel: scheduleViewModel as? CreateScheduleDelegate)
        let scheduleVC: ScheduleViewController = container.resolve(argument: scheduleViewModel)
        return scheduleVC
    }
    
    func makeConfigViewController(coordinator: SettingsFlowCoordinator) -> AppSettingsViewController {
        let viewModel: AppSettingsViewModelProtocol = container.resolve(argument: coordinator)
        let configVC: AppSettingsViewController = container.resolve(argument: viewModel)
        return configVC
    }
    
    func makeStatisticsView() -> StatisticsViewController {
        let statisticsService: StatisticsServiceProtocol = container.resolve()
        let statisticsViewModel: StatisticsViewModelProtocol = container.resolve(argument: statisticsService)
        let statisticsVC: StatisticsViewController = container.resolve(argument: statisticsViewModel)
        return statisticsVC
    }
    
    func makeCreateScheduleSceneDIContainer(viewModel: CreateScheduleDelegate?) -> CreateScheduleSceneProtocol {
        let createScheduleSceneContainer: CreateScheduleSceneProtocol = container.resolve(arguments: container, viewModel)
        return createScheduleSceneContainer
    }
    
    func makeScheduleUseCase() -> ScheduleUseCaseProtocol {
        let scheduleUseCase: ScheduleUseCaseProtocol = container.resolve()
        return scheduleUseCase
    }
    
    func makeCoreHapticsManager() -> CoreHapticsManagerProtocol? {
        let hapticsManager: CoreHapticsManagerProtocol? = container.resolve()
        return hapticsManager
    }
    
    func makeSettingsScreen(_ screen: SettingsItem) -> UIViewController {
        switch screen {
        case .general:
            let generalVC: GeneralSettingsViewController = container.resolve()
            return generalVC
        case .notification:
            let notificationVC: NotificationSettingsViewController = container.resolve()
            return notificationVC
        case .appearance:
            let viewModel: AppearanceViewModelProtocol = container.resolve()
            let appearanceVC: AppearanceSettingsViewController = container.resolve(argument: viewModel)
            return appearanceVC
        case .date:
            let dateVC: DateSettingsViewController = container.resolve()
            return dateVC
        case .help:
            let helpVC: HelpViewController = container.resolve()
            return helpVC
        case .about:
            let aboutVC: AboutViewController = container.resolve()
            return aboutVC
        }
    }
}
