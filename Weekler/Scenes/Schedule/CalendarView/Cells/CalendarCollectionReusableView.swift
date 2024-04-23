//
//  CalendarCollectionReusableView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 22.04.2024.
//

import UIKit
import JTAppleCalendar
import SnapKit

class CalendarCollectionReusableView: JTAppleCollectionReusableView {
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(dayLabel)
        
//        dayLabel.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.bottom.equalToSuperview()
//            $0.leading.equalToSuperview()
//            $0.trailing.equalToSuperview()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(with text: String) {
        dayLabel.text = text
    }
}
