//
//  StatisticsAssembly.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.05.2024.
//

import Swinject

final class StatisticsAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(StatisticsViewController.self) { _ in
            StatisticsViewController()
        }
    }
}
