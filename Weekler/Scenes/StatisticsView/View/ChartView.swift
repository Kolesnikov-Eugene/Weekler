//
//  ChartView.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 13.11.2024.
//


import UIKit
import QuartzCore
import SnapKit

final class ChartView: UIView {
    
    // MARK: public properties
    var progress: CGFloat = 0.0 {
        didSet {
            updateProgressAnimated()
        }
    }
    
    // MARK: private properties
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
    private lazy var progressLabel: GradientLabel = {
        let label = GradientLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
//        label.gradientColors = [.blue, .purple, .cyan]  //for gradientTextLabel
        label.gradientColors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private struct Chart {
        static let margin: CGFloat = 20.0
        static var radius: CGFloat = 0.0                       // update in layout subviews
        static var strokeWidth: CGFloat = 25.0                 // width of donut chart border
        static let startPointMultiplier: CGFloat = -0.5        // start multiplier to draw circle (north point)
        static let fullCirclePercent: CGFloat = 1.0            // percent of drawing (0.0 - zero point, 1.0 - full circle)
        static let progressBasePercent: CGFloat = 0.0          // init progress layer, but do not draw it
        static let endFullCircleMultiplier: CGFloat = 2.0      // multiplier by .pi to draw full circle (from -0.5 to 1.5)
        static let baseStrokeColor: UIColor = .systemGray
        static let progressStrokeColor: UIColor = .systemBlue
        static var fillColor: UIColor = .clear
    }
    
    // MARK: - lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutSublayers() {
        super.layoutSublayers(of: self.layer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Chart.radius = bounds.height / 2.0 - Chart.margin
        configure(baseLayer, for: Chart.fullCirclePercent, and: Chart.baseStrokeColor)
        configure(progressLayer, for: Chart.fullCirclePercent, and: Chart.progressStrokeColor)
        configureGradientLayer()
    }
    
    // MARK: private methods
    private func setupUI() {
        addSubview(progressLabel)
        progressLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        progressLayer.strokeEnd = 0
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
    
    // flexible start and end for various draw
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
    
    private func updateProgressAnimated() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 2.0) {
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = 2.0
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
                self.progressLayer.strokeEnd = self.progress
                self.progressLayer.add(animation, forKey: "animateCircle")
                self.progressLabel.text = "\(Int(round(self.progress * 100)))%"
            }
        }
    }
    
    private func calculateAngleFromPercantage(_ percentage: CGFloat) -> CGFloat {
        let angle = Chart.startPointMultiplier + (percentage * Chart.endFullCircleMultiplier)
        return angle * .pi
    }
}
