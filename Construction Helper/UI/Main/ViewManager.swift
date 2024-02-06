//
//  ViewManager.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation

class ViewManager {
    
    private func navigateToProjectsVC() {
        
        guard let vc = ViewFactory.createView(screenName: .PROJECTS) as? ProjectsVC else {return}
        
        
    }
    
    /*private func push(vc: inout UIViewController?) {
        
        guard
            vc != nil
                let navController = self.
            
    }*/
    
}
