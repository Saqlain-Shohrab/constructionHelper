//
//  AppDelegate.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 03/02/2024.
//

import UIKit
import RealmSwift
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var realm: Realm!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Realm
        RealmMigration.migrateIfNeeded()
        do {
            realm = try Realm()
        } catch {
            RealmMigration.deleteRealmIfMigrationNeeded()
            realm = try! Realm()
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        TaskDownloadFile.shared.backgroundSessionCompletionHandler = completionHandler
        
        let projectId = identifier.replacingOccurrences(of: BGTaskScheduler.BACKGROUND_TASK_DENTIFIER, with: "")
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(String(projectId))
        
        //try? FileManager.default.moveItem(at: location, to: destinationURL)
        //let fileURL = ""
        //OfflineProjects.shared.updateProject(with: projectId, for: fileURL)
    }


}

