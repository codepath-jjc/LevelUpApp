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

    @IBOutlet weak var frequencySegmentControl: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var selectImageView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createQuestButton: UIButton!
    @IBOutlet weak var icon: UIImageView!
    
    var navigationDelegate: TabBarViewController?
    var hasPlaceholder = true
    var disabledButtonColor = UIColor(red:0.17, green:0.40, blue:0.23, alpha:1.0)
    var enabledButtonColor = UIColor(red:0.38, green:0.90, blue:0.52, alpha:1.0)
    var frequency = Frequency.daily
    let imgPicker = UIImagePickerController()
    
    var chosenImage: UIImage? {
        didSet{
            icon.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.setNeedsLayout()
        titleTextField.layoutIfNeeded()
        
        descriptionTextView.setNeedsLayout()
        descriptionTextView.layoutIfNeeded()
        
        icon.isHidden = true
        let dashColor = UIColor(red:0.60, green:0.61, blue:0.61, alpha:1.0)
        titleTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSForegroundColorAttributeName: dashColor])
        titleTextField.delegate = self
        
        descriptionTextView.delegate = self
        
        createQuestButton.layer.borderWidth = 1.0
        createQuestButton.layer.cornerRadius = 5.0
        createQuestButton.layer.borderColor = disabledButtonColor.cgColor
        
        selectImageView.addDashedBorder(color: dashColor)
      
        descriptionTextView.addDashedBorder(color: dashColor)
        titleTextField.addDashedBorder(color: dashColor)

        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imgPicker.allowsEditing = false

        frequencySegmentControl.addTarget(self, action: #selector(frequencyChanged), for: .valueChanged)
    }
    
    func frequencyChanged() {
        if frequencySegmentControl.selectedSegmentIndex == 0 {
            frequency = .daily
        } else {
            frequency = .weekly
        }
    }
    
    @IBAction func onImagePickerPress(_ sender: UITapGestureRecognizer) {
        present(imgPicker, animated: false, completion: nil)
    }
    
    @IBAction func onCancelPress(_ sender: Any) {
        if let navigationDelegate = navigationDelegate {
            navigationDelegate.page = Page.profile
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var dictionary = ["frequency": frequency.rawValue, "title": titleTextField.text ?? "", "notes": descriptionTextView.text] as [String: Any]
        if let chosenImage = chosenImage {
            dictionary["image"] = chosenImage
        }
        var newQuest = Quest(dictionary: dictionary)
        LevelUpClient.sharedInstance.sync(quest: &newQuest, success: {
            // TODO
        }, failure: {
            (error: Error?) -> () in
            // TODO
            print(error?.localizedDescription ?? "New Quest Error")
        })
    }

}


extension NewQuestViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        icon.image = chosenImage
        self.dismiss(animated: true, completion: nil)
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
