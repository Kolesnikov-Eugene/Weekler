//
//  HelpViewAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.12.2024.
//

import Swinject

final class HelpViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HelpViewController.self) { _ in
            HelpViewController()
        }.inObjectScope(.container)
    }
}
