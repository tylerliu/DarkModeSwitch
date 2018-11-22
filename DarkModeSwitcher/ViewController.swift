//
//  ViewController.swift
//  DarkModeSwitcher
//
//  Created by Tyler on 2018/11/19.
//  Copyright © 2018 Tyler Liu. All rights reserved.
//

import Cocoa
import ServiceManagement

class ViewController: NSViewController, NSWindowDelegate {
    
    
    
    @IBOutlet weak var scheduleOption: NSPopUpButton!
    @IBOutlet weak var manualOption: NSMenuItem!
    @IBOutlet weak var sunOption: NSMenuItem!
    @IBOutlet weak var customOption: NSMenuItem!
    
    @IBOutlet weak var lightTimePicker: NSDatePicker!
    @IBOutlet weak var darkTimePicker: NSDatePicker!
    @IBOutlet weak var lightTimeLabel: NSTextField!
    @IBOutlet weak var darkTimeLabel: NSTextField!
    
    @IBOutlet weak var bootCheckBox: NSButton!
    
    //TODO Shift switch time before sunrise/sunset
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadFromPreference()
        SchedulerBackground.startBackground();
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func loadFromPreference() {
        Preference.loadPreference();
        
        lightTimePicker.dateValue = Preference.getDate(time: Preference.lightTime);
        darkTimePicker.dateValue = Preference.getDate(time: Preference.darkTime);
        bootCheckBox.state = Preference.runOnBoot ? .on : .off;
        
        scheduleOption.select(scheduleOption.item(at: Preference.scheduleType));
        optionChanged(scheduleOption);
    }
    
    @IBAction func optionChanged(_ sender: NSPopUpButton) {
        //set enable and color
        let enableSchedule = sender.selectedItem == customOption
        lightTimeLabel.isEnabled = enableSchedule
        darkTimeLabel.isEnabled = enableSchedule
        lightTimePicker.isEnabled = enableSchedule
        darkTimePicker.isEnabled = enableSchedule
        let textColor = enableSchedule ? NSColor.labelColor : NSColor.secondaryLabelColor
        lightTimeLabel.textColor = textColor
        darkTimeLabel.textColor = textColor
        lightTimePicker.textColor = textColor
        darkTimePicker.textColor = textColor
        
        //send action
        Preference.setPreferenceType(scheduleType: sender.index(of: sender.selectedItem!))
        SchedulerBackground.alertChange();
    }
    
    @IBAction func TimeChanged(_ sender: NSDatePicker) {
        Preference.setPreference(lightTime: Preference.getTime(date: lightTimePicker.dateValue),
                                 darkTime: Preference.getTime(date: darkTimePicker.dateValue))
        
    }
    
    @IBAction func runOnBoot(_ sender: Any) {
        Preference.setRunOnBoot(runOnBoot: bootCheckBox?.state == .on);
        if (!AppDelegate.setBoot(state: Preference.runOnBoot)) {
            print("Set on boot failed");
        }
    }
    @IBAction func TerminationRequested(_ sender: Any) {
        exit(EXIT_SUCCESS);
    }
}

