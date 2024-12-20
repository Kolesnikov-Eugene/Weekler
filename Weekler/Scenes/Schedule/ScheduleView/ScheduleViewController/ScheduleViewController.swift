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
    private let calendarView: CalendarView
    private let selectTaskModeView: SelectTaskModeView
    private let scheduleMainView: ScheduleMainView
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
    
    // TODO: Create DI method for creating hapticsManager
    init(
        viewModel: ScheduleViewModelProtocol
    ) {
        self.viewModel = viewModel
        
        //FIXME: create DI method in container
        let calendarViewModel = viewModel as! CalendarViewModelProtocol
        let selectTaskViewModel = viewModel as! SelectTaskViewModelProtocol
        let scheduleMainViewModel = viewModel as! ScheduleMainViewModelProtocol
        calendarView = CalendarView(frame: .zero, viewModel: calendarViewModel)
        scheduleMainView = ScheduleMainView(frame: .zero, viewModel: scheduleMainViewModel)
        selectTaskModeView = SelectTaskModeView(frame: .zero, viewModel: selectTaskViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        calendarSwitchRightBarButtonItem.target = calendarView
        calendarSwitchRightBarButtonItem.action = #selector(CalendarView.calendarSwitchRightBarButtonItemTapped)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        scheduleTableView.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
        //TODO: - add dinamic content inset when table view will display the lsat cell
        print("controller")
    }
    
    //MARK: - private methods
    private func setupUI() {
        self.view.backgroundColor = Colors.viewBackground
        configureNavBar()
        addSubviews()
        applyConstraints()
        configureTabBarAppearence()
    }
    
    private func configureTabBarAppearence() {
        let image = UIImage(systemName: "list.bullet.clipboard")
        self.tabBarItem = UITabBarItem(
            title: L10n.Localizable.Tab.schedule,
            image: image,
            selectedImage: nil)
    }
    
    private func bind() {
        
        viewModel.calendarHeightValue
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] height in
                guard let self = self,
                      let height = height else { return }
                self.remakeCalendarConstraints(with: height)
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
    
    private func addSubviews() {
        let subviews = [
            calendarView,
            selectTaskModeView,
            scheduleMainView
        ]
        subviews.forEach { view.addSubview($0) }
    }
    
    private func applyConstraints() {
        //calendarView constraints
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
//            $0.height.equalTo(70)
        }
        
        //selectTaskModeView constraints
        selectTaskModeView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(25)
        }
        
        // scheduleMainView constraints
        scheduleMainView.snp.makeConstraints {
            $0.top.equalTo(selectTaskModeView.snp.bottom)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func remakeCalendarConstraints(with height: CGFloat) {
        calendarView.snp.remakeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(height)
        }
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
}
