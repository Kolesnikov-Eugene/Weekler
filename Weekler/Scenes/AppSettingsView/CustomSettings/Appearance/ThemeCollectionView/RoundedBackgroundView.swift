//
//  RoundedBackgroundView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 18.12.2024.
//

import UIKit

final class RoundedBackgroundView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
