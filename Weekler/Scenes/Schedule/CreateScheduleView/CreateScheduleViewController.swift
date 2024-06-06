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
    private lazy var createScheduleDescriptionTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Введите Вашу задачу"
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    private lazy var saveTaskButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Save", for: .normal)
        button.isEnabled = false
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    private lazy var calendarImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(systemName: "calendar.circle")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var taskDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = .current
        picker.contentMode = .center
        picker.contentVerticalAlignment = .center
        picker.contentHorizontalAlignment = .center
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - private methods
    private func setupUI() {
        view.backgroundColor = Colors.background
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(createScheduleDescriptionTextField)
        view.addSubview(calendarImageView)
        view.addSubview(taskDatePicker)
        view.addSubview(saveTaskButton)
    }
    
    private func applyConstraints() {
        //createScheduleDescriptionTextField constraints
        createScheduleDescriptionTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(16)
            $0.height.equalTo(50)
        }
        
        //calendarImageView constraints
        calendarImageView.snp.makeConstraints {
            $0.leading.equalTo(createScheduleDescriptionTextField.snp.leading)
            $0.top.equalTo(createScheduleDescriptionTextField.snp.bottom).offset(15)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
        
        //taskDatePicker constraints
        taskDatePicker.snp.makeConstraints {
            $0.leading.equalTo(calendarImageView.snp.trailing).offset(10)
            $0.top.equalTo(calendarImageView.snp.top)
            $0.height.equalTo(30)
            $0.width.equalTo(100)
        }
        
        //saveButton constraints
        saveTaskButton.snp.makeConstraints {
            $0.leading.equalTo(createScheduleDescriptionTextField.snp.leading)
            $0.trailing.equalTo(createScheduleDescriptionTextField.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.height.equalTo(40)
        }
    }
    
    @objc private func didTapSaveButton() {
        print("SAVE")
    }
}
