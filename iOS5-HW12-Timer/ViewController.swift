//
//  ViewController.swift
//  iOS5-HW12-Timer
//
//  Created by Дарья Кретюк on 16.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var timer = Timer()
    static var durationMinutesWork = 1
    static var durationMinutesRelax = 1
    static var durationSeconds = 10
    var durationTimer = ViewController.durationMinutesWork * ViewController.durationSeconds
    var isWork = true
    var ms = Double()
    var isTuppedButton = false
    var isPause = false
    
    let label : UILabel = {
        let label = UILabel()
        label.text = "\((durationMinutesWork >= 10) ? "\(durationMinutesWork)" : "0\(durationMinutesWork)"):00"
        label.font = UIFont.systemFont(ofSize: 60)
        label.textColor = .f5cac5
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let button : UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.frame = CGRect(x: 185, y: 310, width: 60, height: 60)
        button.setBackgroundImage(ViewController.imageButtonPlay, for: .normal)
        button.tintColor = .f5cac5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shapeView : CAShapeLayer = {
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
        shapeLayer.strokeColor = UIColor.f6cfcb.cgColor
        return shapeLayer
    }()
    
    let progressView : CAShapeLayer = {
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
        shapeLayer.strokeColor = UIColor.f5cac5.cgColor
        return shapeLayer
    }()
    
    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer + 1)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        progressView.add(basicAnimation, forKey: "basicAnimation")
    }
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .clear
        mainView.layer.addSublayer(shapeView)
        mainView.layer.addSublayer(progressView)
        mainView.addSubview(label)
        view.addSubview(button)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return mainView
    }()
    
    @objc func startButtonTapped() {
        if !isTuppedButton {
            isTuppedButton = true
            button.setBackgroundImage(ViewController.imageButtonPause, for: .normal)
            if isPause {
                isPause = false
                resumeAnimation()
            } else {
                basicAnimation()
            }
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
            pauseAnimation()
            button.setBackgroundImage(ViewController.imageButtonPlay, for: .normal)
            button.tintColor = checkState().dark
            isTuppedButton = false
            isPause = true
        }
    }
    
    @objc func timerAction() {
        if ms == 1000 {
            let durationMinutes = durationTimer / 60
            let durationSeconds = durationTimer % 60
            if durationTimer == 0 {
                button.setBackgroundImage(ViewController.imageButtonPlay, for: .normal)
                if isWork {
                    isWork = false
                    changeState()
                } else {
                    isWork = true
                    changeState()
                }
            } else {
                durationTimer -= 1
                label.text = "\((durationMinutes >= 10) ? "\(durationMinutes)" : "0\(durationMinutes)"):\((durationSeconds >= 10) ? "\(durationSeconds)" : "0\(durationSeconds)")"
            }
            ms = Double()
        } else {
            ms += 1.0
        }
    }
    
    func changeState() {
        changeLabelDurationTimer(durationMinutes: ViewController.durationMinutesRelax)
        label.textColor = checkState().dark
        button.tintColor = checkState().dark
        shapeView.strokeColor = checkState().light.cgColor
        progressView.strokeColor = checkState().dark.cgColor
        isTuppedButton = false
        timer.invalidate()
        startButtonTapped()
    }
    
    func changeLabelDurationTimer(durationMinutes: Int) {
        durationTimer = durationMinutes * ViewController.durationSeconds
        let durationMinutes = durationTimer / 60
        let durationSeconds = durationTimer % 60
        label.text = "\((durationMinutes >= 10) ? "\(durationMinutes)" : "0\(durationMinutes)"):\((durationSeconds >= 10) ? "\(durationSeconds)" : "0\(durationSeconds)")"
    }
    
    func pauseAnimation() {
        let pausedTime = progressView.convertTime(CACurrentMediaTime(), from: nil)
        progressView.speed = 0
        progressView.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = progressView.timeOffset
        progressView.speed = 1
        progressView.timeOffset = 0
        progressView.beginTime = 0
        let timeSincePause = progressView.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressView.beginTime = timeSincePause
    }
    
    private lazy var parentsStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = false
        stackView.backgroundColor = .systemPurple
        stackView.spacing = 100
        
        return stackView
    }()
    
    func checkState() -> (light: UIColor, dark: UIColor) {
        switch isWork {
            case true:
                return (light: .f6cfcb, dark: .f5cac5)
            case false:
                return (light: .f3faf8, dark: ._5ec8a4)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(parentsStackView)
        parentsStackView.addArrangedSubview(mainView)
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 300),
            mainView.widthAnchor.constraint(equalToConstant: 300),
            label.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 80),
            label.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 70),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 160),
            button.heightAnchor.constraint(equalToConstant: 80),
            button.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}

extension ViewController {
    static var imageButtonPlay = UIImage(systemName: "play")
    static var imageButtonPause = UIImage(systemName: "pause")
    
}
