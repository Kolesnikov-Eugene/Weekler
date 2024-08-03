//
//  CreateScheduleViewModelAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 03.08.2024.
//

import Swinject

final class CreateScheduleViewModelAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(CreateScheduleViewModelProtocol.self) { _ in
            CreateScheduleViewModel()
        }.inObjectScope(.container)
    }
}
