//
//  ProfileViewController.swift
//  HERO
//
//  Created by Amrun on 12/10/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit
import Firebase
import LocationPickerViewController

class ProfileViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, LocationPickerDelegate {
    
    let alertView: FCAlertView = {
        let alert = FCAlertView(type: .success)
        alert.dismissOnOutsideTouch = true
        
        return alert
    }()
    
    @IBOutlet weak var FullName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var PhoneNumber: UITextField!
    @IBOutlet weak var DOB: UITextField!
    @IBOutlet weak var City: UITextField!
    @IBOutlet weak var State: UITextField!
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var profileImageButton:UIButton!
    
    @IBOutlet weak var storyLabel: UILabel!
     var datePicker : UIDatePicker!
    
    @IBOutlet weak var currentLocation: UILabel!
    
     var donor: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageButton.addTarget(self, action: #selector(profilePictureButtonHandler), for: .touchUpInside)
        
        alertView.delegate = self //AlertView Delegate
        FullName.delegate = self
        DOB.delegate = self
        Email.delegate = self
        PhoneNumber.delegate = self
        City.delegate = self
        State.delegate = self
        PhoneNumber.keyboardType = UIKeyboardType.numberPad
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2

                if donor == true {
                    self.storyLabel.text = "Enter About Me"
                }else{
                    self.storyLabel.text = "Enter Your Story"
                }

        
        // populate screen
        Fire.shared.getUser { (uid, userData) in
            if(uid != nil && userData != nil){
                self.populateUserData(uid!, userData: userData!)
            }
        }
        
//        addDoneButtonOnKeyboard()

    }
    
    
    func populateUserData(_ uid:String, userData:[String:AnyObject]){
        if(userData["image"] != nil){
           profileImageView.profileImageFromUserUID(uid)
        } else{
            // blank profile image
           profileImageView.image = #imageLiteral(resourceName: "AddPhoto")
        }
        
        FullName.text = userData["displayName"] as? String
        DOB.text = userData["DOB"] as? String
        Email.text = userData["email"] as? String
        PhoneNumber.text = userData["Phone"] as? String
        City.text = userData["City"] as? String
        State.text = userData["State"] as? String
        self.currentLocation.text = "\((userData["City"])!), \((userData["State"])!)"

        
    }

    // add done button on keyboard
    
//    func addDoneButtonOnKeyboard()
//    {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
//        doneToolbar.barStyle = UIBarStyle.default
//        
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
//        
//        var items = [AnyObject]()
//        items.append(flexSpace)
//        items.append(done)
//        doneToolbar.items = items as? [UIBarButtonItem]
//        doneToolbar.sizeToFit()
//        
//        FullName.inputAccessoryView = doneToolbar
//        Email.inputAccessoryView = doneToolbar
//        PhoneNumber.inputAccessoryView = doneToolbar
//        DOB.inputAccessoryView = doneToolbar
//        City.inputAccessoryView = doneToolbar
//        State.inputAccessoryView = doneToolbar
//        
//    }
//    
//    func doneButtonAction()
//    {
//        FullName.resignFirstResponder()
//        Email.resignFirstResponder()
//        PhoneNumber.resignFirstResponder()
//        DOB.resignFirstResponder()
//        City.resignFirstResponder()
//        State.resignFirstResponder()
//    }
//    


    @IBAction func Save(_ sender: AnyObject) {
        
        alertView.showAlert(inView: self,
                            withTitle:"Save Changes",
                            withSubtitle:"Do you want to save all the changes?",
                            withCustomImage: UIImage(named:"herologo"),
                            withDoneButtonTitle:"No",
                            andButtons:["Yes"]) // Set your button titles here
    
    }
    
    func profilePictureButtonHandler(_ sender:UIButton){
        let alert = UIAlertController.init(title: "Change Profile Image", message: nil, preferredStyle: .actionSheet)
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
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.5)
        if(data != nil){
            Fire.shared.uploadFileAndMakeRecord(data!, fileType: .image_JPG, description: nil, completionHandler: { (downloadURL) in
                if(downloadURL != nil){
                    Fire.shared.updateUserWithKeyAndValue("image", value: downloadURL!.absoluteString as AnyObject, completionHandler: { (success) in
                        if(success){
                            Cache.shared.profileImage[Fire.shared.myUID!] = image
                            self.profileImageView.image = image
                        }
                        else{
                            
                        }
                    })
                }
            })
        }
        if(data == nil){
            print("image picker data is nil")
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpDate(self.DOB)
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
        DOB.text = dateFormatter1.string(from: datePicker.date)
        DOB.resignFirstResponder()
    }
    
    func cancelClick() {
        DOB.resignFirstResponder()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 3
//        if donor == true {
//            return 2
//        }else{
//            return 3
//        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }else if section == 1{
            return 5
        }else{
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0{
                
                let locationPicker = LocationPicker()
                locationPicker.delegate = self
                locationPicker.currentLocationIconColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                locationPicker.searchResultLocationIconColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                locationPicker.pinColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                navigationController!.pushViewController(locationPicker, animated: true)
            }
        }
        
        if indexPath.section == 2{
        
            if indexPath.row == 0{
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "enterStoryVC") as! enterStoryVC
                if donor == true {
                    vc.donor = true
                }else{
                    vc.donor = false
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func locationDidPick(locationItem: LocationItem) {
//        print(locationItem.addressDictionary)
//        print((locationItem.addressDictionary?["Country"])!)
        
        
        if(locationItem.addressDictionary?["City"] != nil && locationItem.addressDictionary?["State"] != nil){
            self.currentLocation.text = "\((locationItem.addressDictionary?["City"])!), \((locationItem.addressDictionary?["State"])!)"
            self.City.text = "\((locationItem.addressDictionary?["City"])!)"
            self.State.text = "\((locationItem.addressDictionary?["State"])!)"
        }
        
        
        if(locationItem.addressDictionary?["City"] != nil){
            Fire.shared.updateUserWithKeyAndValue("City", value: (locationItem.addressDictionary?["City"])! as AnyObject, completionHandler: nil)
        }else{
            Fire.shared.updateUserWithKeyAndValue("City", value: "" as AnyObject, completionHandler: nil)
        }
        
        if(locationItem.addressDictionary?["State"] != nil){
            Fire.shared.updateUserWithKeyAndValue("State", value: (locationItem.addressDictionary?["State"])! as AnyObject, completionHandler: nil)
        }else{
            Fire.shared.updateUserWithKeyAndValue("State", value: "" as AnyObject, completionHandler: nil)
        }

        Fire.shared.updateUserWithKeyAndValue("latitude", value: (locationItem.coordinate?.latitude) as AnyObject, completionHandler: nil)
        Fire.shared.updateUserWithKeyAndValue("longitude", value: (locationItem.coordinate?.longitude) as AnyObject, completionHandler: nil)
        
    }
    
     @IBAction func unwindToProfile(segue: UIStoryboardSegue) {}
   
}

extension ProfileViewController : FCAlertViewDelegate {
    
    func alertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        
        if title == "Yes" {
            
            SVProgressHUD.show()
            
            if let FullNameText = self.FullName.text{
                Fire.shared.updateUserWithKeyAndValue("displayName", value: FullNameText as AnyObject, completionHandler: nil)
            }
            if let EmailText = self.Email.text{
                Fire.shared.updateUserWithKeyAndValue("email", value: EmailText as AnyObject, completionHandler: nil)
            }
            if let DOBText = self.DOB.text{
                Fire.shared.updateUserWithKeyAndValue("DOB", value: DOBText as AnyObject, completionHandler: nil)
            }
            if let PhoneNumberText = self.PhoneNumber.text{
                Fire.shared.updateUserWithKeyAndValue("Phone", value: PhoneNumberText as AnyObject, completionHandler: nil)
            }
            if let CityText = self.City.text{
                if(self.City.text != ""){
                    Fire.shared.updateUserWithKeyAndValue("City", value: CityText as AnyObject, completionHandler: nil)}
                else{
                }
            }
            if let StateText = self.State.text{
                if(self.State.text != ""){
                    Fire.shared.updateUserWithKeyAndValue("State", value: StateText as AnyObject, completionHandler: nil)
                
                }
                else{
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "unwindToSettings", sender: self)
            }
            
        }
        
        func FCAlertViewDismissed(alertView: FCAlertView) {
            print("Delegate handling dismiss")
        }
        
        func FCAlertViewWillAppear(alertView: FCAlertView) {
            print("Delegate handling appearance")
        }
    }
}
