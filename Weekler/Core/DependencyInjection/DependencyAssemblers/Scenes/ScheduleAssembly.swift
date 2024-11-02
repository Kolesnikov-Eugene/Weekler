//
//  ScheduleAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 26.04.2024.
//

import Swinject

final class ScheduleAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ScheduleViewController.self) { resolver, viewModel, container in
            ScheduleViewController(viewModel: viewModel, createScheduleSceneDIContainer: container)
        }.inObjectScope(.container)
    }
}
