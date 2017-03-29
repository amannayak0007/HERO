//
//  question2.swift
//  HERO
//
//  Created by AMRUN on 12/02/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class question2: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var dobField: UITextField!
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
    
    let alertView1: FCAlertView = {
        let alert1 = FCAlertView(type: .warning)
        alert1.dismissOnOutsideTouch = true
        
        return alert1
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Hero Questionaire"
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSForegroundColorAttributeName : UIColor.white
//        ]
        
        if donorModel.fullName != nil{
            self.fullnameField.text = donorModel.fullName
            self.fullnameField.isEnabled = false
        }
        
        if donorModel.birthdate != nil{
            self.dobField.text = donorModel.birthdate
            self.dobField.isEnabled = false
        }
        
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
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
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
    
        SVProgressHUD.show()
        
        if requiredFieldsAreNotEmpty() {
            
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
                let storyboard: UIStoryboard = UIStoryboard(name: "questions", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "question3") as! question3
                self.navigationController?.pushViewController(vc, animated: true)
            }
         }
        }else{
        
            SVProgressHUD.dismiss()
            alertView1.showAlert(inView: self,
                                 withTitle: "Empty Field",
                                 withSubtitle:"Please provide all information.",
                                 withCustomImage: UIImage(named:"herologo"),
                                 withDoneButtonTitle:"Ok",
                                 andButtons:nil)
        }
    }
    
    func requiredFieldsAreNotEmpty() -> Bool {
     return !(self.heightField.text == "" || self.weightField.text == "" || self.bloodField.text == "" || self.ethnicity.text == "" || self.maritalstatus.text == "")
    }


}
