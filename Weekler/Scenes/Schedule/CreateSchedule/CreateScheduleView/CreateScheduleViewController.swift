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
    
    //MARK: - private properties
    private let scheduleItemTableViewReuseId = "ScheduleItem"
    private let placeholder = L10n.Localizable.CreateSchedule.placeholder
    private lazy var createScheduleDescriptionTextField: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = Colors.viewBackground
        textView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textView.text = placeholder
        textView.textColor = .lightGray
        textView.tintColor = Colors.textColorMain
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.selectedRange = NSRange(location: 0, length: 0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private lazy var saveTaskButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isEnabled = true
        button.setTitle(L10n.Localizable.CreateSchedule.doneButtonText, for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.contentHorizontalAlignment = .trailing
//        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var scheduleItemsTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.backgroundColor = Colors.viewBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var mode: CreateMode
    private var viewModel: CreateScheduleViewModelProtocol
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindToViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resetAllFieldsToDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createScheduleDescriptionTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createScheduleDescriptionTextField.layer.borderWidth = 1
        createScheduleDescriptionTextField.layer.cornerRadius = 10
        createScheduleDescriptionTextField.layer.borderColor = Colors.createViewTextFieldBorder.cgColor
    }
    
    //MARK: - private methods
    private func setupUI() {
        view.backgroundColor = Colors.viewBackground
        
        createScheduleDescriptionTextField.delegate = self
        
        scheduleItemsTableView.dataSource = self
        scheduleItemsTableView.delegate = self
        scheduleItemsTableView.register(ScheduleItemsTableViewCell.self, forCellReuseIdentifier: scheduleItemTableViewReuseId)
        
        addSubviews()
        applyConstraints()
        configureTapGesture()
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
    
    private func bindToViewModel() {
        createScheduleDescriptionTextField.rx
            .text
            .orEmpty
            .asObservable()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
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
                    self.createScheduleDescriptionTextField.textColor = Colors.textColorMain
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
        createScheduleDescriptionTextField.text = placeholder
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
        switch mode {
        case .create:
            self.viewModel.createTask()
        case .edit:
            self.viewModel.editTask()
        }
        createPlaceholder()
        dismiss(animated: true)
    }
    
    @objc
    private func createDescriptionTextViewDidEndEditing() {
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
        cell.onDatePickerChangedValue = { [weak self] date in
            guard let self = self else { return }
            self.viewModel.set(date)
        }
        cell.onSwitchChangedValue = { [weak self] notification in
            guard let self = self else { return }
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
    func textViewDidChangeSelection(_ textView: UITextView) {
        if createScheduleDescriptionTextField.text == placeholder {
            createScheduleDescriptionTextField.selectedRange = NSRange(location: 0, length: 0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if createScheduleDescriptionTextField.text == placeholder && !text.isEmpty {
            createScheduleDescriptionTextField.text = nil
            createScheduleDescriptionTextField.textColor = Colors.textColorMain
            createScheduleDescriptionTextField.selectedRange = NSRange(location: 0, length: 0)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if createScheduleDescriptionTextField.text.isEmpty {
            createPlaceholder()
        }
    }
}
