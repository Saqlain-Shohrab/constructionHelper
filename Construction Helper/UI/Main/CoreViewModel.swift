//
//  CoreViewModel.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation
import UIKit

class CoreViewModel {
    
    func shouldDismissToRoot(_ rootViewController: UIViewController, _ targetVcType: UIViewController.Type) -> Bool {
        return type(of: rootViewController) == targetVcType
    }
    
    func dismissToTargetVC(_ rootViewController: UIViewController, _ targetVcType: UIViewController.Type) {
        
        var topViewController = rootViewController
        var viewControllers = [UIViewController]()

        // Collect all view controllers on the stack
        while let popoverController = topViewController.presentedViewController {
            topViewController = popoverController
            viewControllers.insert(popoverController, at: 0)
        }
        
        // Dismiss all view controllers up to the target view controller
        for viewController in viewControllers {
            if type(of: viewController) == targetVcType {
                return
            }
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func didSelect(tabPosition: Int?, _ navController: UINavigationController?) {

        var view: UIViewController?
        
        guard let tabPosition = tabPosition else { return }
        
        switch tabPosition {
        case 0: view = ViewFactory.createView(screenName: .HOME); break
        case 1: view = ViewFactory.createView(screenName: .PROJECTS); break
        default:
            break
        }

        NotificationCenter.default.post(name: Notifications.ShowView, object: view)
    }
}
