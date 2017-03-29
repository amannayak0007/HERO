//
//  CreateCampaignView.swift
//  HERO
//
//  Created by Amrun on 13/10/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit

class CreateCampaignView: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    
    let alertView: FCAlertView = {
        let alert = FCAlertView(type: .success)
        alert.dismissOnOutsideTouch = true
        
        return alert
    }()
 
    let alertView1: FCAlertView = {
        let alert1 = FCAlertView(type: .warning)
        alert1.dismissOnOutsideTouch = true
        
        return alert1
    }()
    
    
    @IBOutlet weak var CampaignTitle: UITextField!
    @IBOutlet weak var SurgeryCost: UITextField!
    @IBOutlet weak var Organtype: UITextField!
    @IBOutlet weak var CampaignPeriod: UITextField!
    
    var pickerView1 = UIPickerView()
    var pickerView2 = UIPickerView()
    var pickOrgan = ["Kidney", "Intestine", "Liver", "Lungs", "Pancreas", "Heart","Bone","Veins","Eye"]
    var pickMonths = ["1 Month", "2 Months", "3 Months", "6 Months"]
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.delegate = self
        pickerView1.delegate = self
        pickerView2.delegate = self
        CampaignTitle.delegate = self
        SurgeryCost.delegate = self
        Organtype.delegate = self
        CampaignPeriod.delegate = self

        SurgeryCost.keyboardType = UIKeyboardType.numberPad
        
         addDoneButtonOnKeyboard()
        
        // populate screen
        Fire.shared.getUser { (uid, userData) in
            if(uid != nil && userData != nil){
                self.populateUserData(uid!, userData: userData!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // populate screen
        Fire.shared.getUser { (uid, userData) in
            if(uid != nil && userData != nil){
                self.populateUserData(uid!, userData: userData!)
            }
        }
        
    }

    func populateUserData(_ uid:String, userData:[String:AnyObject]){
    
        if(userData["CampaignTitle"] != nil){
            
            
            self.CampaignTitle.text = "\(userData["CampaignTitle"]!)"
            self.SurgeryCost.text = "\(userData["Amount"]!)"
            self.Organtype.text = "\(userData["Organ"]!)"
            self.CampaignPeriod.text = "\(userData["CampPeriod"]!)"
            
        }else{
            // ....
        }
    
    }


    @IBAction func CreateCampaign(_ sender: AnyObject) {
        
        if requiredFieldsAreNotEmpty() {
            
            alertView.showAlert(inView: self,
                                withTitle:"Create Campaign",
                                withSubtitle:"Do you want to Create Campaign?",
                                withCustomImage: UIImage(named:"herologo"),
                                withDoneButtonTitle:"No",
                                andButtons:["Yes"]) // Set your button titles here
            
        } else {
            alertView1.showAlert(inView: self,
                                withTitle: "Empty Field",
                                withSubtitle:"Please provide all information.",
                                withCustomImage: UIImage(named:"herologo"),
                                withDoneButtonTitle:"Ok",
                                andButtons:nil) // Set your button titles here
            
        }
    
    }
    
    func createErrorAlert(_ title: String?, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title ?? "Bad news", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        return alertController
    }
    
    func requiredFieldsAreNotEmpty() -> Bool {
        return !(self.CampaignTitle.text == "" || self.SurgeryCost.text == "" || self.Organtype.text == "" || self.CampaignPeriod.text == "")
    }


    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView1 == pickerView {
           return pickOrgan.count
        }
        if pickerView2 == pickerView {
           return pickMonths.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView1 == pickerView {
             return pickOrgan[row]
        }
        if pickerView2 == pickerView {
            return pickMonths[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView1 == pickerView {
            Organtype.text = pickOrgan[row]
        }
        if pickerView2 == pickerView {
            CampaignPeriod.text = pickMonths[row]
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.OrganPicker(self.Organtype)
        self.CampPeriodPicker(self.CampaignPeriod)
    }
    
    func OrganPicker(_ textField : UITextField){
        
        pickerView1.backgroundColor = UIColor.white
        Organtype.inputView = pickerView1
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateCampaignView.Organdone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateCampaignView.Organcancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    func Organdone() {
        Organtype.resignFirstResponder()
    }
    func Organcancel() {
        Organtype.resignFirstResponder()
    }
    
    func CampPeriodPicker(_ textField : UITextField){
        
        pickerView2.backgroundColor = UIColor.white
        CampaignPeriod.inputView = pickerView2
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateCampaignView.CampPerioddone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateCampaignView.CampPeriodcancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    func CampPerioddone() {
        CampaignPeriod.resignFirstResponder()
    }
    func CampPeriodcancel() {
        CampaignPeriod.resignFirstResponder()
    }
    
    // add done button on keyboard
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        CampaignTitle.inputAccessoryView = doneToolbar
        SurgeryCost.inputAccessoryView = doneToolbar
        
        
    }
    
    func doneButtonAction()
    {
        CampaignTitle.resignFirstResponder()
        SurgeryCost.resignFirstResponder()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        
        return 1
    }


}

extension CreateCampaignView : FCAlertViewDelegate {
 
    
    func alertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        
        if title == "Yes" {
            
             SVProgressHUD.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "unwindToMenu", sender: self)
            }
     
            if let CampTitle = self.CampaignTitle.text{
                Fire.shared.updateUserWithKeyAndValue("CampaignTitle", value: CampTitle as AnyObject, completionHandler: nil)
            }
            if let AmountField = self.SurgeryCost.text{
                Fire.shared.updateUserWithKeyAndValue("Amount", value: AmountField as AnyObject, completionHandler: nil)
            }
            if let OrganType = self.Organtype.text{
                Fire.shared.updateUserWithKeyAndValue("Organ", value: OrganType as AnyObject, completionHandler: nil)
            }
            if let CampPeriod = self.CampaignPeriod.text{
                Fire.shared.updateUserWithKeyAndValue("CampPeriod", value: CampPeriod as AnyObject, completionHandler: nil)
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
