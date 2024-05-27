//
//  ProjectsVM.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Signals

class ProjectsVM: NSObject {
    
    private var projectsRepository = ProjectsRepository()
    
    init(projectsRepository: ProjectsRepository) {
        self.projectsRepository = projectsRepository
        super.init()
        self.setUpObservers()
    }
    
    let onProjectsRetrived = Signal<Bool?>()
    let onError = Signal<Bool?>()
    var previousScrollPos: CGFloat = 0
    var projects = [ProjectsModelItemView]()
    
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
        
    }
    
    func requestData() {
        projectsRepository.requestData()
    }
    
    func getProjects() -> [ProjectsModelItemView] {
        return self.projects
    }
    
    func scrollViewDidScroll(_ scrollYpos: Double?) {
        
        var offsetY = scrollYpos ?? 0.0
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
