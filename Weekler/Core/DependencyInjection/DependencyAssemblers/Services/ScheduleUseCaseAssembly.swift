//
//  ScheduleDataManagerAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.08.2024.
//

import Swinject

final class ScheduleUseCaseAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ScheduleUseCaseProtocol.self) { resolver in
            ScheduleUseCase()
        }.inObjectScope(.container)
    }
}
