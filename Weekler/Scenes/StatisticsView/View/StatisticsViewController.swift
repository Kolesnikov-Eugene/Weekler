//
//  StatisticsViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.04.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
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
        navigationItem.title = L10n.Localizable.Tab.statistics
        self.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.statistics,
            image: UIImage(systemName: "chart.bar.xaxis"),
            selectedImage: nil)
    }
}
