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
 ============================================================================ */
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    //----------  ----------
    @IBOutlet weak var appMenu: NSMenu!
    
    override init() {
        super.init()
        //connect the global app delegate pointer to the app delegate
        appDelegateGp = self
        
    }
    
    /* ============================================================================
     ============================================================================ */
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        //viewControllerGp = view
    }

    /* ============================================================================
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
     ============================================================================ */
    @IBAction func menuSelect(_ sender: Any) {
            if let gp = viewControllerGp {
                gp.menuBackgroundSelect(sender)
            }
        
    }
    
    /* ============================================================================
     ============================================================================ */
    @IBAction func menuDeviceSelect(_ sender: Any) {
        if let gp = viewControllerGp {
            gp.menuDeviceSelect(sender)
        }
        
    }

    
}

