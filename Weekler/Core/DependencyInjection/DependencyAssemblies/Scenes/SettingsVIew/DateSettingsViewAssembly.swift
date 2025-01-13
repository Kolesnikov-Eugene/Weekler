//
//  DateSettingsViewAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.12.2024.
//

import Swinject

final class DateSettingsViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DateSettingsViewController.self) { _ in
            DateSettingsViewController()
        }.inObjectScope(.container)
    }
}
