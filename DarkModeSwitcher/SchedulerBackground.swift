//
//  SchedulerBackground.swift
//  DarkModeSwitch
//
//  Created by Tyler on 2018/11/21.
//  Copyright © 2018 Tyler Liu. All rights reserved.
//

import Cocoa

class SchedulerBackground : Thread{
    
    static var scheduler : SchedulerBackground?;
    static var settingChange = NSCondition();
    static var dataLock = NSCondition();
    
    override func main() {
        while true {
            if (self.isCancelled) {
                break;
            }
            SchedulerBackground.dataLock.lock();
            switch Preference.scheduleType {
            case Preference.SWITCH_SCHEDULE:
                let current = Preference.getTime(date: Date.init(timeIntervalSinceNow: 0)); // current time
                if Preference.lightTime == Preference.darkTime {
                    break; // do nothing
                } else if Preference.lightTime < Preference.darkTime { // normal
                    let isLight = Preference.lightTime <= current && current <= Preference.darkTime;
                    setDarkMode(mode: !isLight);
                } else {
                    let isDark = Preference.darkTime <= current && current <= Preference.lightTime;
                    setDarkMode(mode: isDark);
                }
            case Preference.SWITCH_SUN:
                break;
            case Preference.SWITCH_OFF:
                break;
            default:
                break;
            }
            SchedulerBackground.dataLock.unlock();
            SchedulerBackground.settingChange.lock();
            SchedulerBackground.settingChange.wait(until: Date.init(timeIntervalSinceNow: 10)); //10 second from now
            SchedulerBackground.settingChange.unlock();
        }
    }
    
    static func startBackground() {
        scheduler = SchedulerBackground();
        scheduler?.start();
    }
    
    static func alertChange() {
        settingChange.signal();
    }
    
    static func endBackground() {
        scheduler?.cancel();
    }
}
