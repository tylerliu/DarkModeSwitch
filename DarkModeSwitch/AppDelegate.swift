//
//  AppDelegate.swift
//  DarkModeSwitch
//
//  Created by Tyler on 2018/11/19.
//  Copyright © 2018 Tyler Liu. All rights reserved.
//

import Cocoa
import CoreLocation

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window = NSApplication.shared.windows.first;
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(onWakeNote(note:)),
            name: NSWorkspace.didWakeNotification, object: nil)
        window?.close()
    }
    
    static func setBoot(state : Bool) {
        toggleLaunchAtStartup(state: state);
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        window?.makeKeyAndOrderFront(self);
        return true;
    }
    
    @objc func onWakeNote(note: NSNotification) {
        LocationService.update();
        SchedulerBackground.alertChange();
    }
}

