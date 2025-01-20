//
//  CreateScheduleView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 20.01.2025.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CreateScheduleView: UIView {
    
    // MARK: - UI
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
    private var scheduleItemsTableViewController: CreateScheduleTableViewController
    
    // MARK: - public properties
    
    // MARK: - private properties
    private let viewModel: CreateScheduleViewModelProtocol
    private var mode: CreateMode
    private var bag = DisposeBag()
    
    // MARK: - Lifecycle
    init(
        viewModel: CreateScheduleViewModelProtocol,
        mode: CreateMode,
        frame: CGRect
    ) {
        self.viewModel = viewModel
        self.mode = mode
        scheduleItemsTableViewController = CreateScheduleTableViewController(viewModel: viewModel)
        super.init(frame: frame)
        setupUI()
        bindToViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createScheduleDescriptionTextField.layer.borderWidth = 1
        createScheduleDescriptionTextField.layer.cornerRadius = 10
        createScheduleDescriptionTextField.layer.borderColor = Colors.createViewTextFieldBorder.cgColor
    }
    
    private func setupUI() {
        backgroundColor = Colors.viewBackground
        
        createScheduleDescriptionTextField.delegate = self
        
        addSubviews()
        applyConstraints()
        configureTapGesture()
    }
    
    private func addSubviews() {
        addSubview(createScheduleDescriptionTextField)
        addSubview(saveTaskButton)
        if let tableView = scheduleItemsTableViewController.tableView {
            addSubview(tableView)
        }
    }
    
    private func applyConstraints() {
        //saveButton constraints
        saveTaskButton.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(10)
            $0.width.equalTo(100)
            $0.height.equalTo(30)
        }
        
        //createScheduleDescriptionTextField constraints
        createScheduleDescriptionTextField.snp.makeConstraints {
            $0.top.equalTo(saveTaskButton.snp.bottom).offset(5)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).inset(16)
            $0.trailing.equalTo(saveTaskButton.snp.trailing)
            $0.height.greaterThanOrEqualTo(50)
        }
        
        //scheduleItemsTableView constraints
        if let tableView = scheduleItemsTableViewController.tableView {
            tableView.snp.makeConstraints {
                $0.top.equalTo(createScheduleDescriptionTextField.snp.bottom).offset(10)
                $0.leading.equalTo(createScheduleDescriptionTextField.snp.leading)
                $0.trailing.equalTo(createScheduleDescriptionTextField.snp.trailing)
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            }
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
        
        viewModel.viewNeedsResetToDefault
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isNeeded in
                guard let self else { return }
                if isNeeded {
                    self.resetAllFieldsToDefault()
                }
            })
            .disposed(by: bag)
        
        viewModel.textFieldNeedsToBecomeFirstResponder
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isNeeded in
                if isNeeded {
                    self?.createScheduleDescriptionTextField.becomeFirstResponder()
                }
            })
            .disposed(by: bag)
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(createDescriptionTextViewDidEndEditing))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    private func createPlaceholder() {
        createScheduleDescriptionTextField.text = placeholder
        createScheduleDescriptionTextField.textColor = .lightGray
    }
    
    private func resetAllFieldsToDefault() {
        createPlaceholder()
        
        for index in 0..<ScheduleItems.allCases.count {
            let indePath = IndexPath(row: index, section: 0)
            guard let cell = scheduleItemsTableViewController.tableView
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
        viewModel.hideCreateView() // create method
//        dismiss(animated: true)
    }
    
    @objc
    private func createDescriptionTextViewDidEndEditing() {
        endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension CreateScheduleView: UITextViewDelegate {
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
