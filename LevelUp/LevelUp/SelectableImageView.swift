//
//  SelectableImageView.swift
//  LevelUp
//
//  Created by Joshua Escribano on 12/4/16.
//  Copyright © 2016 jasonify. All rights reserved.
//

import UIKit

class SelectableImageView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var delegate: UIViewController?
    var image: UIImage? {
        didSet {
            labelView.isHidden = true
            imageView.image = image
            imageView.layer.cornerRadius = 5.0
            imageView.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "SelectableImageView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(recognizer)
        
        addSubview(contentView)
    }
    
    func onTap(recognizer: UITapGestureRecognizer) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsEditing = true
        imagePickerVC.sourceType = .photoLibrary
        
        delegate?.present(imagePickerVC, animated: true, completion: nil)
    }
}

extension SelectableImageView: UINavigationControllerDelegate {
}

extension SelectableImageView: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageView.image = info[UIImagePickerControllerEditedImage] as! UIImage
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        image = thumbnail
        delegate?.dismiss(animated: true, completion: nil)
    }
    
}
