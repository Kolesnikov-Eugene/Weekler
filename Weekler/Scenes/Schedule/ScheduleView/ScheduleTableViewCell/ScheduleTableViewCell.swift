//
//  ScheduleTableViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.05.2024.
//

import UIKit
import SnapKit

final class ScheduleTableViewCell: UITableViewCell {
    
    // MARK: - public properties
    var onTaskCompleted: (() -> ())?
    
    // MARK: - private properties
    private lazy var completeTaskButton: UIButton = {
        let button = UIButton(configuration: uncompletedTaskButtonConfiguration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCheckmarkButton), for: .touchUpInside)
        return button
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = Colors.textColorMain
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var scheduleDescriptionlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = Colors.textColorMain
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        return formatter
    }()
    private var uncompletedTaskButtonConfiguration: UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "circle")?.withRenderingMode(.alwaysTemplate)
        configuration.baseForegroundColor = .orange
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
        return configuration
    }
    private var completedTaskButtonConfguration: UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "checkmark.circle")
        configuration.baseForegroundColor = .orange.withAlphaComponent(0.3)
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16)
        return configuration
    }
    private var mainMode: ScheduleMode = .task
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearAllFields()
        completeTaskButton.configuration = uncompletedTaskButtonConfiguration
    }
    
    // MARK: - public methods
    func configureCell(with model: ScheduleTask) {
        let time = dateFormatter.string(from: model.date)
        timeLabel.text = time
        scheduleDescriptionlabel.text = model.description
        mainMode = .task
    }
    
    func configureCell(text: String) {
        scheduleDescriptionlabel.text = text
    }
    
    func configureCompletedTaskCell(with completedTask: ScheduleTask) {
        let time = dateFormatter.string(from: completedTask.date)
        timeLabel.text = time
        scheduleDescriptionlabel.text = completedTask.description
        
        timeLabel.textColor = .lightGray
        scheduleDescriptionlabel.textColor = .lightGray
        completeTaskButton.configuration = completedTaskButtonConfguration
        mainMode = .completedTask
    }
    
    // MARK: - private methods
    private func setupUI() {
        contentView.backgroundColor = Colors.viewBackground
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(completeTaskButton)
        contentView.addSubview(timeLabel)
        contentView.addSubview(scheduleDescriptionlabel)
        contentView.addSubview(separatorView)
    }
    
    private func applyConstraints() {
        //checkmarkButton
        completeTaskButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(separatorView.snp.leading)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        //timeLabel constraints
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(separatorView.snp.leading)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(40)
        }
        
        //schedule description constraints
        scheduleDescriptionlabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.trailing).offset(16)
            $0.top.equalTo(contentView.snp.top)
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.trailing.equalTo(contentView.snp.trailing)
        }
        
        //separatorView constraints
        separatorView.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.leading.equalTo(contentView.snp.leading).inset(40)
            $0.height.equalTo(0.5)
        }
    }
    
    private func clearAllFields() {
        timeLabel.text = ""
        scheduleDescriptionlabel.text = ""
    }
    
    private func configureAnimationTransition() {
        switch mainMode {
        case .task:
            self.completeTaskButton.configuration = self.completedTaskButtonConfguration
            self.scheduleDescriptionlabel.textColor = .lightGray
            self.timeLabel.textColor = .lightGray
        case .completedTask:
            self.completeTaskButton.configuration = self.uncompletedTaskButtonConfiguration
            self.scheduleDescriptionlabel.textColor = Colors.textColorMain
            self.timeLabel.textColor = Colors.textColorMain
        }
    }
    
    @objc private func didTapCheckmarkButton() {
        UIView.animate(
            withDuration: 0.3) { [weak self] in
                guard let self = self else { return }
                self.configureAnimationTransition()
            } completion: { [weak self] _ in
                self?.onTaskCompleted?()
            }
    }
}
