//
//  UINavigationControllerExt.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    
    func fadeTo(_ viewController: UIViewController) {
        
        animateWithSlide()
        pushViewController(viewController, animated: false)
    }
    
    func fadeBack() {
        
        animateBackWithSlide()
        popViewController(animated: true)
    }
    
    func popToViewController(_ viewController: UIViewController) {
        
        animateWithSlide()
        popToViewController(viewController, animated: false)
    }
    
    func popViewController() {
        
        popViewController(animated: false)
    }
    
    func fadeBackToRoot() {
        
        animateWithSlide()
        popToRootViewController(animated: false)
    }
    
    func fadeBackNoAnim() {
        animateBackWithSlide()
        popViewController(animated: false)
    }
    
    private func animateBackWithSlide() {
        
        let transition: CATransition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.layer.add(transition, forKey: nil)
    }
    
    private func animateWithSlide() {
        
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: nil)
    }
    
    private func animateWithFade() {
        
        let transition: CATransition = CATransition()
        transition.duration = 0
        transition.type = kCATransitionFade
        view.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 1
            })
        }
        
        view.layer.add(transition, forKey: nil)
    }
}
