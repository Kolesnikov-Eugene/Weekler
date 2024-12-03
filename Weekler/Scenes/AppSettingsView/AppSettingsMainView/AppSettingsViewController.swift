//
//  ConfigViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.04.2024.
//

import UIKit

final class AppSettingsViewController: UIViewController {
    private var appSettingsMainView: AppSettingsMainView!
    
    init() {
        appSettingsMainView = AppSettingsMainView(frame: .zero)
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = appSettingsMainView
    }
    
    private func setupUI() {
        navigationItem.title = L10n.Localizable.Tab.config
        self.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.config,  // FIXME: rename tab title
            image: UIImage(systemName: "gearshape"),
            selectedImage: nil)
    }
}