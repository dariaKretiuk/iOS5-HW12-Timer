//
//  ViewController+Extention.swift
//  iOS5-HW12-Timer
//
//  Created by Дарья Кретюк on 17.03.2022.
//

import UIKit

extension ViewController {
    
    enum DataMetric {
        static let imageButtonPlay = UIImage(systemName: "play")
        static let imageButtonPause = UIImage(systemName: "pause")
        static let durationMinutesWork = 2
        static let durationMinutesRelax = 1
        static let durationSeconds = 5
        static let divideSymbol = ":"
    }
    
    static func createTimerLabelText(with durationTimer: Int) -> String {
        let durationMinutes = durationTimer / 60
        let durationSeconds = durationTimer % 60
        let leftSide = prepareStringSide(with: durationMinutes)
        let rightSide = prepareStringSide(with: durationSeconds)
        
        func prepareStringSide(with duration: Int) -> String {
            duration >= 10
            ? String(duration)
            : connectValues(data: [Int(), duration])
        }
        
        func connectValues(data: [Int]) -> String {
            data.map({ String($0) }).joined()
        }

        return leftSide + DataMetric.divideSymbol + rightSide
    }
    
    static func createLabel() -> UILabel {
        let label = UILabel()
        label.text = createTimerLabelText(with: DataMetric.durationMinutesWork * DataMetric.durationSeconds)
        label.font = UIFont.systemFont(ofSize: 60)
        label.textColor = .f5cac5
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = Bool()
        return label
    }
    
    static func createButton() -> UIButton {
        let button = UIButton()
        button.isEnabled = true
        button.frame = CGRect(x: 185, y: 310, width: 60, height: 60)
        button.setBackgroundImage(DataMetric.imageButtonPlay, for: .normal)
        button.tintColor = .f5cac5
        button.translatesAutoresizingMaskIntoConstraints = Bool()
        return button
    }
    
    static func createShapeLayer(color: UIColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let center = CGPoint(x: 150, y: 150)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPoint = UIBezierPath(arcCenter: center, radius: 138, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        shapeLayer.path = circularPoint.cgPath
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = color.cgColor
        return shapeLayer
    }
}
