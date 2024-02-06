//
//  ProjectsVM.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Signals

class ProjectsVM: NSObject {
    
    private let projectsRepository = ProjectsRepository()
    
    let onProjectsRetrived = Signal<Bool?>()
    let onError = Signal<Bool?>()
    var previousScrollPos: CGFloat = 0
    var projects = [ProjectsModelItemView]()
    
    override init() {
        super.init()
        
        self.setUpObservers()
    }
    
    private func setUpObservers() {
        
        projectsRepository.onProjectsRetrived.subscribe(with: self) { [weak self] projects in
            guard let weakSelf = self, let projects = projects else {return}
            weakSelf.projects = projects
            weakSelf.onProjectsRetrived.fire(true)
        }
        
        projectsRepository.onError.subscribe(with: self) { [weak self] hasError in
            guard let weakSelf = self, let hasError = hasError else {return}
            weakSelf.onError.fire(hasError)
        }
        
        projectsRepository.onProjectUpdated.subscribe(with: self) { [weak self]  project in
            guard let weakSelf = self else {return}
            if let index = weakSelf.projects.firstIndex(where: { projectInArray in projectInArray.id == project.id }) {
                weakSelf.projects[index] = project
                weakSelf.onProjectsRetrived.fire(true)
            }
        }
        
        requestData()
    }
    
    func requestData() {
        projectsRepository.requestData()
    }
    
}

extension ProjectsVM: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectTVC.identifier, for: indexPath) as? ProjectTVC
        cell?.bind(projects[indexPath.row], locationInList: indexPath.row)
        return  cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewFactory.createView(screenName: .PROJECT) as! ProjectVC
        vc.project = projects[indexPath.row]
        vc.navigationItem.hidesBackButton = false
        NotificationCenter.default.post(name: Notifications.ShowView, object: vc)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProjectTVC.ESTIMATE_HEIGHT//UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProjectTVC.ESTIMATE_HEIGHT
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var offsetY = scrollView.contentOffset.y
        offsetY = offsetY < 0 ? 0 : offsetY

        if (self.previousScrollPos < offsetY) {
            NotificationCenter.default.post(name: Notifications.ViewScrolledDown, object: nil)
        }
        else if (self.previousScrollPos > offsetY) {
            NotificationCenter.default.post(name: Notifications.ViewScrolledUp, object: nil)
        }

        previousScrollPos = offsetY
        
    }
}
