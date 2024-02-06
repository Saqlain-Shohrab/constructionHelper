//
//  OfflineProjects.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 05/02/2024.
//

import Foundation
import RealmSwift
import Signals

class OfflineProjects {
    
    static let shared = OfflineProjects()
    let onProjectUpdated = Signal<Int>()
    
    private init() {}
    
    private func getToUpdateProjects(itemViewList: [ProjectsModelItemView], realmList: [ProjectsModel]) -> [ProjectsModelItemView]? {
        
        if realmList.isEmpty {return itemViewList}
        
        let updatesNeeded = itemViewList.compactMap { itemA -> ProjectsModelItemView? in
            guard let itemB = realmList.first(where: { $0.id == itemA.id }) else {
                return itemA
            }
            
            return itemA.version > itemB.version ? itemA : nil
        }

        return updatesNeeded

    }
    
    func addUpdateItemViewProjects(models: [ProjectsModelItemView], completion: @escaping (Bool) -> Void) {
        
        let savedModels = getAllProjects() ?? []
        let toUpdate = getToUpdateProjects(itemViewList: models, realmList: savedModels)
        
        if (toUpdate ?? []).isEmpty {
            completion(true)
            return
        }
        let realmProjects = transformToRealmModel(projectItemViews: toUpdate)
        addUpdateProjects(projects: realmProjects) { status in
            
            completion(status)
            return
        }
        
        
        completion(false)
    }
    
    private func addUpdateProjects(projects: [ProjectsModel], completion: @escaping (Bool) -> Void) {
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(projects, update: .all)
                
            }
        } catch let error as NSError {
            print("Error writing to Realm: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        completion(true)
    }
    
    private func addNewProject(model: ProjectsModel) {
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(model)
            }
        } catch let error as NSError {
            print("Error writing to Realm: \(error.localizedDescription)")
        }
        
    }
    
    func updateProject(with id: Int, for fileURL: String) {
        do {
            let realm = try Realm()
            
            try realm.write {
                if let projectToUpdate = realm.object(ofType: ProjectsModel.self, forPrimaryKey: id) {
                    projectToUpdate.fileURL = fileURL
                    onProjectUpdated.fire(id)
                } else {
                    //MARK: Log for future updates
                }
            }
        } catch let error as NSError {
            print("Error opening Realm: \(error.localizedDescription)")
        }
    }
    
    func getProject(with id: Int) -> ProjectsModelItemView? {
        do {
            let realm = try Realm()
            if let project = realm.object(ofType: ProjectsModel.self, forPrimaryKey: id) {
                return ProjectsModelItemView(model: project)
            }
        } catch let error as NSError {
            print("Error opening Realm: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    private func getAllProjects() -> [ProjectsModel]? {
        do {
            
            let realm = try Realm()
            let allProjects = realm.objects(ProjectsModel.self)
            
            allProjects.forEach { model in
                print(model.id, model.version, model.fileURL)
            }
            
            return Array(allProjects)
            
        } catch let error as NSError {
            print("Error opening Realm: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getAllItemViewProjects() -> [ProjectsModelItemView]? {
        
        let allProjects: [ProjectsModel] = getAllProjects() ?? []
        return transformToItemViewModel(realmProjects: allProjects)
        
    }
    
    func transformToRealmModel(projectItemViews: [ProjectsModelItemView]?) -> [ProjectsModel] {
        guard let projectItemViews = projectItemViews else { return [] }
        return projectItemViews.map { ProjectsModel(model: $0) }
    }
    
    func transformToItemViewModel(realmProjects: [ProjectsModel]?) -> [ProjectsModelItemView] {
        
        guard let realmProjects = realmProjects else { return [] }
        return realmProjects.map { ProjectsModelItemView(model: $0) }
    }

}
