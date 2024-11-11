//
//  ConfigViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.04.2024.
//

import UIKit

final class ConfigViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupUI() {
        self.view.backgroundColor = Colors.viewBackground
        navigationItem.title = L10n.Localizable.Tab.config
        self.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.config,
            image: UIImage(systemName: "gearshape"),
            selectedImage: nil)
    }
}
