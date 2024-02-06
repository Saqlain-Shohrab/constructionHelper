//
//  ProjectsModel.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//
import RealmSwift
import Foundation

class ProjectsModel: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var location = ""
    @objc dynamic var sector = ""
    @objc dynamic var client = ""
    @objc dynamic var duration = ""
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var version: Double = 0.0
    @objc dynamic var image = ""
    @objc dynamic var fileURL = ""
    @objc dynamic var projectProgress: Double = 0.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required override init() {
        super.init()
    }
    
    init(model: ProjectsModelItemView) {
        self.id = model.id
        self.name = model.name
        self.location = model.location
        self.sector = model.sector
        self.client = model.client
        self.duration = model.duration
        self.title = model.title
        self.desc = model.desc
        self.version = model.version
        self.image = model.image
        self.fileURL = model.fileURL ?? ""
        self.projectProgress = model.projectProgress
    }
    
}
