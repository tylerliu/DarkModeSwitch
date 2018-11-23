//
//  Switcher.swift
//  DarkModeSwitch
//
//  Created by Tyler on 2018/11/19.
//  Copyright © 2018 Tyler Liu. All rights reserved.
//

import Foundation

func setDarkMode(mode: Bool) {
    if isDarkMode() == mode {
        return;
    }
    
    let code = "tell application \"System Events\" \ntell appearance preferences to set dark mode to " + (mode ? "true" : "false") +
        "\nend tell";
    
    var error: NSDictionary?
    if let scriptObject = NSAppleScript(source: code) {
        if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
            print(outputString)
        } else if (error != nil) {
            print("error: ", error!)
        }
    }
}

func isDarkMode() -> Bool {
    let osxMode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
    return osxMode == "Dark";
}

func triggerPermission() {
    let code = "tell application \"System Events\" \ntell appearance preferences to return dark mode\nend tell";
    
    var error: NSDictionary?
    if let scriptObject = NSAppleScript(source: code) {
        if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
            print(outputString)
        } else if (error != nil) {
            print("error: ", error!)
        }
    }
}
