//
//  RealmMigration.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 03/02/2024.
//

import RealmSwift
import Foundation

class RealmMigration {
    
    static func deleteRealmIfMigrationNeeded() {
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
    }
    
    static func migrateIfNeeded() {
        let config = Realm.Configuration(
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemVersion in
                if oldSchemVersion < 2 {
                    migrateToVersion2(migration)
                }
                
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    
    static func migrateToVersion2(_ migration: Migration) {
        
        migration.enumerateObjects(ofType: ProjectsModel.className()) { (old, new) in
            new?["newProperty"] = "propnew"
        }
    }
}
