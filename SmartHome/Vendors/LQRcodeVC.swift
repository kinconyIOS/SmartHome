//
//  LQRcodeVC.swift
//  QRcode
//
//  Created by kincony on 15/12/24.
//  Copyright © 2015年 Kincony. All rights reserved.
//

import UIKit
import AVFoundation


class LQRcodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var boxView = UIView()
    private let scanLayer = CALayer()
    private var compeletBlock: ((resultString: String) -> ())?
    private var timer: NSTimer?
    
    func setCompeletBlock(compeletBlock: (resultString: String) -> ()) {
        self.compeletBlock = compeletBlock
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            print(error)
            return
        }
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0))
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = self.view.layer.bounds
        self.view.layer.addSublayer(videoPreviewLayer!)
        captureMetadataOutput.rectOfInterest = CGRectMake(0.2, 0.3, 0.8, 0.7)
        
        boxView.frame = CGRectMake(self.view.bounds.width * 0.2, self.view.bounds.height * 0.3, self.view.bounds.width * 0.6, self.view.bounds.height * 0.4)
        boxView.layer.borderColor = UIColor.redColor().CGColor
        boxView.layer.borderWidth = 1
        self.view.addSubview(boxView)
        
        scanLayer.frame = CGRectMake(0, 0, boxView.frame.width, 1)
        scanLayer.backgroundColor = UIColor.blueColor().CGColor
        boxView.layer.addSublayer(scanLayer)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("moveScanLayer:"), userInfo: nil, repeats: true)
        timer!.fire()
        captureSession?.startRunning()
        
        let cancleBtn = UIButton(type: UIButtonType.Custom)
        cancleBtn.frame = CGRectMake(0, 0, 70, 25)
        cancleBtn.center = CGPointMake(self.view.bounds.width / 2, self.view.bounds.height - 20)
        cancleBtn.setTitle("Cancle", forState: UIControlState.Normal)
        cancleBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancleBtn.addTarget(self, action: Selector("handleCancle:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(cancleBtn)
        
    }

    func handleCancle(sender: UIButton) {
        self.stopScanning()
    }
    
    func stopScanning() {
        timer?.invalidate()
        self.dismissViewControllerAnimated(true, completion: nil)
        captureSession?.stopRunning()
        captureSession = nil
    }
    
    func moveScanLayer(timer: NSTimer) {
        print("dddd")
        var frame = scanLayer.frame
        if boxView.frame.height < scanLayer.frame.origin.y {
            frame.origin.y = 0
            UIView.animateWithDuration(0.1) { [unowned self] () -> Void in
                self.scanLayer.frame = frame
            }
        } else {
            frame.origin.y += 5
            UIView.animateWithDuration(0.1) { [unowned self] () -> Void in
                self.scanLayer.frame = frame
            }
        }
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject
            if metadata?.type == AVMetadataObjectTypeQRCode {
                self.compeletBlock?(resultString: (metadata?.stringValue)!)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
