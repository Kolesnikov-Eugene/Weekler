//
//  GradientTextLabel.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 24.11.2024.
//

import UIKit
import QuartzCore

class GradientTextLabel: UILabel {

    var gradientColors: [UIColor] = [.red, .orange, .yellow] {
        didSet {
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }
        guard let text = text else { return }
        currentContext?.translateBy(x: 0, y: bounds.height)
        currentContext?.scaleBy(x: 1, y: -1)
        
        // Create gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = rect
        
        // Render gradient to an image
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Clip gradient to text
        currentContext?.clip(to: rect, mask: createTextMask(rect: rect))
        gradientImage?.draw(in: rect)
    }
    
    private func createTextMask(rect: CGRect) -> CGImage {
        let size = bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let textRect = textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        (text! as NSString).draw(in: textRect, withAttributes: [
            .font: font as Any
        ])
        let maskImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return maskImage!.cgImage!
    }
}

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let gradientLabel = GradientLabel(frame: CGRect(x: 50, y: 200, width: 300, height: 100))
//        gradientLabel.text = "Gradient Text"
//        gradientLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
//        gradientLabel.textAlignment = .center
////        gradientLabel.gradientColors = [.blue, .purple, .cyan]
//        
//        view.addSubview(gradientLabel)
//    }
//}
