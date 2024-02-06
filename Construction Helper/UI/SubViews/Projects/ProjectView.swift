//
//  ProjectView.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import UIKit

class ProjectView: UIView, NibLoadable {
    
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectTitleLabel: UILabel!
    @IBOutlet weak var projectLocationLabel: UILabel!
    
    private var model: ProjectsModelItemView!
    private var locationInList: Int!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupNib()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNib()
        
    }
    
    func setupNib() {
        setupFromNib()
    }
    
    func bind(_ projectItemView: ProjectsModelItemView, locationInList: Int) {
        self.model = projectItemView
        self.locationInList = locationInList
        initViews()
    }
    
    func initViews() {
        self.projectTitleLabel.text = model.title
        self.projectLocationLabel.text = model.location
        Helper.loadImageIntoView(imageUrl: model.image, imageView: projectImageView)
    }

}
