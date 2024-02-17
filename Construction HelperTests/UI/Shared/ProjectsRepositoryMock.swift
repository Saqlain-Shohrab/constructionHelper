//
//  ProjectsRepositoryMock.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 17/02/2024.
//

import Foundation
@testable import Construction_Helper

class ProjectsRepositoryMock: ProjectsRepository {
    
    var dataValue: [ProjectsModelItemView]? = nil
    
    override func requestData() {
        if let dataValue = dataValue {
            onProjectsRetrived.fire(dataValue)
        } else {
            onError.fire(true)
        }
    }
}
