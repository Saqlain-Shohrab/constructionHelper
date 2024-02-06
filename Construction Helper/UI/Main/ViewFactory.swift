//
//  ViewFactory.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation
import UIKit

class ViewFactory {
    
    static func createView(screenName: ScreenName) -> UIViewController? {
        switch screenName  {
            
        case .HOME:                                  return createVC("Home", "HomeVC")
        case .PROJECTS:                              return createVC("Projects", "ProjectsVC")
        case .PROJECT:                               return createVC("Projects", "ProjectVC")
        case .PDF_VIEW:                              return createVC("Projects", "PDFViewVC")
            
        }
    }
    
    private static func createVC( _ storyboardName: String, _ vcName: String) -> UIViewController? {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: vcName)
    }
}
