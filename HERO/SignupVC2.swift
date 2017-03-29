//
//  LoginViewController.swift
//  WatchClub
//
//  Created by AMAN JAIN on 7/11/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit

class SignupVC2: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var DOBField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var profileImageButton:UIButton!
    
    var datePicker : UIDatePicker!
    
    let alertView1: FCAlertView = {
        let alert1 = FCAlertView(type: .warning)
        alert1.dismissOnOutsideTouch = true
        
        return alert1
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Create Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ]

     
        profileImageButton.addTarget(self, action: #selector(profilePictureButtonHandler), for: .touchUpInside)

        DOBField.delegate = self
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        
        populateData()
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    func populateData() {
        
        if(donorModel.email != nil){
            
            self.emailField.text = donorModel.email
            self.emailField.isEnabled = false
            self.passwordField.text = "********"
            self.passwordField.isEnabled = false
            self.nameField.text = donorModel.fullName
            
            let url = URL(string:(donorModel.imageURL ?? nil)!)
            self.profileImageView.sd_setImage(with: url, placeholderImage: nil)
            self.profileImageButton.setImage(nil, for: .normal)
            
        }else{
            //load default
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
      
        SVProgressHUD.show()
        
        if requiredFieldsAreNotEmpty() {
            
            donorModel.fullName = self.nameField.text!
            donorModel.birthdate = self.DOBField.text!
            donorModel.email = self.emailField.text!
            donorModel.password = self.passwordField.text
            donorModel.userImage = self.profileImageView.image
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                SVProgressHUD.dismiss()
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "verifyinfoVC") as! verifyinfoVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
          }else{
            SVProgressHUD.dismiss()
                        alertView1.showAlert(inView: self,
                                             withTitle: "Empty Field",
                                             withSubtitle:"Please provide all information.",
                                             withCustomImage: UIImage(named:"herologo"),
                                             withDoneButtonTitle:"Ok",
                                             andButtons:nil) // Set your button titles here
            }

    }
    
    func profilePictureButtonHandler(_ sender:UIButton){
        let alert = UIAlertController.init(title: "Upload Profile Image", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction.init(title: "Camera", style: .default) { (action) in
            self.openImagePicker(.camera)
        }
        let action2 = UIAlertAction.init(title: "Photos", style: .default) { (action) in
            self.openImagePicker(.photoLibrary)
        }
        let action3 = UIAlertAction.init(title: "Cancel", style: .cancel) { (action) in }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func openImagePicker(_ sourceType:UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ]
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        self.profileImageView.image = image
        self.profileImageButton.setImage(nil, for: .normal)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    func requiredFieldsAreNotEmpty() -> Bool {
    return !(self.nameField.text == "" || self.DOBField.text == "" || self.emailField.text == "" || self.passwordField.text == "" || self.profileImageView.image == nil)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.DOBField)
    }

    //MARK:- Function of datePicker
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // MARK:- Button Done and Cancel
    func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter1.timeStyle = .none
        DOBField.text = dateFormatter1.string(from: datePicker.date)
        DOBField.resignFirstResponder()
    }
    
    func cancelClick() {
        DOBField.resignFirstResponder()
    }
    
    @IBAction func Goback(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
