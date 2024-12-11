//
//  CreateSceneContainerAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.11.2024.
//

import Foundation
import Swinject

final class CreateScheduleSceneContainerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CreateScheduleSceneProtocol.self) { resolver, container, viewModel in
            CreateSceneDIContainer(container: container, createScheduleDelegate: viewModel)
        }.inObjectScope(.container)
    }
}
