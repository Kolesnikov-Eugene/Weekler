//
//  ScheduleMainView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 28.10.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ScheduleMainView: UIView {
    
    // MARK: - private properties
    
    private let calendarView: CalendarView
    private let selectTaskModeView: SelectTaskModeView
    private let scheduleTableViewController: ScheduleTableViewController
    private lazy var addNewEventButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
        configuration.baseForegroundColor = Colors.mainForeground
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 40)
        
        let action = UIAction { [weak self] _ in
            self?.viewModel.didTapAddNewEventButton()
        }
        let button = UIButton(configuration: configuration, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private lazy var emptyStateImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .clock)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewModel: ScheduleMainViewModelProtocol
    private var bag = DisposeBag()
    
    // MARK: - lifecycle
    init(
        frame: CGRect,
        viewModel: ScheduleMainViewModelProtocol
    ) {
        self.viewModel = viewModel
        let calendarViewModel = viewModel as! CalendarViewModelProtocol
        let selectTaskViewModel = viewModel as! SelectTaskViewModelProtocol
        calendarView = CalendarView(frame: .zero, viewModel: calendarViewModel)
        selectTaskModeView = SelectTaskModeView(frame: .zero, viewModel: selectTaskViewModel)
        scheduleTableViewController = ScheduleTableViewController(viewModel: viewModel)
        super.init(frame: frame)
        setupUI()
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emptyStateImageView.layer.cornerRadius = CGRectGetWidth(CGRect(origin: CGPoint.zero, size: emptyStateImageView.bounds.size)) / 2
    }
    
    // MARK: - private methods
    private func setupUI() {
//        backgroundColor = Colors.viewBackground
        backgroundColor = .clear
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        guard let scheduleTableView = scheduleTableViewController.tableView else {
            return
        }
        let views = [
            calendarView,
            selectTaskModeView,
            scheduleTableView,
            addNewEventButton,
            emptyStateImageView
        ]
        views.forEach { addSubview($0) }
    }
    
    private func applyConstraints() {
        guard let scheduleTableView = scheduleTableViewController.tableView else {
            return
        }
        //calendarView constraints
        calendarView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(70)
        }

        //selectTaskModeView constraints
        selectTaskModeView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).inset(16)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(25)
        }
        
        //scheduleTableView Constraints
        scheduleTableView.snp.makeConstraints {
            $0.top.equalTo(selectTaskModeView.snp.bottom)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        //addNewEventButton constraints
        addNewEventButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.trailing.equalTo(snp.trailing).inset(16)
        }
        
        //emptyStateImageView constraints
        emptyStateImageView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
            $0.width.equalTo(250)
            $0.height.equalTo(250)
        }
    }

    private func remakeCalendarConstraints(with height: CGFloat) {
        calendarView.snp.remakeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(height)
        }
    }
    
    private func bindToViewModel() {
        viewModel.emptyStateIsActive
            .drive(emptyStateImageView.rx.isHidden)
            .disposed(by: bag)
    }
}
