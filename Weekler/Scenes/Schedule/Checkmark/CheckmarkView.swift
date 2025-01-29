//
//  CheckmarkView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 22.01.2025.
//

import UIKit

final class CheckmarkView: UIView {
    
    private var checkmarkLayer: CAShapeLayer!
    private var circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    private func setupLayers() {
        // Circle Layer
        circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        circleLayer.strokeColor = UIColor.systemBlue.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 3
        layer.addSublayer(circleLayer)
        
        // Checkmark Layer
        checkmarkLayer = CAShapeLayer()
        checkmarkLayer.strokeColor = UIColor.orange.cgColor
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        checkmarkLayer.lineWidth = 3
        checkmarkLayer.lineCap = .round
        checkmarkLayer.lineJoin = .round
        layer.addSublayer(checkmarkLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update circle path if bounds change (e.g., rotation)
        circleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        updateCheckmarkPath()
    }
    
    private func updateCheckmarkPath() {
        let width = bounds.width
        let height = bounds.height
        
        // Adjust these values to fine-tune checkmark appearance
        let startPoint = CGPoint(x: width * 0.25, y: height * 0.5)
        let midPoint = CGPoint(x: width * 0.45, y: height * 0.7)
        let endPoint = CGPoint(x: width * 0.75, y: height * 0.3)
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: midPoint)
        path.addLine(to: endPoint)
        
        checkmarkLayer.path = path.cgPath
    }
    
    func animateCheckmark(duration: TimeInterval = 0.5) {
        checkmarkLayer.strokeEnd = 0 // Initially hide the checkmark
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        checkmarkLayer.add(animation, forKey: "checkmarkAnimation")
        
        checkmarkLayer.strokeEnd = 1 // Set strokeEnd to 1 to complete the drawing
    }
    
    func animateCheckmarkAndCircle(duration: TimeInterval = 0.5) {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        // Circle Stroke Animation
        let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circleAnimation.fromValue = 0
        circleAnimation.toValue = 1
        circleLayer.strokeEnd = 1
        
        // Checkmark Stroke Animation
        let checkmarkAnimation = CABasicAnimation(keyPath: "strokeEnd")
        checkmarkAnimation.fromValue = 0
        checkmarkAnimation.toValue = 1
        checkmarkLayer.strokeEnd = 1
        
        animationGroup.animations = [circleAnimation, checkmarkAnimation]
        layer.add(animationGroup, forKey: "groupAnimation")
    }
    
    func reset() {
        checkmarkLayer.strokeEnd = 0
        circleLayer.strokeEnd = 0
    }
}
