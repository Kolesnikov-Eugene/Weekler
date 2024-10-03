//
//  ScheduleItemsTableViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 07.06.2024.
//

import UIKit
import SnapKit

final class ScheduleItemsTableViewCell: UITableViewCell {
    
    // MARK: - Public properties
    var cellType: ScheduleItems?
    var onSwitchChangedValue: ((Bool) -> (Void))?
    var onDatePickerChangedValue: ((Date) -> (Void))?
    
    // Private properties
    private lazy var cellTypeImageView: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private lazy var notificationSwitch: UISwitch = {
        let view = UISwitch()
        
        view.tintColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(notificationSwitchDidChangeValue), for: .valueChanged)
        
        return view
    }()
    private lazy var separatorString: UIView = {
        let view = UIView()
        
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        
        picker.minuteInterval = 5
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(datePickerDidChangeValue), for: .valueChanged)
        
        return picker
    }()
    private lazy var timePicker: TimePicker = {
        let picker = TimePicker()
        
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .compact
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(timePickerDidChangeValue), for: .valueChanged)
        return picker
    }()
    private lazy var selectedDaysLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Выкл."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    private var myDate: MyDate?
    private var myTime: MyTime?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    func set(_ date: Date) {
        datePicker.date = date
    }
    
    func set(_ notification: Bool) {
        notificationSwitch.isOn = notification
    }
    
    func resetAllFieldsForCell(at index: Int) {
        switch index {
        case 0:
            datePicker.date = Date()
        case 2:
            notificationSwitch.isOn = false
        default:
            break // TODO: implement rest cases when other modes enabled
        }
    }
    
    func configureCell(index: Int) {
        switch index {
        case 0:
            configureDatePicker()
            
            cellTypeImageView.image = UIImage(systemName: "calendar")
            cellTypeImageView.tintColor = .orange
            descriptionLabel.text = ScheduleItems.allCases[0].rawValue
        case 1:
//            break
            configureTimePicker()
            
            cellTypeImageView.image = UIImage(systemName: "clock")
            cellTypeImageView.tintColor = .orange
            descriptionLabel.text = ScheduleItems.allCases[1].rawValue
        case 2:
            configureNotificationSwitch()
            
            cellTypeImageView.image = UIImage(systemName: "bell")
            cellTypeImageView.tintColor = .orange
            descriptionLabel.text = ScheduleItems.allCases[2].rawValue
        case 3:
            configureSelectedDaysLabel()
            
            cellTypeImageView.image = UIImage(systemName: "repeat")
            cellTypeImageView.tintColor = .orange
            descriptionLabel.text = ScheduleItems.allCases[3].rawValue
            cellType = ScheduleItems.isRepeated
        default:
            break
        }
    }
    
    // MARK: - private methods
    private func setupUI() {
        contentView.backgroundColor = Colors.background
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(cellTypeImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(separatorString)
    }
    
    private func applyConstraints() {
        //cellTypeImageView constraints
        cellTypeImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.safeAreaLayoutGuide.snp.leading)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
        }
        
        //descriptionLabel constraints
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(cellTypeImageView.snp.trailing).offset(10)
            $0.centerY.equalTo(cellTypeImageView.snp.centerY)
            $0.height.equalTo(30)
        }
        
        //separatorString constraints
        separatorString.snp.makeConstraints {
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(descriptionLabel.snp.leading)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(0.5)
        }
    }
    
    private func configureDatePicker() {
        contentView.addSubview(datePicker)
        
        // datePicker constraints
        datePicker.snp.makeConstraints {
            $0.centerY.equalTo(descriptionLabel.snp.centerY)
            $0.trailing.equalTo(separatorString.snp.trailing)
        }
    }
    
    private func configureTimePicker() {
        contentView.addSubview(timePicker)
        
        timePicker.snp.makeConstraints {
            $0.centerY.equalTo(descriptionLabel.snp.centerY)
            $0.trailing.equalTo(separatorString.snp.trailing)
        }
    }
    
    private func configureNotificationSwitch() {
        contentView.addSubview(notificationSwitch)
        //forwardArrow constraints
        notificationSwitch.snp.makeConstraints {
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).inset(2)
            $0.centerY.equalTo(descriptionLabel.snp.centerY)
        }
    }
    
    private func configureSelectedDaysLabel() {
        contentView.addSubview(selectedDaysLabel)
        
        // selectedDaysLabel constraints
        selectedDaysLabel.snp.makeConstraints {
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing)
            $0.centerY.equalTo(descriptionLabel.snp.centerY)
            $0.leading.lessThanOrEqualTo(descriptionLabel.snp.trailing).offset(20)
        }
    }
    
    @objc private func datePickerDidChangeValue(_ sender: UIDatePicker) {
        let day = Calendar.current.component(.day, from: sender.date)
        let d = MyDate(day: day)
        myDate = DeepCopier.Copy(of: d)
        myDate?.day = 6
        print(myDate?.day)
        print(myTime?.hour)
        print(myTime?.time)
//        print("date \(pickedDate)")
//        print("time \(pickedTime)")
//        let pickedDateAndTime = calculateDate()
//        onDatePickerChangedValue?(pickedDateAndTime)
    }
    
    @objc private func notificationSwitchDidChangeValue(_ sender: UISwitch) {
        onSwitchChangedValue?(sender.isOn)
    }
    
    @objc private func timePickerDidChangeValue(_ sender: UIDatePicker) {
        let hour = Calendar.current.component(.hour, from: sender.date)
        let minute = Calendar.current.component(.minute, from: sender.date)
        let d = MyTime(hour: hour, time: minute)
        myTime = DeepCopier.Copy(of: d)
        myTime?.hour = 15
        myTime?.time = 10
        print(myDate?.day)
        print(myTime?.hour)
        print(myTime?.time)
//        print("date \(cloneDate?.date)")
//        print("time \(pickedTime.time)")
        let pickedDateAndTime = calculateDate()
        onDatePickerChangedValue?(pickedDateAndTime)
    }
    
    private func calculateDate() -> Date {
        guard let date = myDate,
              let time = myTime else { return Date() }
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = calendar.component(.year, from: Date())
        components.month = calendar.component(.month, from: Date())
        components.day = date.day
        components.hour = time.hour
        components.minute = time.time
        guard let date = calendar.date(from: components) else { return Date() }
        print(date)
        return date
    }
}

struct MyDate: Codable {
    var day: Int
    
    init(day: Int) {
        self.day = day
    }
}

struct MyTime: Codable {
    var hour: Int
    var time: Int
    
    init(hour: Int, time: Int) {
        self.hour = hour
        self.time = time
    }
}

class DeepCopier {
    //Used to expose generic
    static func Copy<T:Codable>(of object:T) -> T? {
       do {
           let json = try JSONEncoder().encode(object)
           return try JSONDecoder().decode(T.self, from: json)
       }
       catch let error {
           print(error)
           return nil
       }
    }
}

class Node {
    var value: Int
    var next: Node?
    
    init(value: Int, next: Node? = nil) {
        self.value = value
        self.next = next
    }
    
    func deepCopy() -> Node {
        let copiedNode = Node(value: self.value)
        if let nextNode = self.next {
            copiedNode.next = nextNode.deepCopy()
        }
        return copiedNode
    }
}
