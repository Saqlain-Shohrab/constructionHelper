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
        
        viewModel = ProjectsVM(projectsRepository: ProjectsRepository())
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
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProjectTVC.nib, forCellReuseIdentifier: ProjectTVC.identifier)
        tableView.contentInset = UIEdgeInsets.init(top: 0,left: 0,bottom: ViewHeightUtil.getTabBarAndWarningViewHeight(),right: 0)
        tableView.removeGroupedTopMargin()
        
        DispatchQueue.main.async { [weak self] in
            
            guard let weakSelf = self else {return}
            
            weakSelf.tableView.reloadData()
            
        }
    }

}

extension ProjectsVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getProjects().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTVC.identifier, for: indexPath) as? ProjectTVC
        cell?.bind(viewModel.getProjects()[indexPath.row], locationInList: indexPath.row)
        return  cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewFactory.createView(screenName: .PROJECT) as! ProjectVC
        vc.project = viewModel.getProjects()[indexPath.row]
        vc.navigationItem.hidesBackButton = false
        NotificationCenter.default.post(name: Notifications.ShowView, object: vc)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProjectTVC.ESTIMATE_HEIGHT//UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProjectTVC.ESTIMATE_HEIGHT
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidScroll(scrollView.contentOffset.y)
    }
}
