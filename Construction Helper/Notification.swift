//
//  Notification.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation

class Notifications {
    
    static let PresentView =                NSNotification.Name(rawValue: "PresentView")
    static let ShowView =                   NSNotification.Name(rawValue: "ShowView")
    static let ShowViewAsPopover =          NSNotification.Name(rawValue: "ShowViewAsPopover")
    static let DismissAllPopovers =         NSNotification.Name(rawValue: "DismissAllPopovers")
    static let ShowPopup =                  NSNotification.Name(rawValue: "ShowPopup")
    static let ShowWarning =                NSNotification.Name(rawValue: "ShowWarning")
    static let ViewScrolledDown =           NSNotification.Name(rawValue: "ViewScrolledDown")
    static let ViewScrolledUp =             NSNotification.Name(rawValue: "ViewScrolledUp")
    
}
