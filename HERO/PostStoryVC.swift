//
//  PostStoryVC.swift
//  HERO
//
//  Created by amrun on 08/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class PostStoryVC: UIViewController,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var loggedInUserData:NSDictionary?
    
    @IBOutlet weak var newTweetTextView: UITextView!
    @IBOutlet weak var newTweetToolbar: UIToolbar!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    var toolbarBottomConstraintInitialValue:CGFloat?
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create Social Post"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont(name: "Avenir Medium", size: 20)!]
        
        self.newTweetToolbar.isHidden = false
        
        newTweetTextView.textContainerInset = UIEdgeInsetsMake(30, 20, 20, 20)
        newTweetTextView.text = "Create Social Post here..."
        newTweetTextView.textColor = UIColor.lightGray
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: {(Snapshot) in
            
            //store the logged in users details into the variable
            self.loggedInUserData = Snapshot.value as? NSDictionary
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        enableKeyboardHideOnTap()
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint.constant
        newTweetTextView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
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
            newTweetTextView.text = nil
            newTweetTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if newTweetTextView.text.isEmpty {
            newTweetTextView.text = "Create Social Post here..."
            newTweetTextView.textColor = UIColor.lightGray
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func didTapPost(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        self.newTweetTextView.resignFirstResponder()
        
        if(newTweetTextView.text == "Create Social Post here..."){
           SVProgressHUD.dismiss()
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
        
        var tweetLength = newTweetTextView.text.characters.count
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
                    
                    let childUpdates = [
                        "name":self.loggedInUserData?["displayName"] as! String,
                        "image":self.loggedInUserData?["image"] as! String!,
                        "text":self.newTweetTextView.text,
                        "timestamp":"\(Date().timeIntervalSince1970)",
                        "picture":downloadUrl!.absoluteString,
                        "key":key,
                        "uid":FIRAuth.auth()!.currentUser!.uid] as [String : Any]
                    
                    FIRDatabase.database().reference().child("/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)").updateChildValues(childUpdates)
                    FIRDatabase.database().reference().child("/social/\(key)").updateChildValues(childUpdates) { (error, ref) in
                        if error == nil{
                            
                            SVProgressHUD.dismiss()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSocial"), object: nil)
                            self.newTweetTextView.resignFirstResponder()
                            self.dismiss(animated: true, completion: nil)
                            //                            self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                            
                        }
                    }
                }
                
            }
            
            //dismiss(animated: true, completion: nil)
        }
            //user has entered only text
        else if(tweetLength>0 && newTweetTextView.text != "Create Social Post here...")
        {
            let childUpdates = [
                "name":self.loggedInUserData?["displayName"] as! String,
                "image":self.loggedInUserData?["image"] as! String!,
                "timestamp":"\(Date().timeIntervalSince1970)",
                "text":self.newTweetTextView.text,
                "key":key,
                "uid":FIRAuth.auth()!.currentUser!.uid] as [String : Any]
            
            FIRDatabase.database().reference().child("/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)").updateChildValues(childUpdates)
            FIRDatabase.database().reference().child("/social/\(key)").updateChildValues(childUpdates) { (error, ref) in
                if error == nil{
                    
                    SVProgressHUD.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSocial"), object: nil)
                    self.newTweetTextView.resignFirstResponder()
                    self.dismiss(animated: true, completion: nil)
                    //                            self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                    
                }
            }
            
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
                        "name":self.loggedInUserData?["displayName"] as! String,
                        "image":self.loggedInUserData?["image"] as! String!,
                        "timestamp":"\(Date().timeIntervalSince1970)",
                        "picture":downloadUrl!.absoluteString,
                        "key":key,
                        "uid":FIRAuth.auth()!.currentUser!.uid] as [String : Any]
                    
                    FIRDatabase.database().reference().child("/posts/\(FIRAuth.auth()!.currentUser!.uid)/\(key)").updateChildValues(childUpdates)
                    FIRDatabase.database().reference().child("/social/\(key)").updateChildValues(childUpdates) { (error, ref) in
                        if error == nil{
                            
                            SVProgressHUD.dismiss()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSocial"), object: nil)
                            self.newTweetTextView.resignFirstResponder()
                            self.dismiss(animated: true, completion: nil)
//                            self.performSegue(withIdentifier: "unwindToMenu", sender: self)
                            
                        }
                    }
                }
                else
                {
                    print(error?.localizedDescription)
                }
                
            }
            
            // dismiss(animated: true, completion: nil)
            
        }else if(tweetLength == 0){
        SVProgressHUD.dismiss()
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
        
        if(self.newTweetTextView.text.characters.count>0 && self.newTweetTextView.text != "Create Social Post here...")
        {
            attributedString = NSMutableAttributedString(attributedString:self.newTweetTextView.attributedText)
        }
        else
        {
            attributedString = NSMutableAttributedString(string:"")
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
    
    @IBAction func cancelPressed(_ sender: Any) {
        newTweetTextView.resignFirstResponder()
       dismiss(animated: true, completion: nil)
    }
}
