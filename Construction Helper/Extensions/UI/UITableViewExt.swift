//
//  UITableViewExt.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import UIKit

extension UITableView {
    
    func removeGroupedTopMargin() {
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableHeaderView = UIView(frame: frame)
    }
}
