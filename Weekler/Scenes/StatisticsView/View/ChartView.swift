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
    
    private lazy var textLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.fontSize = 30
        layer.alignmentMode = .center
//        layer.truncationMode = .middle
//        layer.isWrapped = true
        layer.string = "75%"
//        layer.truncationMode = .end
        layer.foregroundColor = UIColor.black.cgColor
        return layer
    }()
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
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.textColorMain
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.text = "0%"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layoutSublayers() {
        super.layoutSublayers(of: self.layer)
//        gradientLayer.frame = layer.bounds
//        textLayer.frame = CGRect(x: Int(bounds.width / 2.0), y: Int(bounds.height/2.0), width: 40, height: 40)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Chart.radius = bounds.height / 2.0 - Chart.margin
        configure(baseLayer, for: Chart.fullCirclePercent, and: Chart.baseStrokeColor)
        configure(progressLayer, for: Chart.progressBasePercent, and: Chart.progressStrokeColor)
        configureGradientLayer()
        textLayer.frame = CGRect(
            x: Int(bounds.width / 2.0 - Chart.margin),
            y: Int(bounds.height / 2.0 - Chart.margin),
            width: 60,
            height: 60
        )
//        textLayer.frame = CGRect(x: Int(layer.frame.midX), y: Int(layer.frame.midY), width: 40, height: 40)
        layer.insertSublayer(textLayer, at: 0)
//        layer.addSublayer(textLayer)
    }
    
    private func setupUI() {
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
        //TODO: two animations inside UIView.animate
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        let animText = CABasicAnimation(keyPath: "transform")
//        animText.beginTime = CACurrentMediaTime() + duration
        animation.duration = duration
        
        let angle = calculateAngleFromPercantage(percent)
        let path = drawCGPath(at: angle)
        progressLayer.path = path
        
        animation.fromValue = 0 //start animation at point 0
        animation.toValue = value //end animation at point specified
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateCircle")
        
//        textLayer.string = "\(Int(percent * 100))%"
        
//        textLayer.add(animText, forKey: "animateText")
    }
    
    private func calculateAngleFromPercantage(_ percentage: CGFloat) -> CGFloat {
        let angle = Chart.startPointMultiplier + (percentage * Chart.endFullCircleMultiplier)
        return angle * .pi
    }
}

// chatgpt ver
class DonutProgressView: UIView {
    
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let percentageLabel = UILabel()
    
    var progress: CGFloat = 0.0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Add track layer
        trackLayer.path = createCircularPath().cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        // Add progress layer
        progressLayer.path = createCircularPath().cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.lineWidth = 10
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        // Add percentage label
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        percentageLabel.textColor = .black
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentageLabel)
        
        // Center the label
        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        updateProgress()
    }
    
    private func createCircularPath() -> UIBezierPath {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = min(bounds.width, bounds.height) / 2 - 10
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
    }
    
    private func updateProgress() {
        progressLayer.strokeEnd = progress
        percentageLabel.text = "\(Int(progress * 100))%"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update path if the view's bounds change
        trackLayer.path = createCircularPath().cgPath
        progressLayer.path = createCircularPath().cgPath
    }
}

//class ViewController: UIViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let donutProgressView = DonutProgressView(frame: CGRect(x: 100, y: 200, width: 200, height: 200))
//        view.addSubview(donutProgressView)
//        
//        // Animate progress
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            UIView.animate(withDuration: 2.0) {
//                donutProgressView.progress = 0.75 // 75%
//            }
//        }
//    }
//}
