//
//  ContainerViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 02.04.2024.
//

import UIKit

final class ContainerViewController: UIViewController {
    
    let homeVC = HomeViewController()
    let menuVC = SideMenuViewController()
    var navController: UINavigationController?
    
    private var menuState: MenuState = .closed

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
        
        homeVC.delegate = self
        
        addChildVCs()
    }
    
    private func addChildVCs() {
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        let navigationController = UINavigationController(rootViewController: homeVC)
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
        navController = navigationController
    }
}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        switch menuState {
        case .closed:
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut) {
                    self.navController?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
                } completion: { [weak self] done in
                    if done {
                        self?.menuState = .opened
                    }
                }

        case .opened:
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: .curveEaseInOut) {
                    self.navController?.view.frame.origin.x = 0
                } completion: { [weak self] done in
                    if done {
                        self?.menuState = .closed
                    }
                }
        }
    }
}
