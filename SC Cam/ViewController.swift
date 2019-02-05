//
//  ViewController.swift
//  SC Cam
//
//  Created by Jerry Volcy on 1/29/19.
//  Copyright © 2019 Jerry Volcy. All rights reserved.
//

import Cocoa
import AVFoundation

/* ============================================================================
 class ViewController
============================================================================ */
class ViewController: NSViewController {
    
    //---------- IOBOutlets ----------
    @IBOutlet var camView: NSView!
    @IBOutlet weak var imgView: NSImageView!
    
    //---------- class members ----------
    let captureSession = AVCaptureSession()
    var cameras : [AVCaptureDevice] = []
    
    
    /* ============================================================================
     func viewDidLoad()
     ============================================================================ */
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerGp = self

        //----------  ----------
        camView.layer = CALayer()
        camView.layer?.frame = CGRect(x:880, y:0, width:400, height:720)
        //camView.layer?.frame = self.view.frame
        //camView.layer?.contentsGravity = AVLayerVideoGravity.resizeAspectFill.rawValue

        captureSession.sessionPreset = AVCaptureSession.Preset.low
        
        //---------- Get all audio and video devices on this machine ----------
        let devices = AVCaptureDevice.devices()
        
        //---------- go through the list of available capture devices ----------
        for device in devices {
            print(device)
            
            //---------- if the capture device is a video device, add it to the cameras list ----------
            if device.hasMediaType(AVMediaType.video) {
                cameras.append(device)
            }
            
            //---------- add the name of each camera to the "Capture Devices" menu ----------
            for i in 0..<cameras.count {
                captureDeviceMenuEnableOption(deviceNumber: i, enable: true, deviceName: cameras[i].localizedName)
            }
        }
    }
        
    /* ============================================================================
     function to add a check mark before the supplied menu item.
     ============================================================================ */
    func checkMenuItem(menuItem : NSMenuItem) {
        //add a check mark by the selected item
        menuItem.state = .on
    }
    
    /* ============================================================================
     function to remove the check mark before the supplied menu item.
     ============================================================================ */
    func uncheckMenuItem(menuItem : NSMenuItem) {
        //remove a check mark by the selected item
        menuItem.state = .off
    }

    /* ============================================================================
     function to uncheck all devices on the capture device menu list
     ============================================================================ */
    func unCheckAllCaptureMenuDevices() {
        //remove a check mark by all items in the "Capture Device" menu
        //start by getting a reference to the capture device sub-menu
        if let devMenu = appDelegateGp?.appMenu.item(withTitle: "Capture Device")?.submenu?.items {
            
            //now go through an uncheck every entry in the capture device submenu
            for menuItem in devMenu {
                uncheckMenuItem(menuItem: menuItem)
                print("unchecking ", menuItem.title)
            }
        }
    }


    /* ============================================================================
     function to enable and title one of the 8 capture device sub-entries in the
     "Capture Device" menu.
     ============================================================================ */
    func captureDeviceMenuEnableOption(deviceNumber: Int, enable: Bool, deviceName: String?){
        let mnuItemDevice = appDelegateGp?.appMenu.item(withTitle: "Capture Device")
        let y = mnuItemDevice?.submenu?.item(at: deviceNumber)
        y?.title = deviceName ?? "?"
        y?.isHidden = !enable
    }
    
    /* ============================================================================
     ============================================================================ */
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    /* ============================================================================
     experimental code test button (hidden on UI in final release)
     ============================================================================ */
    @IBAction func btnStartAction(_ sender: Any) {

    }
    
    /* ============================================================================
     function to begin a video capture session on the supplied capture device.
     This should be one of the devices in the cameras list.
     ============================================================================ */
    func startCaptureSession(captureDevice: AVCaptureDevice?) {
        
        //print("capture device = ", captureDevice?.localizedName)
        
        //---------- halt any active session ----------
        if captureSession.isRunning {
            captureSession.stopRunning()
        }

        //---------- remove all capture inputs ----------
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }

        if captureDevice != nil {
            do {
                //---------- attempt to add the capture device ----------
                try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
 
                //---------- configure a preview layer ----------
                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.frame = CGRect(x:0, y:0, width:400, height:720)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                //previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                
                //---------- Add previewLayer into custom view ----------
                self.camView.layer?.addSublayer(previewLayer)

                //---------- Start camera ----------
                captureSession.startRunning()
                
            } catch {
                print(AVCaptureSessionErrorKey.description)
            }
        }

    }

    /* ============================================================================
     function called by the AppDelegate for menu selections other than
     capture device selection
     ============================================================================ */
    func menuSelect(_ sender: Any) {

        //---------- Get the selected menu option ----------
        let menuItem = sender as? NSMenuItem
        let title = menuItem?.title ?? ""
        
        //---------- process the menu selection ----------
        switch (title) {
        case "Select Background Image":
            /* ---------- open a file dialog box to let the user select
             and image file: jpg, png, pdf, etc... ---------- */
            let myFileDialog = NSOpenPanel()
            myFileDialog.runModal()
            
            //---------- if a file was selected, use it as the background ----------
            if let url = myFileDialog.url {
                imgView.image = NSImage(byReferencing: url)
            }   //if

        default:
            print("Unknown menu selection: ", title)
        }   //switch
        
    }   //func menuSelect

    /* ============================================================================
     function called by the AppDelegate for capture device menu selections
     ============================================================================ */
    func menuDeviceSelect(_ sender: Any) {
        if let selectedDeviceMenuItem = sender as? NSMenuItem{
            print("Selected Device:", selectedDeviceMenuItem.title)
            
            //---------- search the camera names to find the selected camera ----------
            for i in 0..<cameras.count {
                if cameras[i].localizedName == selectedDeviceMenuItem.title {
                    //---------- uncheck all cameras in the device menu ----------
                    unCheckAllCaptureMenuDevices()
                    //---------- check the selected camera in the device menu ----------
                    checkMenuItem(menuItem: selectedDeviceMenuItem)
                    //---------- start the selected camera and break ----------
                    startCaptureSession(captureDevice: cameras[i])
                    break;
                }   //if
            }   //for
            
        }   //if let
    }   //func

}   //class





/* ============================================================================
 Scratch
 ============================================================================ */
//----------  ----------
//----------  ----------
//----------  ----------

/* ============================================================================
 ============================================================================ */
