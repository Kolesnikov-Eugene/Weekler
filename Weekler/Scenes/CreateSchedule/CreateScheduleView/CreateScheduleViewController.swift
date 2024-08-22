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

final class CreateScheduleViewController: UIViewController {
    
    //MARK: - private properties
    private let scheduleItemTableViewReuseId = "ScheduleItem"
    private lazy var createScheduleDescriptionTextField: UITextView = {
        let textField = UITextView()
        
        textField.backgroundColor = Colors.background
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.text = "Enter your task..."
        textField.textColor = .lightGray
        textField.tintColor = .black
        textField.sizeToFit()
        textField.isScrollEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    private lazy var saveTaskButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.isEnabled = true
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.contentHorizontalAlignment = .trailing
//        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private lazy var scheduleItemsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.allowsSelection = true
        tableView.backgroundColor = Colors.background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    private var viewModel: CreateScheduleViewModelProtocol
    private var bag = DisposeBag()
    
    // TODO: - Create init for delegate?
    init(viewModel: CreateScheduleViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetAllFieldsToDefault()
    }
    
    //MARK: - private methods
    private func setupUI() {
        view.backgroundColor = Colors.background
        
        createScheduleDescriptionTextField.delegate = self
        
        scheduleItemsTableView.dataSource = self
        scheduleItemsTableView.delegate = self
        scheduleItemsTableView.register(ScheduleItemsTableViewCell.self, forCellReuseIdentifier: scheduleItemTableViewReuseId)
        
        addSubviews()
        applyConstraints()
        configureTapGesture()
    }
    
    private func addSubviews() {
        view.addSubview(createScheduleDescriptionTextField)
        view.addSubview(saveTaskButton)
        view.addSubview(scheduleItemsTableView)
    }
    
    private func applyConstraints() {
        //saveButton constraints
        saveTaskButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }
        
        //createScheduleDescriptionTextField constraints
        createScheduleDescriptionTextField.snp.makeConstraints {
            $0.top.equalTo(saveTaskButton.snp.bottom).offset(5)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.trailing.equalTo(saveTaskButton.snp.trailing)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        //scheduleItemsTableView constraints
        scheduleItemsTableView.snp.makeConstraints {
            $0.top.equalTo(createScheduleDescriptionTextField.snp.bottom).offset(10)
            $0.leading.equalTo(createScheduleDescriptionTextField.snp.leading)
            $0.trailing.equalTo(createScheduleDescriptionTextField.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bind() {
        createScheduleDescriptionTextField.rx
            .text
            .orEmpty
            .asObservable()
            .subscribe(onNext: { text in
                self.viewModel.taskDescription = text
            })
            .disposed(by: bag)
        
        saveTaskButton.rx
            .tap
            .subscribe(onNext: {
                self.didTapSaveButton()
            })
            .disposed(by: bag)
        
        viewModel.textFieldValue
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text != "" {
                    self.createScheduleDescriptionTextField.text = text
                    self.createScheduleDescriptionTextField.textColor = .black
                }
            })
            .disposed(by: bag)
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(createDescriptionTextViewDidEndEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func createPlaceholder() {
        createScheduleDescriptionTextField.text = "Enter your task..."
        createScheduleDescriptionTextField.textColor = .lightGray
    }
    
    private func resetAllFieldsToDefault() {
        createPlaceholder()
        for index in 0..<ScheduleItems.allCases.count {
            let indePath = IndexPath(row: index, section: 0)
            guard let cell = scheduleItemsTableView
                .cellForRow(at: indePath) as? ScheduleItemsTableViewCell else {
                return assertionFailure("Error instantiating ScheduleItem cell on reset")
            }
            cell.resetAllFieldsForCell(at: index)
        }
    }
    
    private func didTapSaveButton() {
        viewModel.createTask()
        createPlaceholder()
        dismiss(animated: true)
    }
    
    @objc private func createDescriptionTextViewDidEndEditing() {
        view.endEditing(true)
    }
}

//MARK: - UITableView data source
extension CreateScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ScheduleItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = scheduleItemsTableView.dequeueReusableCell(
            withIdentifier: scheduleItemTableViewReuseId,
            for: indexPath) as? ScheduleItemsTableViewCell else {
            fatalError("Error while instanciating ScheduleItemsTableViewCell")
        }
        cell.configureCell(index: indexPath.row)
        cell.onDatePickerChangedValue = { date in
            self.viewModel.set(date)
        }
        cell.onSwitchChangedValue = { notification in
            self.viewModel.set(notification)
        }
        bindViewModelEditState(to: cell)
        return cell
    }
    
    private func bindViewModelEditState(to cell: ScheduleItemsTableViewCell) {
        viewModel.datePickerValue
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { date in
                cell.set(date)
            })
            .disposed(by: bag)
        
        viewModel.notificationSwitchValue
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { notification in
                cell.set(notification)
            })
            .disposed(by: bag)
    }
}

//MARK: - UITableView delegate
extension CreateScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = scheduleItemsTableView.cellForRow(at: indexPath) as? ScheduleItemsTableViewCell,
              cell.cellType == .isRepeated else { return }
        let vc = SelectRepeatedDaysViewController()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension CreateScheduleViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if createScheduleDescriptionTextField.textColor == .lightGray {
            createScheduleDescriptionTextField.text = nil
            createScheduleDescriptionTextField.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if createScheduleDescriptionTextField.text.isEmpty {
            createPlaceholder()
        }
    }
}
