//
//  AppDelegate.swift
//  DarkModeSwitch
//
//  Created by Tyler on 2018/11/19.
//  Copyright © 2018 Tyler Liu. All rights reserved.
//

import Cocoa
import ServiceManagement

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
        
        checkBoot()
    }
    
    func checkBoot() {
        let launcherID = "Tyler-Liu.SwitcherLauncher";
        let runningApps = NSWorkspace.shared.runningApplications;
        let launcherRunning = !runningApps.filter { $0.bundleIdentifier == launcherID }.isEmpty
        
        if launcherRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher,
                                                         object: Bundle.main.bundleIdentifier!)
            window?.close();
        }
    }
    
    static func setBoot(state : Bool)  -> Bool{
        let launcherID = "Tyler-Liu.SwitcherLauncher";
        return SMLoginItemSetEnabled(launcherID as CFString, state);
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        window?.makeKeyAndOrderFront(self);
        return true;
    }
    
    @objc func onWakeNote(note: NSNotification) {
        SchedulerBackground.alertChange();
    }
}

