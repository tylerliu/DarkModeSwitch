//
//  ViewController.swift
//  DarkModeSwitch
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
    
    //Manual Components
    @IBOutlet weak var lightButton: NSButton!
    @IBOutlet weak var darkButton: NSButton!
    
    //Custom Schedule Components
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
        //set hiding
        
        //manual
        let onManual = sender.selectedItem == manualOption
        lightButton.isHidden = !onManual
        darkButton.isHidden = !onManual
        if onManual {
            updateManualButtons()
        }
        
        //sunrise and sunset
        let onSun = sender.selectedItem == sunOption
        if onSun {
            LocationService.startMonitor()
        } else {
            LocationService.stopMonitor()
        }
        
        //custom
        let onCustom = sender.selectedItem == customOption
        lightTimeLabel.isHidden = !onCustom
        darkTimeLabel.isHidden = !onCustom
        lightTimePicker.isHidden = !onCustom
        darkTimePicker.isHidden = !onCustom
        
        //send action
        Preference.setPreferenceType(scheduleType: sender.index(of: sender.selectedItem!))
        SchedulerBackground.alertChange();
    }
    
    @IBAction func TimeChanged(_ sender: NSDatePicker) {
        Preference.setPreference(lightTime: Preference.getTime(date: lightTimePicker.dateValue),
                                 darkTime: Preference.getTime(date: darkTimePicker.dateValue))
        
    }
    
    @IBAction func manualButtonClicked(_ sender: NSButton) {
        setDarkMode(mode: sender == darkButton)
        updateManualButtons()
    }
    
    func updateManualButtons() {
        let mode = isDarkMode()
        lightButton.isEnabled = mode
        darkButton.isEnabled = !mode
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

