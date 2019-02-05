//
//  AppDelegate.swift
//  SC Cam
//
//  Created by Jerry Volcy on 1/29/19.
//  Copyright © 2019 Jerry Volcy. All rights reserved.
//

import Cocoa

//---------- Globals ----------
//global pointer to the view controller
var viewControllerGp: ViewController?

//global pointer to app delegate
var appDelegateGp: AppDelegate?


/* ============================================================================
 class AppDelegate
 ============================================================================ */
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var appMenu: NSMenu!
    
    override init() {
        super.init()
        
        //---------- connect the global app delegate pointer to the app delegate ----------
        appDelegateGp = self
    }
    
    /* ============================================================================
     func applicationDidFinishLaunching()
     ============================================================================ */
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    /* ============================================================================
     func applicationWillTerminate()
     ============================================================================ */
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    /* ============================================================================
     function to quit when the user clicks the close button.
     Returning true causes the app to quit when the user clicks the close button.
     ============================================================================ */
    func applicationShouldTerminateAfterLastWindowClosed(_ app: NSApplication) -> Bool {
        return true
    }

    /* ============================================================================
     callback for all menu selections other than "capture device" menu items
     ============================================================================ */
    @IBAction func menuSelect(_ sender: Any) {
            if let gp = viewControllerGp {
                gp.menuSelect(sender)
            }
    }
    
    /* ============================================================================
     callback for "capture device" menu selections
     ============================================================================ */
    @IBAction func menuDeviceSelect(_ sender: Any) {
        if let gp = viewControllerGp {
            gp.menuDeviceSelect(sender)
        }
        
    }

    
}

