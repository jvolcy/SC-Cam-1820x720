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
============================================================================ */
class ViewController: NSViewController {
    
    //----------  ----------
    @IBOutlet var camView: NSView!
    @IBOutlet weak var imgView: NSImageView!
    
    //----------  ----------
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    var cameras : [AVCaptureDevice] = []
    
    
    /* ============================================================================
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
        
        // Get all audio and video devices on this machine
        let devices = AVCaptureDevice.devices()
        
        // Find the FaceTime HD camera object
        for device in devices {
            print(device)
            
            // Camera object found: add it to the cameras list
            if device.hasMediaType(AVMediaType.video) {
                cameras.append(device)
            }
                
            for i in 0..<cameras.count {
                captureDeviceMenuEnableOption(deviceNumber: i, enable: true, deviceName: cameras[i].localizedName)
            }

        }
 

    }
        
    /* ============================================================================
     ============================================================================ */
    func checkMenuItem(menuItem : NSMenuItem) {
        //add a check mark by the selected item
        menuItem.state = .on
    }
    
    /* ============================================================================
     ============================================================================ */
    func uncheckMenuItem(menuItem : NSMenuItem) {
        //remove a check mark by the selected item
        menuItem.state = .off
    }

    /* ============================================================================
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
     ============================================================================ */
    @IBAction func btnStartAction(_ sender: Any) {

        let imgName = "file:///Users/jvolcy/Desktop/880x720.png"
        
        let url = URL(string: imgName)

        imgView.image = NSImage(byReferencing: url!)

    }
    
    /* ============================================================================
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
                
                try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
 
                previewLayer?.frame = CGRect(x:0, y:0, width:400, height:720)
                
                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                //previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                
                
                // Add previewLayer into custom view
                self.camView.layer?.addSublayer(previewLayer!)

                // Start camera
                captureSession.startRunning()
                
            } catch {
                print(AVCaptureSessionErrorKey.description)
            }
        }

    }

    /* ============================================================================
     ============================================================================ */
    func menuBackgroundSelect(_ sender: Any) {
        /*
        if let menuItem = sender as? NSMenuItem{
            print(menuItem.title)
        }
 */

        let myFileDialog = NSOpenPanel()
        myFileDialog.runModal()
        
        if let url = myFileDialog.url {
            imgView.image = NSImage(byReferencing: url)
        }
    }

    /* ============================================================================
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
