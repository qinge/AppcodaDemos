//
//  ReadViewController.swift
//  QrcodeImageGenerate
//
//  Created by snqu-ios on 16/4/6.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var qrLabel: UILabel!
    var imagePickController: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func pickImageAction(sender: AnyObject) {
        imagePickController = UIImagePickerController()
        imagePickController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickController.delegate = self
        self.presentViewController(imagePickController, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePickController.dismissViewControllerAnimated(true, completion: nil)
        
        if let message = self.startReadDataFromQrcode(self.imageView.image!) {
            self.qrLabel.text = message
        }else {
            self.qrLabel.text = "换个图片试试"
        }
    }
    
    
    func startReadDataFromQrcode(image: UIImage) -> String? {
        let context = CIContext(options: nil)
        // 测试发现 9.2 的模拟器才能实例化 detector
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let ciimage = CIImage(image: image)
        let features = detector.featuresInImage(ciimage!)
        let ciqrCodeFeature = features.first as? CIQRCodeFeature

        return ciqrCodeFeature?.messageString
    }
}
