//
//  UIColourExt.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import UIKit

extension UIColor {
    
    class func brandColor() -> UIColor {
        return UIColor(rgb: 0x2D5FFE)
    }
    
    class func bottomNavBarColorDark() -> UIColor {
        return UIColor(rgb: 0x061128)
    }
    
    class func navbarColorDark() -> UIColor {
        return UIColor(rgb: 0x061128)
    }
    
    class func backgroundColour() -> UIColor {
        return UIColor(white: 0xFFFFFF, alpha: 0.87)
    }
    
    class func whiteWithAlpha(_ alpha: CGFloat) -> UIColor {
        return .white.withAlphaComponent(alpha)
    }
    
    // To support hex
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
