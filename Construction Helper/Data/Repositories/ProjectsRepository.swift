//
//  ProjectsRepository.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Signals

class ProjectsRepository {
    
    let onProjectsRetrived = Signal<[ProjectsModelItemView]?>()
    let onError = Signal<Bool?>()
    let onProjectUpdated = Signal<ProjectsModelItemView>()
    
    init() {
        subscribeForUniqueUpdates()
    }
    
    func requestDataForOfflineSync(completion: @escaping (Bool) -> Void) {
        
        //MARK: Network call and fetch data
        let dummyData = prepareDummyData()
        
        OfflineProjects.shared.addUpdateItemViewProjects(models: dummyData) { [weak self] status in
            
            guard let _ = self else  {
                completion(false)
                return
            }
            completion(status)
            if status {
                //MARK: Log server sync failure for future update
            }
        }
        
    }
    
    private func subscribeForUniqueUpdates() {
        OfflineProjects.shared.onProjectUpdated.subscribe(with: self) { [weak self] projectId in
            
            guard
                let weakSelf = self,
                let updatedProject = OfflineProjects.shared.getProject(with: projectId)
            else {return}
            
            weakSelf.onProjectUpdated.fire(updatedProject)
            
        }
    }
    
    func requestData() {
        
        if let savedProjects = OfflineProjects.shared.getAllItemViewProjects(), !savedProjects.isEmpty {
            onProjectsRetrived.fire(savedProjects)
        } else {
            requestDataForOfflineSync { [weak self] status in
                guard let weakSelf = self else {return}
                if status {
                    weakSelf.requestData()
                } else {
                    weakSelf.onError.fire(true)
                }
            }
        }
        
    }
    
    func requestProjectUpdate(with id: Int, path: String? = nil) {
        
        if let path = path {
            OfflineProjects.shared.updateProject(with: id, for: path)
        } else {
            getProjectUpdateFromServer(projectId: id) { [weak self] path in
                guard let weakSelf = self else {return}
                if let path = path {
                    OfflineProjects.shared.updateProject(with: id, for: path)
                } else {
                    weakSelf.onError.fire(true)
                }
            }
        }
    }
    
    private func getProjectUpdateFromServer(projectId: Int, completion: @escaping (String?) -> Void) {
        if let path = getDummyPdfUrl(projectId: projectId) {
            completion(path)
            return
        }
        completion(nil)
    }
    
}

//MARK: For creating Dummy data
extension ProjectsRepository {
    
    private func getDummyPdfUrl(projectId _ : Int) -> String? {
        return "https://vancouver.ca/files/cov/sample-drawing-package-1and2family.pdf"
    }
    
    private func prepareDummyData() -> [ProjectsModelItemView] {
        
        var projects = [ProjectsModelItemView]()
        var locations = ["Chicago", "Miami", "Dublin", "California", "Kolkata"]
        var titles = ["The Archies", "Homes of the Dunes", "General City Hospital", "Webcraft of  USA", "Legendary Taj Mahal"]
        
        let version = getVersion()
        
        for i in 1...13 {
            var model = ProjectsModelItemView()
            
            model.id = i
            model.name = "I am the name of project number \(i)"
            model.location = locations[Int.random(in: 0...4)]
            model.sector = "IT"
            model.client = "New Client"
            model.duration = "12th Dec, 2022 till today"
            model.title = titles[Int.random(in: 0...4)]
            model.desc = "I am the description of project number \(i)"
            model.image = "https://www.eidasolutions.com/wp-content/uploads/2021/09/Project-lifesciences-Bristol-Myer-Squibb-story-image.jpg"
            model.version = version
            model.fileURL = "https://vancouver.ca/files/cov/sample-drawing-package-1and2family.pdf"
            model.projectProgress = Double(arc4random_uniform(100) + 1)
            projects.append(model)
        }
        return projects
    }
    
    func getVersion() -> Double {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        
        return Double(hour) + Double(minute/10)
        
    }
}
