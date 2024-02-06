//
//  ProjectsVC.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import UIKit

class ProjectsVC: UITableViewController {

    private var viewModel: ProjectsVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ProjectsVM()
        setupTableView()
        setupObservers()
        
    }
    
    func setupObservers() {
        
        viewModel.onProjectsRetrived.subscribe(with: self) { [weak self] retrived in
            guard let weakSelf = self, let retrived = retrived else {return}
            
            if retrived {
                weakSelf.tableView.reloadData()
            }
        }
        
        viewModel.requestData()
    }
    
    func setupTableView() {
        
        tableView.backgroundColor = UIColor.backgroundColour()
        tableView.canCancelContentTouches = true
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        
        tableView.register(ProjectTVC.nib, forCellReuseIdentifier: ProjectTVC.identifier)
        tableView.contentInset = UIEdgeInsets.init(top: 0,left: 0,bottom: ViewHeightUtil.getTabBarAndWarningViewHeight(),right: 0)
        tableView.removeGroupedTopMargin()
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.tableView.reloadData()
            
        }
    }

}
