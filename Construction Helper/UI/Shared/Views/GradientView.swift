//
//  GradientView.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var firstColor: UIColor = UIColor.clear
    @IBInspectable var secondColor: UIColor = UIColor.clear
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.0, y: 1.0)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @IBInspectable var type: String = "axial"

    var gradientLayer: CAGradientLayer?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if (gradientLayer != nil) {
            return
        }

        gradientLayer = CAGradientLayer()
        self.gradientLayer!.type = type
        self.gradientLayer!.colors = [firstColor.cgColor, secondColor.cgColor]
        self.gradientLayer!.startPoint = self.startPoint
        self.gradientLayer!.endPoint = self.endPoint
        self.gradientLayer!.frame = self.bounds
        self.layer.addSublayer(self.gradientLayer!)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.gradientLayer?.frame.height == self.bounds.height {
            return
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.gradientLayer?.frame = self.bounds
        CATransaction.commit()
    }
    
    func redrawWithNewColors(firstColor: UIColor, secondColor: UIColor) {
        
        self.firstColor = firstColor
        self.secondColor = secondColor
        gradientLayer = nil

        setNeedsDisplay()
    }
}
