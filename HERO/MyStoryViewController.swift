//
//  MyStoryViewController.swift
//  HERO
//
//  Created by Amrun on 13/10/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class MyStoryViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var newTweetTextView: UITextView!
    @IBOutlet weak var newTweetToolbar: UIToolbar!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarBottomConstraintInitialValue:CGFloat?
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

         self.title = "My Story"
        
        self.newTweetToolbar.isHidden = false
        
        newTweetTextView.textContainerInset = UIEdgeInsetsMake(30, 20, 20, 20)
        newTweetTextView.text = "Enter your story here..."
        newTweetTextView.textColor = UIColor.lightGray

        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }

    override func viewDidAppear(_ animated: Bool) {
        enableKeyboardHideOnTap()
        
        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint.constant
    }
    
    fileprivate func enableKeyboardHideOnTap(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        
        self.view.addGestureRecognizer(tap)
        
    }
    
    func keyboardWillShow(_ notification: Notification)
    {
        let info = (notification as NSNotification).userInfo!
        
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let duration = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration, animations: {
            
            self.toolbarBottomConstraint.constant = keyboardFrame.size.height
            
            self.newTweetToolbar.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(_ notification: Notification)
    {
        let duration = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration, animations: {
            
            self.toolbarBottomConstraint.constant = self.toolbarBottomConstraintInitialValue!
            
            self.newTweetToolbar.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    func hideKeyboard(){
        self.view.endEditing(true)
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(newTweetTextView.textColor == UIColor.lightGray)
        {
            newTweetTextView.text = ""
            newTweetTextView.textColor = UIColor.black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func didTapPost(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "unwindToMenu", sender: self)
        }
        
        var imagesArray = [AnyObject]()
        
        //extract the images from the attributed text
        self.newTweetTextView.attributedText.enumerateAttribute(NSAttachmentAttributeName, in: NSMakeRange(0, self.newTweetTextView.text.characters.count), options: []) { (value, range, true) in
            
            if(value is NSTextAttachment)
            {
                let attachment = value as! NSTextAttachment
                var image : UIImage? = nil
                
                if(attachment.image !== nil)
                {
                    image = attachment.image!
                    imagesArray.append(image!)
                }
                else
                {
                    print("No image found")
                }
            }
        }
        
        let tweetLength = newTweetTextView.text.characters.count
        let numImages = imagesArray.count
        
        //create a unique auto generated key from firebase database
        let key = FIRDatabase.database().reference().child("posts").childByAutoId().key
        
        let storageRef = FIRStorage.storage().reference()
        let pictureStorageRef = storageRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)/media/\(key)")
        
        //reduce resolution of selected picture
        
        //user has entered text and an image
        if(tweetLength>0 && numImages>0)
        {
            let lowResImageData = UIImageJPEGRepresentation(imagesArray[0] as! UIImage, 0.50)
            
            let uploadTask = pictureStorageRef.put(lowResImageData!,metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    let childUpdates = ["/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)/text":self.newTweetTextView.text,
                                        "/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)/timestamp":"\(Date().timeIntervalSince1970)",
                        "/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)/picture":downloadUrl!.absoluteString] as [String : Any]
                    
                    FIRDatabase.database().reference().updateChildValues(childUpdates)
                }
                
            }
            
            //dismiss(animated: true, completion: nil)
        }
            //user has entered only text
        else if(tweetLength>0)
        {
            let childUpdates = ["/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)/text":newTweetTextView.text,
                                "/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)/timestamp":"\(Date().timeIntervalSince1970)"] as [String : Any]
            
            FIRDatabase.database().reference().updateChildValues(childUpdates)
            
           // dismiss(animated: true, completion: nil)
            
        }
            //user has entered only an image
        else if(numImages>0)
        {
            let lowResImageData = UIImageJPEGRepresentation(imagesArray[0] as! UIImage, 0.50)
            
            let uploadTask = pictureStorageRef.put(lowResImageData!,metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    let childUpdates = [
                        "/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)/timestamp":"\(Date().timeIntervalSince1970)",
                        "/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)/picture":downloadUrl!.absoluteString]
                    
                    FIRDatabase.database().reference().updateChildValues(childUpdates)
                }
                else
                {
                    print(error?.localizedDescription)
                }
                
            }
            
           // dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func selectImageFromPhotos(_ sender: AnyObject) {
        
        //open the photo gallery
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
    }
    
    //after user has picked an image from photo gallery, this function will be called
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        var attributedString = NSMutableAttributedString()
        
        if(self.newTweetTextView.text.characters.count>0)
        {
            attributedString = NSMutableAttributedString(string:self.newTweetTextView.text)
        }
        else
        {
            attributedString = NSMutableAttributedString(string:"Enter your story here...")
        }
        
        let textAttachment = NSTextAttachment()
        
        textAttachment.image = image
        
        let oldWidth:CGFloat = textAttachment.image!.size.width
        
        let scaleFactor:CGFloat = oldWidth/(newTweetTextView.frame.size.width-50)
        
        textAttachment.image = UIImage(cgImage: textAttachment.image!.cgImage!, scale: scaleFactor, orientation: .up)
        
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        
        attributedString.append(attrStringWithImage)
        
        newTweetTextView.attributedText = attributedString
        self.dismiss(animated: true, completion: nil)
        
    }

}
