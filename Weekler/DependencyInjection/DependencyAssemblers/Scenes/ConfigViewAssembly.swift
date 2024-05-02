//
//  ConfigViewAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Swinject

final class ConfigViewAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(ConfigViewController.self) { _ in
            ConfigViewController()
        }
    }
}
