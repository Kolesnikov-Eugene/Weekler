//
//  SceneAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 26.04.2024.
//

import Swinject

final class SceneAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        let assemblies: [Assembly] = [
            TabBarAssembly(),
            ScheduleAssembly(),
            StatisticsAssembly(),
            AppSettingsVCAssembly(),
            AppSettingsViewModelAssembly(),
            CreateScheduleViewAssembly(),
            ScheduleViewModelAssembly(),
            CreateScheduleViewModelAssembly(),
            StatisticsViewModelAssembly(),
            GeneralSettingsViewAssembly(),
            NotificationSettingsViewAssembly(),
            AppearanceSettingsViewAssembly(),
            DateSettingsViewAssembly(),
            HelpViewAssembly(),
            AboutViewAssembly(),
            AppearanceViewModelAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
