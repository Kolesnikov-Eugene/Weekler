//
//  AboutViewAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.12.2024.
//

import Swinject

final class AboutViewAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AboutViewController.self) { _ in
            AboutViewController()
        }.inObjectScope(.container)
    }
}
