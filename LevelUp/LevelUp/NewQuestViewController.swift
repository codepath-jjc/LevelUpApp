//
//  NewQuestViewController.swift
//  LevelUp
//
//  Created by Joshua Escribano on 11/11/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit
import Parse

class NewQuestViewController: UIViewController  {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var selectImageView: UIView!
    @IBOutlet weak var frequencyView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createQuestButton: UIButton!
    var navigationDelegate: TabBarViewController?
    var hasPlaceholder = true
    var disabledButtonColor = UIColor(red:0.17, green:0.40, blue:0.23, alpha:1.0)
    var enabledButtonColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0)
    let imgPicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dashColor = UIColor(red:0.60, green:0.61, blue:0.61, alpha:1.0)
        titleTextField.attributedPlaceholder = NSAttributedString(string: "Music", attributes: [NSForegroundColorAttributeName: dashColor])
        titleTextField.delegate = self
        
        descriptionTextView.delegate = self
        
        createQuestButton.layer.borderWidth = 1.0
        createQuestButton.layer.cornerRadius = 5.0
        createQuestButton.layer.borderColor = disabledButtonColor.cgColor
        
        selectImageView.addDashedBorder(color: dashColor)
        frequencyView.addDashedBorder(color: dashColor)
        descriptionTextView.addDashedBorder(color: dashColor)
        titleTextField.addDashedBorder(color: dashColor)

        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imgPicker.allowsEditing = false

    }
    
    @IBAction func onImagePickerPress(_ sender: UITapGestureRecognizer) {
        present(imgPicker, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dictionary = ["title": titleTextField.text!, "notes": descriptionTextView.text] as [String: Any]
        print("new quest", dictionary)
        print("new quest title", dictionary["title"])
        let newQuest = Quest(dictionary)
        LevelUpClient.sharedInstance.saveQuest(newQuest, success: { (Quest) in
            
        }) { (error:Error?) in
            
        }
    }

}


extension NewQuestViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        dismiss(animated: true, completion: nil)

        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//        imageViewPicked.contentMode = .scaleAspectFit //3
//        imageViewPicked.image = chosenImage //4
        
    
        let imageData = UIImagePNGRepresentation(chosenImage)
        let imageFile = PFFile(name:"image.png", data:imageData!)
        
        
        var imgData: NSData = NSData(data: UIImageJPEGRepresentation((chosenImage), 1)!)
     
        var imageSize: Int = imgData.length
        print("size of image in KB:  \(Double(imageSize) / 1024.0) ")
        
        
        
        var gameScore = PFObject(className: Quest.tableName)
        
        gameScore["title"] = "HELLO"
        gameScore["imageFile"] = imageFile
        
        gameScore["user"] = PFUser.current()
                
        imageFile?.saveInBackground({
            (succeeded: Bool, error: Error?) -> Void in
            // Handle success or failure here ...
            
            if succeeded {
                print("YESSS!")
                gameScore.saveInBackground {
                    (success: Bool, error: Error?) -> Void in
                    if (success) {
                        
                        print("HELLO WORKED")
                        // The object has been saved.
                        //self.fetchMsgs()
                    } else {
                        
                        print("HELLO failed")
                        
                        // There was a problem, check error.description
                    }
                }
                
            } else {
                print("FAILL")
            }
            }, progressBlock: {
                (percentDone: Int32) -> Void in
                // Update your progress spinner here. percentDone will be between 0 and 100.
                print(percentDone)
        })
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}


extension NewQuestViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isEmpty = textField.text?.isEmpty ?? false
        if !isEmpty {
            descriptionTextView.becomeFirstResponder()
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let empty = willBeEmpty(textField: textField, replacementString: string)
        if !empty {
            createQuestButton.isEnabled = true
            createQuestButton.layer.borderColor = enabledButtonColor.cgColor
            createQuestButton.titleLabel?.textColor = enabledButtonColor
        } else {
            createQuestButton.isEnabled = false
            createQuestButton.layer.borderColor = disabledButtonColor.cgColor
            createQuestButton.titleLabel?.textColor = disabledButtonColor
        }
        
        return true
    }
    
    private func willBeEmpty(textField: UITextField, replacementString string: String) -> Bool {
        
        if textField.text?.characters.count == 1 && string.isEmpty {
            return true
        }
        
        return false
    }
    
}

extension NewQuestViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Remove placeholder
        if hasPlaceholder {
            textView.text = ""
            hasPlaceholder = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Reinsert placeholder
        if textView.text.isEmpty && !hasPlaceholder {
            textView.text = "Goals/Description"
            hasPlaceholder = true
        }
    }
}
