//
//  GeneralSettingsViewAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.12.2024.
//

import Swinject

final class GeneralSettingsViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GeneralSettingsViewController.self) { _ in
            GeneralSettingsViewController()
        }.inObjectScope(.container)
    }
}
