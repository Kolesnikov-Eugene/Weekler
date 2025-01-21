//
//  ViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 21.03.2024.
//

import UIKit
import SnapKit
import JTAppleCalendar
import RxSwift
import RxCocoa


final class ScheduleViewController: UIViewController {
    
    //MARK: - private properties
//    private let scheduleMainView: ScheduleMainView!
    private lazy var calendarSwitchRightBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem()
        let image = UIImage(systemName: "calendar")?.withRenderingMode(.alwaysTemplate)
        button.image = image
        button.tintColor = .gray
        button.style = .plain
        button.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        return button
    }()
    private var viewModel: ScheduleViewModelProtocol
    private var bag = DisposeBag()
    
    // MARK: - lifecycle
    init(
        viewModel: ScheduleViewModelProtocol
    ) {
        self.viewModel = viewModel
        
        //FIXME: create DI method in container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let scheduleMainViewModel = viewModel as! ScheduleMainViewModelProtocol
        self.view = ScheduleMainView(frame: .zero, viewModel: scheduleMainViewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        calendarSwitchRightBarButtonItem.target = self
        calendarSwitchRightBarButtonItem.action = #selector(calendarSwitchRightBarButtonItemTapped)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        scheduleTableView.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
        //TODO: - add dinamic content inset when table view will display the lsat cell
        print("controller")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - private methods
    private func setupUI() {
        configureNavBar()
    }
    
    private func bind() {
        
        viewModel.calendarHeightValue
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] height in
                guard let self = self,
                      let height = height else { return }
//                self.remakeCalendarConstraints(with: height)
                self.view.layoutIfNeeded()
            })
            .disposed(by: bag)
        
        viewModel.navigationTitle
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] title in
                self?.navigationItem.title = title
            })
            .disposed(by: bag)
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = calendarSwitchRightBarButtonItem
        if let navBar = navigationController?.navigationBar {
            navBar.prefersLargeTitles = false
            navigationItem.title = "November"
            navBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                NSAttributedString.Key.foregroundColor: Colors.textColorMain
            ]
        }
    }
    
    @objc
    private func calendarSwitchRightBarButtonItemTapped() {
        print("switch")
        // TODO: - add viewModel.calendarSwitchTapped
    }
}
