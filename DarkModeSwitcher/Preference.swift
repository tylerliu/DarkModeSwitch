//
//  Preference.swift
//  DarkModeSwitch
//
//  Created by Tyler on 2018/11/22.
//  Copyright © 2018 Tyler Liu. All rights reserved.
//

import Cocoa

//class that handles all the preferences
class Preference {

    //launched before
    //enum type
    //2 ints indicating times(either for schedule or for shift)
    
    static let SWITCH_OFF = 0
    static let SWITCH_SUN = 1
    static let SWITCH_SCHEDULE = 2
    
    static var launchedBefore = false
    
    //0 as off, 1 as sunrise/sunset, 2 as schedule
    private(set) static var scheduleType = 0
    //for scheduled
    private(set) static var lightTime = 0
    private(set) static var darkTime = 0
    //for sunrise/sunset with shift
    private(set) static var lightShift = 0
    private(set) static var darkShift = 0
    private(set) static var lat = 0.0
    private(set) static var lon = 0.0
    
    //run on boot
    private(set) static var runOnBoot = false
    
    static func loadPreference() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Loading to launch.")
            Preference.launchedBefore = true
            scheduleType = UserDefaults.standard.integer(forKey: "scheduleType")
            lightTime = UserDefaults.standard.integer(forKey: "lightTime")
            darkTime = UserDefaults.standard.integer(forKey: "darkTime")
            
            runOnBoot = UserDefaults.standard.bool(forKey: "runOnBoot")
            
            
            lightShift = UserDefaults.standard.integer(forKey: "lightShift")
            darkShift = UserDefaults.standard.integer(forKey: "darkShift")
            lat = UserDefaults.standard.double(forKey: "lat")
            lon = UserDefaults.standard.double(forKey: "lon")
        } else {
            print("Initial launch.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            Preference.launchedBefore = false
            UserDefaults.standard.set(0, forKey: "scheduleType")
            UserDefaults.standard.set(6 * 3600, forKey: "lightTime")
            UserDefaults.standard.set(18 * 3600, forKey: "darkTime")
            
            UserDefaults.standard.set(false, forKey: "runOnBoot")
            
            UserDefaults.standard.set(0, forKey: "lightShift")
            UserDefaults.standard.set(0, forKey: "darkShift")
            UserDefaults.standard.set(0.0, forKey: "lat")
            lon = LocationService.approximateLonFromTZ()
            UserDefaults.standard.set(lon, forKey: "lon")
            
            triggerPermission()
        }
    }
    
    static func setPreferenceType(scheduleType : Int) {
        Preference.scheduleType = scheduleType
        UserDefaults.standard.set(scheduleType, forKey: "scheduleType")
    }
    
    static func setPreference(lightTime : Int, darkTime : Int) {
        Preference.scheduleType = SWITCH_SCHEDULE
        Preference.lightTime = lightTime
        Preference.darkTime = darkTime
        UserDefaults.standard.set(SWITCH_SCHEDULE, forKey: "scheduleType")
        UserDefaults.standard.set(lightTime, forKey: "lightTime")
        UserDefaults.standard.set(darkTime, forKey: "darkTime")
    }
    
    static func setPreference(lightShift : Int, darkShift : Int) {
        Preference.scheduleType = SWITCH_SUN
        Preference.lightShift = lightShift
        Preference.darkShift = darkShift
        UserDefaults.standard.set(SWITCH_SCHEDULE, forKey: "scheduleType")
        UserDefaults.standard.set(lightShift, forKey: "lightShift")
        UserDefaults.standard.set(darkShift, forKey: "darkShift")
    }
    
    static func setRunOnBoot(runOnBoot : Bool) {
        Preference.runOnBoot = runOnBoot
        UserDefaults.standard.set(runOnBoot, forKey: "runOnBoot")
    }
    
    static func setLocation(lat : Double, lon : Double) {
        Preference.lat = lat
        Preference.lon = lon
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(lon, forKey: "lon")
    }
    
    //utility function
    public static func getTime(date : Date) -> Int {
        let comp = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        let hour = comp.hour!
        let minute = comp.minute!
        let second = comp.second!
        return hour * 3600 + minute * 60 + second
    }
    
    public static func getDate(time : Int) -> Date {
        return Calendar.current.date(bySettingHour: time / 3600, minute: (time % 3600) / 60, second: time % 60, of: Date()) ?? Date()
    }
    
}
