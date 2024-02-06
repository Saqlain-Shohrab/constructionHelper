//
//  UserSettings.swift
//  Construction Helper
//
//  Created by Saqlain Shohrab on 04/02/2024.
//

import Foundation

class UserSettings: NSObject {
    
    static let BackgroundTaskInterval = "BackgroundTaskInterval"
    
    static let currentSettings = UserSettings()
    
    var sheduleTaskEveryXMinutes: Int? {
        get {
            return UserDefaults.standard.integer(forKey: UserSettings.BackgroundTaskInterval)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserSettings.BackgroundTaskInterval)
            UserDefaults.standard.synchronize()
        }
    }
}
