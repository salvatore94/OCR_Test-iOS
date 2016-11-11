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
    
    var tesseract : G8Tesseract = G8Tesseract(language:"ita")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        tesseract.delegate = self
        tesseract.charWhitelist = "01234567890";
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
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.image = pickedImage
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ocrFunc(_ sender: Any) {
        if imageView.image != nil {
            tesseract.charWhitelist = "01234567890";
            tesseract.image = imageView.image! as UIImage
            tesseract.image.g8_blackAndWhite()
            
            tesseract.recognize();
    
            NSLog("%@", tesseract.recognizedText);
            
            let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let ocrView : UIViewController = myStoryboard.instantiateViewController(withIdentifier: "ocrView") as UIViewController
            var textV = ocrView.view.viewWithTag(3) as! UITextView
            
            textV.text = tesseract.recognizedText
            self.present(ocrView, animated: true, completion: nil)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
    
}

