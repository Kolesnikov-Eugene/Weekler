//
//  ScheduleTableViewCell.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 09.05.2024.
//

import UIKit
import SnapKit

final class ScheduleTableViewCell: UITableViewCell {
    
    private lazy var mainView: UIView = {
        let view = UIView()
        
        view.backgroundColor = Colors.background
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = CGSize.zero
    }
    
    func configureCell() {
        
    }

    private func setupUI() {
        contentView.backgroundColor = Colors.background
        
        addSubviews()
        applyConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(mainView)
    }
    
    private func applyConstraints() {
        mainView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).inset(10)
            $0.leading.equalTo(contentView.snp.leading).inset(16)
            $0.trailing.equalTo(contentView.snp.trailing).inset(16)
            $0.bottom.equalTo(contentView.snp.bottom).inset(10)
        }
    }
}
