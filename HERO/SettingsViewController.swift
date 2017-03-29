//
//  SettingsViewController.swift
//  HERO
//
//  Created by Amrun on 11/10/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit
import Firebase
import LocationPickerViewController

class SettingsViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationPickerDelegate, UIPickerViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var Slider: UISlider!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var genderField: UITextField!
    
    var pickerView1 = UIPickerView()
    var pickOption1 = ["Male", "Female", "Both Male and Female"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Filter Search"
        
        pickerView1.delegate = self
        genderField.delegate = self
        
        genderField.inputView = pickerView1
        
        populateData()
    }
    
    func populateData() {
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            if(dictionary?["City"] != nil){
            self.locationLabel.text = "\((dictionary?["City"])!), \((dictionary?["State"])!)"
            }
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        
        milesLabel.text = "\(currentValue)mi."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 4
        }else {
            
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0{
                
                let locationPicker = LocationPicker()
                locationPicker.delegate = self
                locationPicker.currentLocationIconColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                locationPicker.searchResultLocationIconColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                locationPicker.pinColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
                navigationController!.pushViewController(locationPicker, animated: true)
            }
        }
        
    }

    func locationDidPick(locationItem: LocationItem) {
//        print(locationItem.addressDictionary)
//        print((locationItem.addressDictionary?["Country"])!)
        
        if(locationItem.addressDictionary?["City"] != nil && locationItem.addressDictionary?["State"] != nil){
            self.locationLabel.text = "\((locationItem.addressDictionary?["City"])!), \((locationItem.addressDictionary?["State"])!)"
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
    
    // gender picker option
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickOption1.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickOption1[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            genderField.text = pickOption1[row]
    }

}
