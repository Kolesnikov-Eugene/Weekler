//
//  ScheduleViewModelAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.07.2024.
//

import Swinject

final class ScheduleViewModelAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ScheduleViewModelProtocol.self) { resolver, dependencies, coordinator in
            return ScheduleViewModel(dependencies: dependencies, scheduleFlowCoordinator: coordinator)
        }.inObjectScope(.container)
    }
}
