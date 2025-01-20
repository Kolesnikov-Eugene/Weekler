//
//  CreateScheduleViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.06.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum CreateMode {
    case create
    case edit
}

final class CreateScheduleViewController: UIViewController {
    
    // MARK: - private properties
    private var viewModel: CreateScheduleViewModelProtocol
    private var mode: CreateMode
    private var bag = DisposeBag()
    
    // MARK: - lifecycle
    init(
        viewModel: CreateScheduleViewModelProtocol,
        mode: CreateMode
    ) {
        self.viewModel = viewModel
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        withUnsafePointer(to: self) { print("\($0)") }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = CreateScheduleView(
            viewModel: viewModel,
            mode: mode,
            frame: .zero
        )
        
        viewModel.hideView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    //MARK: - private methods
    private func setupUI() {
        configureAppearence()
    }
    
    private func configureAppearence() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
    }
}
