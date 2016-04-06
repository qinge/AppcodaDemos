//
//  ViewController.swift
//  QrcodeImageGenerate
//
//  Created by snqu-ios on 16/4/5.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//
//  http://adad184.com/2015/09/30/goodbye-zxing/


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var imgQRCode: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    var qrcodeImage: CIImage!
    var topImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topImage = UIImage(named: "6824500_006_thumb.jpg")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func performButtonAction(sender: AnyObject){
        if qrcodeImage == nil {
            if textField.text == "" {
                return
            }
            let data = textField.text?.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")!
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            qrcodeImage = filter.outputImage
            //            imgQRCode.image = UIImage(CIImage: qrcodeImage)
            self.displayQRCodeImage()
            textField.resignFirstResponder()
            btnAction.setTitle("Clear", forState: .Normal)
        }else{
            imgQRCode.image = nil
            qrcodeImage = nil
            btnAction.setTitle("Generate", forState: .Normal)
        }
        slider.hidden = !slider.hidden
    }
    // 此方法生成的二维码比较清晰
    func displayQRCodeImage(){
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        var qImage = UIImage(CIImage: transformedImage)
        // 添加 top image
        if topImage != nil {
//            UIGraphicsBeginImageContext(qImage.size)
            let scale = UIScreen.mainScreen().scale
            UIGraphicsBeginImageContextWithOptions(qImage.size, true, scale)
            
            qImage.drawInRect(CGRectMake(0, 0, qImage.size.width, qImage.size.height))
            
            let topImageWidth = qImage.size.width * (1/5)
            topImage.drawInRect(CGRectMake(qImage.size.width / 2 - topImageWidth / 2 , qImage.size.height / 2 - topImageWidth / 2, topImageWidth, topImageWidth))
            
            qImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
        }
        imgQRCode.image = qImage
    }
    // 改变二维码的大小
    @IBAction func changeImageViewScale(sender: AnyObject){
        imgQRCode.transform = CGAffineTransformMakeScale(CGFloat(slider.value), CGFloat(slider.value))
    }

    

}

