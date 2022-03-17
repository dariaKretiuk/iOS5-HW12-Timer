//
//  ViewController.swift
//  iOS5-HW12-Timer
//
//  Created by Дарья Кретюк on 16.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Elements
    
    private lazy var timer = Timer()
    private lazy var ms = Double()
    private lazy var durationTimer = DataMetric.durationMinutesWork * DataMetric.durationSeconds
    private lazy var isWork = !Bool()
    private lazy var isTuppedButton = Bool()
    private lazy var isPause = Bool()
    
    private let label : UILabel = {
        createLabel()
    }()
    
    private let button : UIButton = {
        createButton()
    }()
    
    private let shapeView : CAShapeLayer = {
        createShapeLayer(color: UIColor.f6cfcb)
    }()
    
    private let progressView : CAShapeLayer = {
        createShapeLayer(color: UIColor.f5cac5)
    }()
    
    private lazy var parentsStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = Bool()
        stackView.backgroundColor = .systemPurple
        stackView.spacing = 100
        return stackView
    }()
    
    private lazy var mainView: UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = Bool()
        mainView.backgroundColor = .clear
        mainView.layer.addSublayer(shapeView)
        mainView.layer.addSublayer(progressView)
        mainView.addSubview(label)
        view.addSubview(button)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return mainView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayouts()
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupHierarchy() {
        view.addSubview(parentsStackView)
        parentsStackView.addArrangedSubview(mainView)
    }
    
    private func setupLayouts() {
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
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = !Bool()
        progressView.add(basicAnimation, forKey: "basicAnimation")
    }
    
    private func changeState() {
        durationTimer = isWork ? DataMetric.durationMinutesWork * DataMetric.durationSeconds : (DataMetric.durationMinutesRelax * DataMetric.durationSeconds)
        label.text = ViewController.createTimerLabelText(with: durationTimer)
        label.textColor = checkState().dark
        button.tintColor = checkState().dark
        shapeView.strokeColor = checkState().light.cgColor
        progressView.strokeColor = checkState().dark.cgColor
        isTuppedButton.toggle()
        timer.invalidate()
        startButtonTapped()
    }
    
    private func pauseAnimation() {
        let pausedTime = progressView.convertTime(CACurrentMediaTime(), from: nil)
        progressView.speed = 0
        progressView.timeOffset = pausedTime
    }
    
    private func resumeAnimation() {
        isPause.toggle()
        let pausedTime = progressView.timeOffset
        progressView.speed = 1
        progressView.timeOffset = 0
        progressView.beginTime = 0
        let timeSincePause = progressView.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressView.beginTime = timeSincePause
    }
    
    private func checkState() -> (light: UIColor, dark: UIColor) {
        switch isWork {
            case true:
                return (light: .f6cfcb, dark: .f5cac5)
            default:
                return (light: .f3faf8, dark: .c5ec8a4)
        }
    }
    
    private func createTimer(_ selector: Selector) -> Timer {
        Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: selector, userInfo: nil, repeats: !Bool())
    }
    
    // MARK: - Actions
    
    @objc func startButtonTapped() {
        if !isTuppedButton {
            button.setBackgroundImage(DataMetric.imageButtonPause, for: .normal)
            timer = createTimer(#selector(timerAction))
            isPause ? resumeAnimation() : basicAnimation()
        } else {
            timer.invalidate()
            pauseAnimation()
            button.setBackgroundImage(DataMetric.imageButtonPlay, for: .normal)
            button.tintColor = checkState().dark
            isPause.toggle()
        }
        isTuppedButton.toggle()
    }
    
    @objc func timerAction() {
        ms += 1
        if ms >= 1000 {
            durationTimer -= 1
            ms = Double()
            if durationTimer == Int() {
                button.setBackgroundImage(DataMetric.imageButtonPlay, for: .normal)
                isWork = !isWork
                changeState()
            } else {
                label.text = ViewController.createTimerLabelText(with: durationTimer)
            }
        }
    }
}
