//
//  ViewController.swift
//  MemeApp
//
//  Created by Артем Князев on 15.06.2020.
//  Copyright © 2020 Артем Князев. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // screen launch
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        shareOutlet?.isHidden = true
        cancelButton.isHidden = true

           
        
        // default attributes
        TextTop.defaultTextAttributes = textfield
        textBottom.defaultTextAttributes = textfield
        // text parameter
        textParameter(textField: TextTop)
        textParameter(textField: textBottom)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    // variables
    let textfield: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.blue,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedString.Key.strokeWidth: 3.0
            
            ]
    struct Meme {
              let memedImage: UIImage
              let topText: String
              let textBottom: String
              let originalImage: UIImage
          }
    let imagePicker = UIImagePickerController()
    // functions
    
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let image = info[.originalImage] as? UIImage {
               
               imageView.image = image
               
           }
           imageSelected()
        picker.dismiss(animated: true, completion: nil)
           }
       func textParameter(textField: UITextField) {
           textField.textAlignment = .center
           textField.placeholder = "Type here"
           textField.isHidden = true
           
           }
      
       
    
       func generateMemedImage() -> UIImage {

           // TODO: Hide toolbar and navbar
           toolBar.isHidden = true
           navBar.isHidden = true
           // Render view to an image
           UIGraphicsBeginImageContext(self.view.frame.size)
           view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
           let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
           UIGraphicsEndImageContext()

           toolBar.isHidden = false
           navBar.isHidden = false

           return memedImage
       }
       func save() {
       // Create the meme
           let meme = Meme(memedImage: generateMemedImage(), topText: TextTop.text!, textBottom: textBottom.text!, originalImage: imageView.image!)
        }
       func screenClean() -> Bool {
           imageView.image = nil
           cancelButton.isHidden = true
           shareOutlet.isHidden = true
           TextTop.text = String()
           TextTop.isHidden = true
           textBottom.isHidden = true
           textBottom.text = String()
           return true
       }
    func imageSelected() {
        TextTop.isHidden = false
        textBottom.isHidden = false
        shareOutlet.isHidden = false
        cancelButton.isHidden = false
    }
    // outlet
    
    @IBOutlet weak var TextTop: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shareOutlet: UIButton!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    // actions
    
    @IBAction func share(_ sender: Any) {
        let imageNew = generateMemedImage()
        let container = UIActivityViewController(activityItems: [imageNew], applicationActivities: nil
        )
        self.present(container, animated: true, completion: nil)
    }
    
    @IBAction func textTop(_ sender: UITextField) {
         sender.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        screenClean()
        
        
    }
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        // controller
      
        let controller = UIAlertController()
        // camera error handling
        let noCamera = UIAlertController(title: nil, message: "Camera not available in your device", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {action in self.dismiss(animated: true, completion: nil)}
        noCamera.addAction(okAction)
        // actions creation
        // camera & media
        
        let mediaAction = UIAlertAction(title: "Using Media Files", style: .default) {action in
            
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        let cameraAction = UIAlertAction(title: "Use camera", style: .default) {action in
            if UIImagePickerController .isSourceTypeAvailable(.camera) == true {
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil) }
            else {self.present(noCamera, animated: true, completion: nil) }
        }
        // cancel
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) {action in self.dismiss(animated: true, completion: nil)}
        
        
        // add action
        
        controller.addAction(cameraAction)
        controller.addAction(mediaAction)
        controller.addAction(cancel)
        // transition
        self.present(controller, animated: true, completion: nil)
    }
    
    
        

}
