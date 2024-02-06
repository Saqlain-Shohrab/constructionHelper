//
//  ProjectTVC.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import UIKit

class ProjectTVC: UITableViewCell {
    
    static let ESTIMATE_HEIGHT: CGFloat = 276
    
    @IBOutlet weak var projectView: ProjectView!

    func bind(_ projectItemView: ProjectsModelItemView, locationInList: Int) {
        projectView.bind(projectItemView, locationInList: locationInList)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
