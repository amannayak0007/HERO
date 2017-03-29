//
//  verifyinfoVC.swift
//  HERO
//
//  Created by AMRUN on 12/02/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase
import LocationPickerViewController

class verifyinfoVC: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, LocationPickerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var DOBField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var donorORrecipientField: UITextField!
    
        var pickerView1 = UIPickerView()
        var pickOption1 = ["Other", "Male", "Female"]   //gender picker options
    
        var pickerView2 = UIPickerView()
        var pickOption2 = ["Hero", "Recipient"]   // donor/recipient picker options
    
    let alertView1: FCAlertView = {
        let alert1 = FCAlertView(type: .warning)
        alert1.dismissOnOutsideTouch = true
        
        return alert1
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Verify Info"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ]

        phoneField.keyboardType = .numberPad
        
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        
        pickerView1.delegate = self
        pickerView2.delegate = self
        
        genderField.delegate = self
        donorORrecipientField.delegate = self
        
        genderField.inputView = pickerView1
        donorORrecipientField.inputView = pickerView2
        
        populateData()
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    func populateData() {
        
        self.profileImage.image = donorModel.userImage
        self.DOBField.text = donorModel.birthdate
    }

    
    func fbprofile() {
        
        donorModel.phone = self.phoneField.text!
        donorModel.gender = self.genderField.text!
        donorModel.donorORrecipient = self.donorORrecipientField.text
        
        let key = FIRDatabase.database().reference().child("Photos").childByAutoId().key
        let storageRef = FIRStorage.storage().reference()
        let pictureStorageRef = storageRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)/photos/\(key)")
        
        let Data = UIImageJPEGRepresentation(self.profileImage.image!, 0.5)
        
        if(Data != nil){
            
            let uploadTask = pictureStorageRef.put(Data!,metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    let newUser:[String:AnyObject] = [
                        "email"    : donorModel.email! as AnyObject,
                        "createdAt": Date.init().timeIntervalSince1970 as AnyObject,
                        "uid": donorModel.uid as AnyObject,
                        "displayName": donorModel.fullName! as AnyObject,
                        "image"    : downloadUrl!.absoluteString as AnyObject,
                        "Gender": donorModel.gender! as AnyObject,
                        "DOB": donorModel.birthdate! as AnyObject,
                        "Phone": donorModel.phone! as AnyObject,
                        "donorORrecipient": donorModel.donorORrecipient! as AnyObject,
                        "Organ": "" as AnyObject,
                        "height": "" as AnyObject,
                        "State": "" as AnyObject,
                        "City": "" as AnyObject,
                        "weight": "" as AnyObject,
                        "bloodtype": "" as AnyObject,
                        "ethnicity": "" as AnyObject,
                        "maritalstatus": "" as AnyObject,
                        "smoke": "" as AnyObject,
                        "drink": "" as AnyObject,
                        "drug": "" as AnyObject,
                        "drugName": "" as AnyObject,
                        "latitude": "" as AnyObject,
                        "longitude": "" as AnyObject
                    ]
                    FIRDatabase.database().reference().child("users").child((donorModel.uid)!).updateChildValues(newUser) { (error, ref) in
                        if error == nil{
                            
                            SVProgressHUD.dismiss()
                            let locationPicker = LocationPicker()
                            locationPicker.delegate = self
                            locationPicker.currentLocationIconColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                            locationPicker.searchResultLocationIconColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                            locationPicker.pinColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                            locationPicker.title = "Select Location"
                            self.navigationController?.pushViewController(locationPicker, animated: true)
                            
                            // Completion closures
                            locationPicker.selectCompletion = { selectedLocationItem in
                                print("Select completion closure: " + selectedLocationItem.name)
                                
//                                print(selectedLocationItem.addressDictionary)
//                                print((selectedLocationItem.addressDictionary?["Country"])!)
                                
                                SVProgressHUD.show()
                                
                                if(selectedLocationItem.addressDictionary?["City"] != nil){
                                    Fire.shared.updateUserWithKeyAndValue("City", value: (selectedLocationItem.addressDictionary?["City"])! as AnyObject, completionHandler: nil)
                                }else{
                                    Fire.shared.updateUserWithKeyAndValue("City", value: "" as AnyObject, completionHandler: nil)
                                }
                                
                                if(selectedLocationItem.addressDictionary?["State"] != nil){
                                    Fire.shared.updateUserWithKeyAndValue("State", value: (selectedLocationItem.addressDictionary?["State"])! as AnyObject, completionHandler: nil)
                                }else{
                                    Fire.shared.updateUserWithKeyAndValue("State", value: "" as AnyObject, completionHandler: nil)
                                }
                                
                                Fire.shared.updateUserWithKeyAndValue("latitude", value: (selectedLocationItem.coordinate?.latitude) as AnyObject, completionHandler: nil)
                                Fire.shared.updateUserWithKeyAndValue("longitude", value: (selectedLocationItem.coordinate?.longitude) as AnyObject, completionHandler: nil)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    
                                    SVProgressHUD.dismiss()
                                    let storyboard: UIStoryboard = UIStoryboard(name: "questions", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "question2") as! question2
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                
                            }

                            
                        }else{
                            // error creating user
                            print(error?.localizedDescription)
                            SVProgressHUD.dismiss()
                            self.alertView1.showAlert(inView: self,
                                                      withTitle: "Alert!",
                                                      withSubtitle:"\(error!.localizedDescription)",
                                withCustomImage: UIImage(named:"herologo"),
                                withDoneButtonTitle:"Dismiss",
                                andButtons:nil)
                        }
                    }
                    
                }
                else
                {
                    print(error?.localizedDescription)
                    SVProgressHUD.dismiss()
                    self.alertView1.showAlert(inView: self,
                                              withTitle: "Alert!",
                                              withSubtitle:"\(error!.localizedDescription)",
                        withCustomImage: UIImage(named:"herologo"),
                        withDoneButtonTitle:"Dismiss",
                        andButtons:nil)
                }
            }
        }
        if(Data == nil){
            print("image data is nil")
        }

    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        SVProgressHUD.show()
        
        if requiredFieldsAreNotEmpty() {
            
            if(donorModel.uid != nil){
            
                fbprofile()
                
            }else{
            donorModel.phone = self.phoneField.text!
            donorModel.gender = self.genderField.text!
            donorModel.donorORrecipient = self.donorORrecipientField.text
            
            FIRAuth.auth()?.createUser(withEmail: donorModel.email!, password: donorModel.password!, completion: {
                user, error in
                
                if error == nil {
                    
                        donorModel.uid = user?.uid
                    
                        let key = FIRDatabase.database().reference().child("Photos").childByAutoId().key
                        let storageRef = FIRStorage.storage().reference()
                        let pictureStorageRef = storageRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)/photos/\(key)")
                        
                        let Data = UIImageJPEGRepresentation(self.profileImage.image!, 0.5)
                        
                        if(Data != nil){
                            
                            let uploadTask = pictureStorageRef.put(Data!,metadata: nil)
                            {metadata,error in
                                
                                if(error == nil)
                                {
                                    let downloadUrl = metadata!.downloadURL()
                                    
                                    let newUser:[String:AnyObject] = [
                                        "email"    : donorModel.email! as AnyObject,
                                        "createdAt": Date.init().timeIntervalSince1970 as AnyObject,
                                        "uid": user?.uid as AnyObject,
                                        "displayName": donorModel.fullName! as AnyObject,
                                        "image"    : downloadUrl!.absoluteString as AnyObject,
                                        "Gender": donorModel.gender! as AnyObject,
                                        "DOB": donorModel.birthdate! as AnyObject,
                                        "Phone": donorModel.phone! as AnyObject,
                                        "donorORrecipient": donorModel.donorORrecipient! as AnyObject,
                                        "Organ": "" as AnyObject,
                                        "height": "" as AnyObject,
                                        "State": "" as AnyObject,
                                        "City": "" as AnyObject,
                                        "weight": "" as AnyObject,
                                        "bloodtype": "" as AnyObject,
                                        "ethnicity": "" as AnyObject,
                                        "maritalstatus": "" as AnyObject,
                                        "smoke": "" as AnyObject,
                                        "drink": "" as AnyObject,
                                        "drug": "" as AnyObject,
                                        "drugName": "" as AnyObject,
                                        "latitude": "" as AnyObject,
                                        "longitude": "" as AnyObject
                                    ]
                                    FIRDatabase.database().reference().child("users").child((user?.uid)!).updateChildValues(newUser) { (error, ref) in
                                        if error == nil{
                                            
                                            SVProgressHUD.dismiss()
                                            let locationPicker = LocationPicker()
                                            locationPicker.delegate = self
                                            locationPicker.currentLocationIconColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                                            locationPicker.searchResultLocationIconColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                                            locationPicker.pinColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                                            locationPicker.title = "Select Location"
                                            self.navigationController?.pushViewController(locationPicker, animated: true)
                                            
                                            // Completion closures
                                            locationPicker.selectCompletion = { selectedLocationItem in
                                                print("Select completion closure: " + selectedLocationItem.name)
                                                
//                                                print(selectedLocationItem.addressDictionary)
//                                                print((selectedLocationItem.addressDictionary?["Country"])!)
                                                
                                                SVProgressHUD.show()
                                                
                                                if(selectedLocationItem.addressDictionary?["City"] != nil){
                                                    Fire.shared.updateUserWithKeyAndValue("City", value: (selectedLocationItem.addressDictionary?["City"])! as AnyObject, completionHandler: nil)
                                                }else{
                                                    Fire.shared.updateUserWithKeyAndValue("City", value: "" as AnyObject, completionHandler: nil)
                                                }
                                                
                                                if(selectedLocationItem.addressDictionary?["State"] != nil){
                                                    Fire.shared.updateUserWithKeyAndValue("State", value: (selectedLocationItem.addressDictionary?["State"])! as AnyObject, completionHandler: nil)
                                                }else{
                                                    Fire.shared.updateUserWithKeyAndValue("State", value: "" as AnyObject, completionHandler: nil)
                                                }
                                                
                                                Fire.shared.updateUserWithKeyAndValue("latitude", value: (selectedLocationItem.coordinate?.latitude) as AnyObject, completionHandler: nil)
                                                Fire.shared.updateUserWithKeyAndValue("longitude", value: (selectedLocationItem.coordinate?.longitude) as AnyObject, completionHandler: nil)
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    
                                                    SVProgressHUD.dismiss()
                                                    let storyboard: UIStoryboard = UIStoryboard(name: "questions", bundle: nil)
                                                    let vc = storyboard.instantiateViewController(withIdentifier: "question2") as! question2
                                                    self.navigationController?.pushViewController(vc, animated: true)
                                                }
                                                
                                            }

                                            
                                        }else{
                                            // error creating user
                                        }
                                    }

                                }
                                else
                                {
                                    print(error?.localizedDescription)
                                    SVProgressHUD.dismiss()
                                    self.alertView1.showAlert(inView: self,
                                                              withTitle: "Alert!",
                                                              withSubtitle:"\(error!.localizedDescription)",
                                        withCustomImage: UIImage(named:"herologo"),
                                        withDoneButtonTitle:"Dismiss",
                                        andButtons:nil)
                                }
                            }
                        }
                        if(Data == nil){
                            print("image data is nil")
                        }
                
            
            }else{
                print(error?.localizedDescription)
                    
                    SVProgressHUD.dismiss()
                    self.alertView1.showAlert(inView: self,
                                         withTitle: "Alert!",
                                         withSubtitle:"\(error!.localizedDescription)",
                                         withCustomImage: UIImage(named:"herologo"),
                                         withDoneButtonTitle:"Dismiss",
                                         andButtons:nil)
            }
        })
        
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

    func requiredFieldsAreNotEmpty() -> Bool {
        return !(self.phoneField.text == "" || self.genderField.text == "" || self.donorORrecipientField.text == "")
    }
    
    // picker option

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(genderField.isEditing){
        return pickOption1.count
        }else{
        return pickOption2.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(genderField.isEditing){
            return pickOption1[row]
        }else{
            return pickOption2[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(genderField.isEditing){
            genderField.text = pickOption1[row]
        }else{
            donorORrecipientField.text = pickOption2[row]
        }
    
    }
}
