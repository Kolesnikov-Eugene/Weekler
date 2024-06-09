//
//  CreateScheduleViewController.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 01.06.2024.
//

import UIKit
import SnapKit

final class CreateScheduleViewController: UIViewController {
    
    //MARK: - private properties
    private let scheduleItemTableViewReuseId = "ScheduleItem"
    private lazy var createScheduleDescriptionTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Введите Вашу задачу"
        textField.backgroundColor = Colors.background
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
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
//    private lazy var saveTaskButton: UIButton = {
//        let button = UIButton()
//        
//        button.setTitle("Save", for: .normal)
//        button.isEnabled = false
//        button.backgroundColor = .lightGray
//        button.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        return button
//    }()
//    private lazy var calendarImageView: UIImageView = {
//        let view = UIImageView()
//        
//        view.image = UIImage(systemName: "calendar.circle")?.withRenderingMode(.alwaysTemplate)
//        view.tintColor = .lightGray
//        view.translatesAutoresizingMaskIntoConstraints = false
//        
//        return view
//    }()
//    private lazy var taskDatePicker: UIDatePicker = {
//        let picker = UIDatePicker()
//        
//        picker.datePickerMode = .dateAndTime
//        picker.preferredDatePickerStyle = .compact
//        picker.locale = .current
//        picker.contentMode = .center
//        picker.contentVerticalAlignment = .center
//        picker.contentHorizontalAlignment = .center
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        
//        return picker
//    }()
    private lazy var scheduleItemsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = Colors.background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - private methods
    private func setupUI() {
        view.backgroundColor = Colors.background
        
        scheduleItemsTableView.dataSource = self
        scheduleItemsTableView.delegate = self
        scheduleItemsTableView.register(ScheduleItemsTableViewCell.self, forCellReuseIdentifier: scheduleItemTableViewReuseId)
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(createScheduleDescriptionTextField)
//        view.addSubview(calendarImageView)
//        view.addSubview(taskDatePicker)
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
            $0.height.equalTo(50)
        }
        
        //scheduleItemsTableView constraints
        scheduleItemsTableView.snp.makeConstraints {
            $0.top.equalTo(createScheduleDescriptionTextField.snp.bottom).offset(10)
            $0.leading.equalTo(createScheduleDescriptionTextField.snp.leading)
            $0.trailing.equalTo(createScheduleDescriptionTextField.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        //calendarImageView constraints
//        calendarImageView.snp.makeConstraints {
//            $0.leading.equalTo(createScheduleDescriptionTextField.snp.leading)
//            $0.top.equalTo(createScheduleDescriptionTextField.snp.bottom).offset(15)
//            $0.height.equalTo(30)
//            $0.width.equalTo(30)
//        }
        
        //taskDatePicker constraints
//        taskDatePicker.snp.makeConstraints {
//            $0.leading.equalTo(createScheduleDescriptionTextField.snp.leading).inset(-10)
//            $0.top.equalTo(createScheduleDescriptionTextField.snp.bottom).offset(10)
//            $0.height.equalTo(30)
//            $0.width.equalTo(200)
//        }
    }
    
    @objc private func didTapSaveButton() {
        print("SAVE")
    }
}

//MARK: - UITableView data source
extension CreateScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
}
