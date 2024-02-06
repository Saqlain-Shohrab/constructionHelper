//
//  ViewHeightUtil.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation

class ViewHeightUtil {
    
    private static let tabBarHeight: CGFloat = 50.0
    private static let warningViewHeight: CGFloat = 30.0
    
    static func getTabBarHeight() -> CGFloat {
        return tabBarHeight
    }
    
    static func getWarningViewHeight() -> CGFloat {
        return tabBarHeight
    }
    
    static func getTabBarAndWarningViewHeight() -> CGFloat {
        return tabBarHeight + warningViewHeight
    }
}
