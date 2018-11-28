//
//  StartUp.swift
//  DarkModeSwitcher
//
//  Created by Tyler on 2018/11/27.
//  Copyright © 2018 Tyler Liu. All rights reserved.
//  Based on https://gist.github.com/plapier/f8e1dde1b1624dfbb3e4
//

import Foundation

func applicationIsInStartUpItems() -> Bool {
    return (itemReferencesInLoginItems().existingReference != nil)
}

func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
    if let appURL : NSURL = NSURL.fileURL(withPath: Bundle.main.bundlePath) as NSURL {
        if let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList? {
            
            let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
            let lastItemRef: LSSharedFileListItem = loginItems.lastObject as! LSSharedFileListItem
            
            for (index, loginItem) in loginItems.enumerated() {
                let currentItemRef: LSSharedFileListItem = loginItems.object(at: index) as! LSSharedFileListItem
                if let itemURL = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
                    if (itemURL.takeRetainedValue() as NSURL).isEqual(appURL) {
                        return (currentItemRef, lastItemRef)
                    }
                }
            }
            
            return (nil, lastItemRef)
        }
    }
    
    return (nil, nil)
}

func toggleLaunchAtStartup(state : Bool) {
    let itemReferences = itemReferencesInLoginItems()
    if applicationIsInStartUpItems() == state {
        return;
        
    }
    if let loginItemsRef = LSSharedFileListCreate( nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList? {
        if state {
            if let appUrl : CFURL = NSURL.fileURL(withPath: Bundle.main.bundlePath) as CFURL {
                print("Adding login item")
                LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
            }
        } else {
            if let itemRef = itemReferences.existingReference {
                print("Removing login item")
                LSSharedFileListItemRemove(loginItemsRef,itemRef);
            }
        }
    }
}
