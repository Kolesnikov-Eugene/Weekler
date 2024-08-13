//
//  ScheduleDataManagerAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import Swinject

final class ScheduleDataManagerAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ScheduleDataManagerProtocol.self) { _ in
            ScheduleDataManager()
        }.inObjectScope(.container)
    }
}
