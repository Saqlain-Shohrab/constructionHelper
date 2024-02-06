//
//  Schedule+Register.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import BackgroundTasks

extension BGTaskScheduler {
    
    public static let APP_REFRESH_TASK_DENTIFIER = "com.saqqu.constructionhelper.appRefreshTask"
    public static let BACKGROUND_TASK_DENTIFIER = "com.saqqu.constructionhelper.processingTask"
}

class BackgroundTaskSchedular {
    
    func registerTask(identifier: String) {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: identifier,
            using: nil) { task in
                
                self.handleAppRefreshTask(task: task as! BGAppRefreshTask, with: identifier)
            }
    }
    
    private func handleAppRefreshTask(task: BGAppRefreshTask, with identifier: String) {
        
        scheduleAppRefresh(with: identifier)
        
        task.expirationHandler = {
            //MARK: Control project's versioning locally
            task.setTaskCompleted(success: false)
        }
        
        updateData { success in
            task.setTaskCompleted(success: success)
        }
    }
    
    private func updateData(completion: @escaping(Bool) -> Void) {
        //MARK: Get and upload data to server in the current thread -> Then call completion true/false on success/failure
        //MARK: Make sure the repository responds to completion
        let projectRepository = ProjectsRepository()
        projectRepository.requestDataForOfflineSync { status in
            completion(status)
        }
    }
    
    func scheduleAppRefresh(with identifier: String) {
        
        let request = BGAppRefreshTaskRequest(identifier: identifier)
        let interval: Int = UserSettings.currentSettings.sheduleTaskEveryXMinutes ?? (60 * 60)
        request.earliestBeginDate = Date(timeIntervalSinceNow: TimeInterval(interval))
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Schedule failed for: \(identifier)")
        }
        
    }
    
    func resceduleAppRefresh(with identifier: String) {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: identifier)
        scheduleAppRefresh(with: identifier)
    }
    
    func triggerTask() {
        
    }
}
