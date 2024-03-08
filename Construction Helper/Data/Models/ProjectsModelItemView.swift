//
//  ProjectsModelItemView.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation

struct ProjectsModelItemView {
    
    var id = 0
    var name = ""
    var location = ""
    var sector = ""
    var client = ""
    var duration = ""
    var title = ""
    var desc = ""
    var version: Double = 0.0
    var image = ""
    /// When the fileURL is nil, download the update the local storage path of the file
    var fileURL: String? = nil
    var projectProgress: Double = 0.0
    
    init() {}
    
    init(model: ProjectsModel) {
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
        self.fileURL = model.fileURL
        self.projectProgress = model.projectProgress
    }
    
    func isAlreadyDownloaded() -> Bool {
        return (fileURL ?? "").starts(with: "file:///")
    }
}
