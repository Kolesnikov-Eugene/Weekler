//
//  WeeklerAppDIContainer.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.11.2024.
//

import Foundation

final class WeeklerAppDIContainer {
    
    // MARK: - private properties
    private let container: DIContainer
    
    // MARK: - lifecycle
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    // MARK: - public methods
    func makeTabBarController() -> TabBarController {
        let tabBarController: TabBarController = container.resolve()
        return tabBarController
    }
    
    func makeSceneFactoryDIContainer() -> SceneFactoryProtocol {
        let sceneFactory: SceneFactoryProtocol = container.resolve(argument: container)
        return sceneFactory
    }
}
