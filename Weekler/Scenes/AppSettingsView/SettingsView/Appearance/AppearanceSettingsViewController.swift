//
//  AppearanceSettingsViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 12.12.2024.
//

import UIKit

final class AppearanceSettingsViewController: UIViewController {
    
    // MARK: - private properties
    private lazy var backButtonItem: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(
            systemName: "arrow.left",
            withConfiguration: configuration)?
            .withTintColor(
                Colors.mainForeground,
                renderingMode: .alwaysOriginal
            )
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        return item
    }()
    private let appearanceSettingsView: AppearanceSettingsView!
    private let viewModel: AppearanceViewModelProtocol
    
    // TODO: - pass DIContainter to inject instances of views
    init(
        viewModel: AppearanceViewModelProtocol
    ) {
        self.viewModel = viewModel
        self.appearanceSettingsView = AppearanceSettingsView(viewModel: viewModel, frame: .zero)
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    private func setupView() {
        configureNavController()
    }
    
    private func configureNavController() {
        navigationItem.title = "Appearance"
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    override func loadView() {
        super.loadView()
        view = appearanceSettingsView
    }
    
    // TODO: - move implementation to Coordinator
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
