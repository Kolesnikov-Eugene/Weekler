//
//  ConfirmButton.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 10.01.2025.
//

import UIKit

final class ConfirmButton: UIButton {
    
    private let text: String
    private let titleColor: UIColor

    init(
        text: String,
        titleColor: UIColor,
        type: UIButton.ButtonType = .custom,
        frame: CGRect
    ) {
        self.text = text
        self.titleColor = titleColor
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = Colors.mainForeground.withAlphaComponent(0.8)
            } else {
                backgroundColor = Colors.mainForeground
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
    
    private func setupView() {
        backgroundColor = Colors.mainForeground
        setTitle(text, for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
}
