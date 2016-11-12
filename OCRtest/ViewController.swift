//
//  ViewController.swift
//  OCRtest
//
//  Created by Salvatore  Polito on 10/11/16.
//  Copyright © 2016 Salvatore  Polito. All rights reserved.
//

import UIKit
import TesseractOCR

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    var imm = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func catturaFoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
            
        }
    }

    @IBAction func apriGalleria(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imm = pickedImage as UIImage
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.image = pickedImage
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ocrFunc(_ sender: Any) {
        if self.imageView.image != nil {
            let imageScaled = scaleImage(image: imm, maxDimension: 640)
            let recognized = imageRecognition(image: imageScaled)
            preparaOCRView(recognizedText: recognized)
        }
        
    }
    

    func imageRecognition (image: UIImage) -> String {
        let tesseract1 = G8Tesseract(language: "ita")
        tesseract1?.delegate = self
        tesseract1?.engineMode = G8OCREngineMode.cubeOnly
        tesseract1?.pageSegmentationMode = G8PageSegmentationMode.auto
        tesseract1?.image = image as UIImage
        tesseract1?.image.g8_blackAndWhite()
        tesseract1?.charBlacklist = "0123456789-"
        
        tesseract1?.recognize()
        return (tesseract1?.recognizedText)!
    }
    
    func preparaOCRView (recognizedText: String) {
        let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ocrView : UIViewController = myStoryboard.instantiateViewController(withIdentifier: "ocrView") as UIViewController
        let textV = ocrView.view.viewWithTag(3) as! UITextView
        
        textV.text = recognizedText
        self.present(ocrView, animated: true, completion: nil)
    }
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func progressImageRecognition(for tesseract1: G8Tesseract!) {
        print("Recognition Progress \(tesseract1.progress) %")
    }
    
    func shouldCancelImageRecognitionForTesseract(for tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

