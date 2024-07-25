//
//  CreateScheduleViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.06.2024.
//

import UIKit
import SnapKit

final class CreateScheduleViewController: UIViewController {
    // MARK: - public properties
    weak var delegate: CreateScheduleDelegate?
    
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
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
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
    
    // TODO: - Create init for delegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(createDescriptionTextViewDidEndEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func createPlaceholder() {
        createScheduleDescriptionTextField.text = "Enter some text..."
        createScheduleDescriptionTextField.textColor = .lightGray
    }
    
    @objc private func didTapSaveButton() {
        let description = createScheduleDescriptionTextField.text ?? ""
        let task = ScheduleTask(id: UUID(), date: Date(), description: description)
        createPlaceholder()
        
        delegate?.didAddTask(task, mode: .task)
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
        return cell
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
