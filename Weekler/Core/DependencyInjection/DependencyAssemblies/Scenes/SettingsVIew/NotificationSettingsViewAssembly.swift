//
//  NotificationSettingsViewAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.12.2024.
//

import Swinject

final class NotificationSettingsViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NotificationSettingsViewController.self) { _ in
            NotificationSettingsViewController()
        }.inObjectScope(.container)
    }
}
