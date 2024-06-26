//
//  CreateScheduleViewAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.06.2024.
//

import Swinject

final class CreateScheduleViewAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(CreateScheduleViewController.self) { _ in
            CreateScheduleViewController()
        }.inObjectScope(.container)
    }
}