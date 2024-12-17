//
//  AppearanceSettingsViewAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.12.2024.
//

import Swinject

final class AppearanceSettingsViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppearanceSettingsViewController.self) { _ in
            AppearanceSettingsViewController()
        }.inObjectScope(.container)
    }
}