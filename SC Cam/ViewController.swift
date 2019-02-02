//
//  ViewController.swift
//  SC Cam
//
//  Created by Jerry Volcy on 1/29/19.
//  Copyright © 2019 Jerry Volcy. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    
    @IBOutlet var camView: NSView!
    @IBOutlet weak var imgView: NSImageView!
    
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerGp = self
        

        if let appDeg = appDelegateGp {
            //connect the global menu pointer to the app's menu
            appMenuGp = appDeg.appMenu
            
        }

    }
        
    


    func captureDeviceDeviceMenuEnableOption(deviceNumber: Int, enable: Bool, deviceName: String?){
        let mnuItemDevice = appMenuGp?.item(withTitle: "Capture Device")
        let y = mnuItemDevice?.submenu?.item(at: deviceNumber)
        y?.title = deviceName ?? "?"
        y?.isHidden = !enable
        
        //add/remove a check mark by the selected item
        if enable {
            y?.state = .on
        }
        else {
            y?.state = .off
        }
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func btnStartAction(_ sender: Any) {

        let imgName = "file:///Users/jvolcy/Desktop/1280x720.png"
        
        let url = URL(string: imgName)

        imgView.image = NSImage(byReferencing: url!)

        //=======================================================================================
        
        camView.layer = CALayer()
        camView.layer?.frame = CGRect(x:880, y:0, width:400, height:720)
        //camView.layer?.frame = self.view.frame
        
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSession.Preset.low
        
        // Get all audio and video devices on this machine
        let devices = AVCaptureDevice.devices()
        
        // Find the FaceTime HD camera object
        for device in devices {
            print(device)
            
            // Camera object found and assign it to captureDevice
            if device.hasMediaType(AVMediaType.video) {
                print(device)
                captureDevice = device //as AVCaptureDevice
                
                //let x = devices.firstIndex(of: device)
                
                captureDeviceDeviceMenuEnableOption(deviceNumber: devices.firstIndex( of: device)!, enable: true, deviceName: captureDevice?.localizedName)

            }
        }
        
        
        if captureDevice != nil {
            
            do {
                
                try captureSession.addInput(AVCaptureDeviceInput(device: (captureDevice ?? nil)!))
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                //previewLayer?.frame = (self.camView.layer?.frame)!
                previewLayer?.frame = CGRect(x:0, y:0, width:400, height:720)
                
                previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                //previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
                
                //camView.layer?.contentsGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
                
                
                // Add previewLayer into custom view
                self.camView.layer?.addSublayer(previewLayer!)
                
                
                // Start camera
                captureSession.startRunning()
                
            } catch {
                print(AVCaptureSessionErrorKey.description)
            }
        }

    }
    
    
    func menuBackgroundSelect(_ sender: Any) {
        if let menuItem = sender as? NSMenuItem{
            print(menuItem.title)
        }
    }

}


