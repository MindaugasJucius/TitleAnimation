//
//  ViewController.swift
//  TitleAnimation
//
//  Created by Mindaugas Jucius on 22/01/2017.
//  Copyright © 2017 Mindaugas Jucius. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum ScalePosition {
        case down
        case up
        
        var to: CFTimeInterval {
            switch self {
            case .down:
                return 0.55
            case .up:
                return 1.0
            }
        }
        
    }
    
    enum TimingFunction {
        case easeIn
        case easeOut
    }
    
    fileprivate let beginLabel: UILabel = {
        let label = UILabel()
        label.text = "B"
        label.font = UIFont.boldSystemFont(ofSize: 88)
        return label
    }()
    
    fileprivate let endLabel: UILabel = {
        let label = UILabel()
        label.text = "URST"
        label.font = UIFont.boldSystemFont(ofSize: 88)
        return label
    }()
    
    fileprivate let fakeLabel: UILabel = {
        let label = UILabel()
        label.text = "BURST"
        label.textColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 88)
        return label
    }()
    
    fileprivate var beginLabelXConstraint: NSLayoutConstraint?
    fileprivate var endLabelXConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        add(label: fakeLabel)
        add(beginLabel: beginLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addScaleAnimation()
    }
    
    fileprivate func add(beginLabel: UILabel) {
        view.addSubview(beginLabel)
        beginLabel.translatesAutoresizingMaskIntoConstraints = false
        beginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        beginLabelXConstraint = beginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        beginLabelXConstraint?.isActive = true
    }

    fileprivate func add(endLabel: UILabel) {
        view.addSubview(endLabel)
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        endLabelXConstraint = endLabel.leftAnchor.constraint(equalTo: beginLabel.rightAnchor)
        endLabelXConstraint?.isActive = true
    }
    
    fileprivate func add(label: UILabel) {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    func scaleAnimation(position: ScalePosition, timingFunction: TimingFunction, beginTime: CFTimeInterval = 0.0) -> CASpringAnimation  {
        let animationFunction = timingFunction == .easeIn ? kCAMediaTimingFunctionEaseIn : kCAMediaTimingFunctionEaseIn
        let from = position == .up ? 0.55 : 1
        let scaleAnimation = CASpringAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = from
        scaleAnimation.toValue = position.to
        scaleAnimation.duration = 0.3
        scaleAnimation.beginTime = beginTime
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: animationFunction)
        return scaleAnimation
    }
    
    private func addScaleAnimation() {
        
        let scaleDown = scaleAnimation(position: .down, timingFunction: .easeIn)
        let scaleUp = scaleAnimation(position: .up, timingFunction: .easeOut, beginTime: scaleDown.duration)

        let scaleGroup = CAAnimationGroup()
        scaleGroup.animations = [scaleDown, scaleUp]
        scaleGroup.duration = scaleUp.beginTime + scaleUp.duration
        beginLabel.layer.add(scaleGroup, forKey: nil)
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(addPositionAnimation), userInfo: nil, repeats: false)
    }
    
    func addPositionAnimation() {
        //let diffX = (fakeLabel.frame.width - endLabel.frame.width) / 2
        print(beginLabel.layer.position.x)
        print(beginLabel.frame.origin.x)
        let originalX = beginLabel.layer.position.x
        let endX = fakeLabel.frame.origin.x + (beginLabel.layer.position.x - beginLabel.frame.origin.x)
        
        beginLabelXConstraint?.constant = endX - fakeLabel.center.x
        let translateX = CABasicAnimation(keyPath: "position.x")
        translateX.fromValue = originalX
        translateX.toValue = endX
        translateX.beginTime = 0.0
        translateX.duration = 0.2
        translateX.delegate = self
        translateX.isRemovedOnCompletion = false
        translateX.fillMode = kCAFillModeForwards
        translateX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        beginLabel.layer.add(translateX, forKey: nil)
        add(endLabel: endLabel)
    }

}

extension ViewController: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

    }
}
