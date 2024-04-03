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
    let scheduleVC = CreateScheduleViewController()
    var navController: UINavigationController?
    
    private var menuState: MenuState = .closed

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.background
//        self.menuVC.view.frame.size.width = 0
        
        homeVC.delegate = self
        menuVC.delegate = self
        scheduleVC.delegate = self
        
        addChildVCs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        toggleMenu(completion: nil)
    }
    
    private func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: .curveLinear) {
                    self.navController?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
//                    self.menuVC.view.frame.size.width = self.homeVC.view.bounds.size.width - 100
//                    self.view.bringSubviewToFront(self.menuVC.view)
                } completion: { [weak self] done in
                    //                    self?.menuState = .opened
                    if done {
                        self?.menuState = .opened
                    }
                }
            
        case .opened:
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: .curveLinear) {
                    self.navController?.view.frame.origin.x = 0
//                    self.menuVC.view.frame.size.width = self.homeVC.view.frame.size.width - 100
//                    self.menuVC.view.frame.size.width = 0
//                    self.view.sendSubviewToBack(self.menuVC.view)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        completion?()
//                    }
                } completion: { [weak self] done in
                    if done {
                        self?.menuState = .closed
                        DispatchQueue.main.async {
                            completion?()
                        }
                    }
                }
        }
    }
}

extension ContainerViewController: SideMenuViewControllerDelegate {
    func didSelect(menuItem: MenuOptions) {
        toggleMenu { [weak self] in
            guard let self = self else {
                return assertionFailure("Failure while implmenting toggle menu")
            }
            switch menuItem {
            case .currentWeek:
                self.prepareView(with: self.homeVC)
            case .planSchedule:
                self.prepareView(with: self.scheduleVC)
            case .edit:
                break
            case .statistics:
                break
            case .settings:
                break
            }
        }
    }
    
    private func prepareView(with viewController: UIViewController) {
        clearViews()
        
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        
        let navigationController = UINavigationController(rootViewController: viewController)
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
        navController = navigationController
    }
    
    private func clearViews() {
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
    }
}
