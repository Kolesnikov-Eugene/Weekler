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
    
    // MARK: - UI
    private lazy var saveButton: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(
            systemName: "checkmark",
            withConfiguration: configuration)?
            .withTintColor(
                Colors.mainForeground,
                renderingMode: .alwaysOriginal
            )
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(saveButtonTapped))
        return item
    }()
    private lazy var cancelButtonItem: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 18)
        let image = UIImage(
            systemName: "xmark",
            withConfiguration: configuration)?
            .withTintColor(
                Colors.mainForeground,
                renderingMode: .alwaysOriginal
            )
        let item = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cancelButtonTapped))
        return item
    }()
    
    // MARK: - private properties
    private var viewModel: CreateScheduleViewModelProtocol
    private var mode: CreateMode
    private var bag = DisposeBag()
    private weak var coordinator: CreateScheduleFlowCoordinator?
    
    // MARK: - lifecycle
    init(
        viewModel: CreateScheduleViewModelProtocol,
        mode: CreateMode,
        coordinator: CreateScheduleFlowCoordinator?
    ) {
        self.viewModel = viewModel
        self.mode = mode
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        withUnsafePointer(to: self) { print("\($0)") }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let scheduleItemsTableViewController = CreateScheduleTableViewController(viewModel: viewModel)
        self.view = CreateScheduleView(
            viewModel: viewModel,
            mode: mode,
            scheduleItemsTableViewController: scheduleItemsTableViewController,
            frame: .zero
        )
        
        addChild(scheduleItemsTableViewController)
        scheduleItemsTableViewController.didMove(toParent: self)
        
        viewModel.hideView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.finish()
            })
            .disposed(by: bag)
        
        viewModel.needsPresentView
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] vc in
                self?.navigationController?.pushViewController(vc, animated: true)
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
        navigationItem.title = "Create Schedule"
        navigationItem.leftBarButtonItem = cancelButtonItem
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc
    private func saveButtonTapped() {
        viewModel.saveTask()
    }
    
    @objc
    private func cancelButtonTapped() {
        coordinator?.finish()
//        dismiss(animated: true)
    }
    
//    private func configureAppearence() {
//        if let sheet = self.sheetPresentationController {
//            sheet.detents = [.large(), .medium()]
//            sheet.largestUndimmedDetentIdentifier = .large
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            sheet.prefersEdgeAttachedInCompactHeight = true
//            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
//        }
//    }
}
