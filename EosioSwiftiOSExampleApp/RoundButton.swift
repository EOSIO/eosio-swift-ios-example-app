//
//  RoundButton.swift
//  EosioSwiftiOSExampleApp
//
//  Created by Farid Rahmani on 3/29/19.
//  Copyright © 2018-2019 block.one. All rights reserved.
//

import UIKit

class RoundButton: UIView {
    let label:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .white
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)

        label.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:))))
    }

    @objc
    func tapHandler(sender:UITapGestureRecognizer) {
        tapBlock?()
    }
    typealias TapBlock = () -> ()
    private var tapBlock:TapBlock?
    func doWhenTapped(block:@escaping TapBlock) {
        tapBlock = block
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func doTapAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = self.transform.scaledBy(x: 1.2, y: 1.2)
            self.alpha = 0.8
        }, completion: { completed in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.transform = .identity
                self.alpha = 1
            })
        })
    }

    func doWaitingAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "backgroundColor")
        basicAnimation.fromValue = UIColor.blue.cgColor
        basicAnimation.toValue = UIColor.purple.cgColor
        basicAnimation.duration = 3
        basicAnimation.repeatCount = .infinity
        basicAnimation.autoreverses = true
        basicAnimation.timeOffset = layer.presentation()?.timeOffset ?? 0

        let animation2 = CABasicAnimation(keyPath: "transform.scale")
        animation2.fromValue = 0.95
        animation2.toValue = 1.05
        animation2.repeatCount = .infinity
        animation2.autoreverses = true
        animation2.timeOffset = layer.presentation()?.timeOffset ?? 0
        layer.removeAllAnimations()
        self.layer.add(animation2, forKey: "kj")
        self.layer.add(basicAnimation, forKey: "waitingAnimation")
    }

    func doErrorAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "backgroundColor")
        basicAnimation.fromValue = UIColor.purple.cgColor
        basicAnimation.toValue = UIColor.red.cgColor
        basicAnimation.duration = 0.4
        basicAnimation.repeatCount = 2
        basicAnimation.autoreverses = true
        basicAnimation.timeOffset = layer.presentation()?.timeOffset ?? 0
        self.layer.add(basicAnimation, forKey: "errorAnimation")
    }

    func doNormalAnimation() {
        layer.removeAllAnimations()
        let basicAnimation = CABasicAnimation(keyPath: "backgroundColor")
        basicAnimation.fromValue = UIColor.blue.cgColor
        basicAnimation.toValue = UIColor.purple.cgColor
        basicAnimation.duration = 4
        basicAnimation.repeatCount = .infinity
        basicAnimation.autoreverses = true
        self.layer.add(basicAnimation, forKey: "normalColor")

        let animation2 = CABasicAnimation(keyPath: "transform.scale")
        animation2.fromValue = 0.95
        animation2.toValue = 1.05
        animation2.duration = 4
        animation2.repeatCount = .infinity
        animation2.autoreverses = true
        self.layer.add(animation2, forKey: "normalScale")
    }
}
