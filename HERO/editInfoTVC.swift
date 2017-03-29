//
//  editInfoTVC.swift
//  HERO
//
//  Created by amrun on 21/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class editInfoTVC: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, FCAlertViewDelegate {

    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var bloodField: UITextField!
    @IBOutlet weak var ethnicity: UITextField!
    @IBOutlet weak var maritalstatus: UITextField!
    
    var pickerView1 = UIPickerView()
    var pickOption1 = ["O-", "O+", "A-", "A+", "B-", "B+", "AB-", "AB+"]   //gender picker options
    
    var pickerView2 = UIPickerView()
    var pickOption2 = ["Caucasian", "African American", "Latino/Hispanic", "Asian/Pacific", "Islander", "Other"]
    
    var pickerView3 = UIPickerView()
    var pickOption3 = ["Single", "Married", "Widowed", "Divorced"]
    
    var pickerView4 = UIPickerView()
    var pickOption4 = [["1", "2", "3", "4", "5", "6", "7", "8", "9"], ["Feet"], ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"], ["Inches"]]
    
    let alertView: FCAlertView = {
        let alert = FCAlertView(type: .success)
        alert.dismissOnOutsideTouch = true
        
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Info"
        
//        heightField.keyboardType = .decimalPad
        weightField.keyboardType = .decimalPad
        
        heightField.delegate = self
        weightField.delegate = self
        bloodField.delegate = self
        ethnicity.delegate = self
        maritalstatus.delegate = self
        
        pickerView1.delegate = self
        pickerView2.delegate = self
        pickerView3.delegate = self
        pickerView4.delegate = self
        pickerView4.dataSource = self
        
        bloodField.inputView = pickerView1
        ethnicity.inputView = pickerView2
        maritalstatus.inputView = pickerView3
        heightField.inputView = pickerView4

        alertView.delegate = self //AlertView Delegate
        
        populateData()
    }

    func populateData() {
        
        SVProgressHUD.show()
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: {(Snapshot) in
            
            SVProgressHUD.dismiss()
            
            let dictionary = Snapshot.value as? NSDictionary
            
            self.heightField.text = dictionary?["height"] as? String
            self.weightField.text = dictionary?["weight"] as? String
            self.bloodField.text = dictionary?["bloodtype"] as? String
            self.ethnicity.text = dictionary?["ethnicity"] as? String
            self.maritalstatus.text = dictionary?["maritalstatus"] as? String
            
        }){(error) in
            
            print(error.localizedDescription)
        }

    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    // picker option
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if(heightField.isEditing){
            return pickOption4.count
        }else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(bloodField.isEditing){
            return pickOption1.count
        }else if(ethnicity.isEditing){
            return pickOption2.count
        }else if(heightField.isEditing){
            return pickOption4[component].count
        }else {
            return pickOption3.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(bloodField.isEditing){
            return pickOption1[row]
        }else if(ethnicity.isEditing){
            return pickOption2[row]
        }else if(heightField.isEditing){
            return pickOption4[component][row]
        }else{
            return pickOption3[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(bloodField.isEditing){
            bloodField.text = pickOption1[row]
        }else if(ethnicity.isEditing){
            ethnicity.text = pickOption2[row]
        }else if(heightField.isEditing){
            let feet = pickOption4[0][pickerView4.selectedRow(inComponent: 0)]
            let inches = pickOption4[2][pickerView4.selectedRow(inComponent: 2)]
            heightField.text = "\(feet)′\(inches)″"
        }else{
            maritalstatus.text = pickOption3[row]
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        alertView.showAlert(inView: self,
                            withTitle:"Save Changes",
                            withSubtitle:"Do you want to save all the changes?",
                            withCustomImage: UIImage(named:"herologo"),
                            withDoneButtonTitle:"No",
                            andButtons:["Yes"]) // Set your button titles here
  
    }
    
    func alertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        
        if title == "Yes" {
            
            SVProgressHUD.show()
            
            let newUser:[String:AnyObject] = [
                "height"    : heightField.text as AnyObject,
                "weight": weightField.text as AnyObject,
                "bloodtype": bloodField.text as AnyObject,
                "ethnicity"    : ethnicity.text as AnyObject,
                "maritalstatus": maritalstatus.text as AnyObject,
                ]
            
            FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(newUser) { (error, ref) in
                if error == nil{
                    
                    SVProgressHUD.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateinfo"), object: nil)
                    self.performSegue(withIdentifier: "unwindToSettings", sender: self)
                }
            }
        }
    }
    
}

