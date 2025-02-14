//
//  SelectRepeatedDaysViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.07.2024.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectRepeatedDaysViewController: UIViewController {
    // MARK: - private properties
    private let reuseId = "DayOfWeekTableView"
    private let segmentedControlTitlesArray = ["По дням недели", "Выбрать числа"]
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
    private lazy var daysSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segmentedControlTitlesArray)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(didChangeControlValue), for: .valueChanged)
        return control
    }()
    private lazy var daysTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.viewBackground
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var calendarView: UICalendarView = {
        let calendar = UICalendarView()
        calendar.tintColor = Colors.mainForeground
        calendar.isHidden = true
        calendar.selectionBehavior = UICalendarSelectionMultiDate(delegate: self)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        return calendar
    }()
    private let viewModel: CreateScheduleViewModelProtocol
    private var bag = DisposeBag()
    
    init(viewModel: CreateScheduleViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysTableView.dataSource = self
        daysTableView.delegate = self
        daysTableView.register(DayOfWeekTableViewCell.self, forCellReuseIdentifier: reuseId)
        setupUI()
    }
    
    // MARK: - private func
    private func setupUI() {
        view.backgroundColor = Colors.viewBackground
        addSubviews()
        applyConstraints()
        navigationItem.title = "Select days to repeat"
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func addSubviews() {
        view.addSubview(daysSegmentedControl)
        view.addSubview(daysTableView)
        view.addSubview(calendarView)
    }
    
    private func applyConstraints() {
        // dateSementedControl constraints
        daysSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.height.equalTo(30)
        }
        
        // daysTableView constraints
        daysTableView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.top.equalTo(daysSegmentedControl.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // calendarView constraints
        calendarView.snp.makeConstraints {
            $0.top.equalTo(daysSegmentedControl.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
        }
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func saveButtonTapped() {
        viewModel.saveDateRange()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didChangeControlValue(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            daysTableView.isHidden = false
            calendarView.isHidden = true
        case 1:
            daysTableView.isHidden = true
            calendarView.isHidden = false
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension SelectRepeatedDaysViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DaysOfWeekEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = daysTableView.dequeueReusableCell(
            withIdentifier: reuseId,
            for: indexPath) as? DayOfWeekTableViewCell else {
            fatalError("Error when instanciating DayOfWeekCell")
        }
        let title = DaysOfWeekEnum.allCases[indexPath.row].rawValue
        cell.configureCell(with: title)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectRepeatedDaysViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

// MARK: - UICalendarSelectionMultiDateDelegate
extension SelectRepeatedDaysViewController: UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        
    }
}
