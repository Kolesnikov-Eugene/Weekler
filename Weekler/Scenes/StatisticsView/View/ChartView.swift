//
//  ChartView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.11.2024.
//


import UIKit
import QuartzCore

final class ChartView: UIView {
    
    private var baseLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        let startColor = UIColor.systemCyan.cgColor
        let endColor = UIColor.systemTeal.cgColor
        gradientLayer.colors = [startColor, endColor]
        gradientLayer.locations = [0.7, 0.9]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.type = .radial
        return gradientLayer
    }()
    
    private struct Chart {
        static let margin: CGFloat = 20.0
        static var radius: CGFloat = 0.0                       // update in layout subviews
        static var strokeWidth: CGFloat = 35.0                 // width of donut chart border
        static let startPointMultiplier: CGFloat = -0.5        // start multiplier to draw circle (north point)
        static let fullCirclePercent: CGFloat = 1.0            // percent of drawing (0.0 - zero point, 1.0 - full circle)
        static let progressBasePercent: CGFloat = 0.0          // init progress layer, but do not draw it
        static let endFullCircleMultiplier: CGFloat = 2.0      // multiplier by .pi to draw full circle (from -0.5 to 1.5)
        static let baseStrokeColor: UIColor = .systemGray
        static let progressStrokeColor: UIColor = .systemBlue
        static var fillColor: UIColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutSublayers() {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = layer.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Chart.radius = bounds.height / 2.0 - Chart.margin
        configure(baseLayer, for: Chart.fullCirclePercent, and: Chart.baseStrokeColor)
        configure(progressLayer, for: Chart.progressBasePercent, and: Chart.progressStrokeColor)
        configureGradientLayer()
    }
    
    
    private func configure(
        _ sublayer: CAShapeLayer,
        for percentage: CGFloat,
        and strokeColor: UIColor
    ) {
        let angle = calculateAngleFromPercantage(percentage)
        let path = drawCGPath(at: angle)
        sublayer.path = path
        sublayer.fillColor = Chart.fillColor.cgColor
        sublayer.strokeColor = strokeColor.cgColor
        sublayer.lineWidth = Chart.strokeWidth
        sublayer.lineCap = .round
        
        layer.addSublayer(sublayer)
    }
    
    
    private func drawCGPath(at angle: CGFloat) -> CGPath {
        UIBezierPath(
            arcCenter: CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0),
            radius: Chart.radius,
            startAngle: Chart.startPointMultiplier * .pi,
            endAngle: angle,
            clockwise: true
        ).cgPath
    }
    
    private func configureGradientLayer() {
        gradientLayer.frame = layer.bounds
        gradientLayer.mask = progressLayer
        layer.addSublayer(gradientLayer)
    }
    
    func setProgressWithAnimation(
        duration: TimeInterval,
        value: Float,
        for percent: CGFloat
    ) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        
        let angle = calculateAngleFromPercantage(percent)
        let path = drawCGPath(at: angle)
        progressLayer.path = path
        
        animation.fromValue = 0 //start animation at point 0
        animation.toValue = value //end animation at point specified
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateCircle")
    }
    
    private func calculateAngleFromPercantage(_ percentage: CGFloat) -> CGFloat {
        let angle = Chart.startPointMultiplier + (percentage * Chart.endFullCircleMultiplier)
        return angle * .pi
    }
}
