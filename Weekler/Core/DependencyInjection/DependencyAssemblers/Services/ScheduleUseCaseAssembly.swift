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
            guard let repository = resolver.resolve(ScheduleRepositoryProtocol.self) else {
                fatalError("ScheduleRepository could not be resolved")
            }
            return ScheduleUseCase(repository: repository)
        }.inObjectScope(.container)
    }
}
