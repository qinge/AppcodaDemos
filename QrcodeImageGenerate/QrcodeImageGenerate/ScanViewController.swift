//
//  ScanViewController.swift
//  QrcodeImageGenerate
//
//  Created by snqu-ios on 16/4/6.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate{
    
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var session: AVCaptureSession?
    var preview: AVCaptureVideoPreviewLayer?
    var scanRect: CGRect!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanRect = CGRect(origin: self.view.center, size: CGSizeMake(200, 200))

        self.device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        self.input = try! AVCaptureDeviceInput(device: self.device)
        self.output = AVCaptureMetadataOutput()
        self.output?.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        self.session = AVCaptureSession()
        self.session?.sessionPreset = UIScreen.mainScreen().bounds.size.height < 500 ? AVCaptureSessionPreset640x480 : AVCaptureSessionPresetHigh
        self.session?.addInput(self.input)
        self.session?.addOutput(self.output)
        
        self.output?.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        // 限定抓取区域 值的范围都是0-1 是按比例取值而不是实际尺寸
        //计算rectOfInterest 注意x,y交换位置
        // 这里唯一要注意的一点是 rectOfInterest 都是按照横屏来计算的 所以当竖屏的情况下 x轴和y轴要交换一下
        let windowSize = UIScreen.mainScreen().bounds.size
        
        let scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
        scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
        scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
        
        self.output?.rectOfInterest = scanRect!
        
        
        // 添加红框 扫描边界
        let scanRectView = UIView()
        self.view.addSubview(scanRectView)
        scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height)
        scanRectView.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
        scanRectView.layer.borderColor = UIColor.redColor().CGColor
        scanRectView.layer.borderWidth = 1
        
        self.preview = AVCaptureVideoPreviewLayer(session: self.session)
        self.preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.preview?.frame = UIScreen.mainScreen().bounds
        self.view.layer.insertSublayer(self.preview!, atIndex: 0)
        
        // 开始捕获
        self.session?.startRunning()
        
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
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        guard metadataObjects.count > 0 else {
            return
        }
        
        self.session?.stopRunning()
        let metaDataObject = metadataObjects.first
        
        let alertView = UIAlertView(title: metaDataObject?.stringValue, message: nil, delegate: self, cancelButtonTitle: "cancel")
        alertView.show()
    }
    
    // MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        self.session?.startRunning()
    }

}
