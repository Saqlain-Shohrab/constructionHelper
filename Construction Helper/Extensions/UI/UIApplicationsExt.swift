//
//  UIApplicationsExt.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import UIKit

extension UIApplication {
    class func appName() -> String {
        return Bundle.main.infoDictionary?["CFBundleName"] as! String
    }

    class func appVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }

    class func appBuildVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    }
    
    class var statusBarBackgroundColor: UIColor? {
        get {
            return statusBarUIView?.backgroundColor
        } set {
            statusBarUIView?.backgroundColor = newValue
        }
    }

    class var statusBarUIView: UIView? {
        let tag = 987654321

        if let statusBar = UIApplication.shared.keyWindow?.viewWithTag(tag) {
            return statusBar
        }
        else {
            let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
            statusBarView.tag = tag

            UIApplication.shared.keyWindow?.addSubview(statusBarView)
            return statusBarView
        }
    }
}
