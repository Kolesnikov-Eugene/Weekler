//
//  TabBarFactoryProtocol.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Foundation
import UIKit

protocol SceneFactoryProtocol {
    var createScheduleSceneContainer: CreateScheduleSceneProtocol? { get }
    func makeScheduleViewController(coor: ScheduleFlowCoordinator) -> ScheduleViewController
    func makeConfigViewController(coordinator: SettingsFlowCoordinator) -> AppSettingsViewController
    func makeStatisticsView() -> StatisticsViewController
    func makeScheduleUseCase() -> ScheduleUseCaseProtocol
    func makeCoreHapticsManager() -> CoreHapticsManagerProtocol?
    func makeSettingsScreen(_ screen: SettingsItem) -> UIViewController
}
