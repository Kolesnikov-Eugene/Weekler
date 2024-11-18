//
//  StatisticsViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 08.04.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private var statisticsView: StatisticsView!
    private let viewModel: StatisticsViewModelProtocol
    
    init(
        viewModel: StatisticsViewModelProtocol
    ) {
        self.viewModel = viewModel
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
        super.loadView()
        view = StatisticsView(frame: .zero, viewModel: viewModel)
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
