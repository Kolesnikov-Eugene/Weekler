//
//  ServiceAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.11.2024.
//

import Swinject

final class ServiceAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        let assemblies: [Assembly] = [
            SceneFactoryAssembly(),
            ScheduleUseCaseAssembly(),
            CreateScheduleSceneContainerAssembly(),
            ScheduleRepositoryAssembly(),
            ScheduleDataSourceAssembly(),
            CoreHapticsManagerAssembly(),
            StatisticsServiceAssembly(),
            StatisticsRepositoryAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
