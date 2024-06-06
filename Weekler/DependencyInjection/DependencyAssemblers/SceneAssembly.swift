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
            TaskEditorAssembly(),
            ConfigViewAssembly(),
            TabBarFactoryAssembly(),
            CreateScheduleViewAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
