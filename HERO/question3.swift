//
//  question3.swift
//  HERO
//
//  Created by AMRUN on 12/02/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class question3: UITableViewController {

    @IBOutlet weak var segment1: UISegmentedControl!
    @IBOutlet weak var segment2: UISegmentedControl!
    @IBOutlet weak var segment3: UISegmentedControl!
    
    @IBOutlet weak var smokeField: UITextField!
    @IBOutlet weak var drinkField: UITextField!
    @IBOutlet weak var drugName: UITextField!
    @IBOutlet weak var drugField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Hero Questionaire"
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSForegroundColorAttributeName : UIColor.white
//        ]
        
        segment1.addTarget(self, action: #selector(segment1Selected), for: .valueChanged)
        segment2.addTarget(self, action: #selector(segment2Selected), for: .valueChanged)
        segment3.addTarget(self, action: #selector(segment3Selected), for: .valueChanged)
        
        smokeField.isEnabled = false
        drinkField.isEnabled = false
        drugName.isEnabled = false
        drugField.isEnabled = false
        
        smokeField.keyboardType = .numberPad
        drinkField.keyboardType = .numberPad
        drugField.keyboardType = .numberPad
        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    func segment1Selected() {
        
        if(segment1.selectedSegmentIndex == 0){
        
            smokeField.isEnabled = true
            smokeField.becomeFirstResponder()
        }else{
        
            smokeField.isEnabled = false
            smokeField.resignFirstResponder()
            smokeField.text = ""
        }
        
    }
    
    func segment2Selected() {
        if(segment2.selectedSegmentIndex == 0){
            drinkField.isEnabled = true
            drinkField.becomeFirstResponder()
        }else{
            drinkField.isEnabled = false
            drinkField.resignFirstResponder()
            drinkField.text = ""
        }
    }
    
    func segment3Selected() {
        if(segment3.selectedSegmentIndex == 0){
            
            drugName.isEnabled = true
            drugName.becomeFirstResponder()
            drugField.isEnabled = true
            
        }else{
            drugName.isEnabled = false
            drugField.isEnabled = false
            drugName.resignFirstResponder()
            
            drugName.text = ""
            drugField.text = ""
        }
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

    @IBAction func savePressed(_ sender: Any) {
        
        let newUser:[String:AnyObject] = [
            "smoke"    : smokeField.text as AnyObject,
            "drink": drinkField.text as AnyObject,
            "drugName": drugName.text as AnyObject,
            "drug": drugField.text as AnyObject,
            ]
        
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(newUser) { (error, ref) in
            if error == nil{
                
                SVProgressHUD.dismiss()
                let storyboard: UIStoryboard = UIStoryboard(name: "questions", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "question4") as! question4
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
