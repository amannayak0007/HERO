//
//  question4.swift
//  HERO
//
//  Created by AMRUN on 12/02/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class question4: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let disease = ["HIV", "Coronary Artery Disease", "Cancer", "Congested Heart Failure", "Peptic Ulcer Disease", "Tuberculosis", "Irritable Bowel Syndrome", "Joint Problems / Arthritis", "Hypertension", "Bleeding Problems", "Heart Attack", "Peripheral Vascular Disease", "Thyroid Problems", "Lung Problems", "Kidney Problems", "Anemia", "Blood Transfusions", "Intestinal Polyps or Tumors", "Psychiatric", "High Cholesterol", "Hepatitis B or C"]
    
    var selectedDisease: NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Hero Questionaire"
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            NSForegroundColorAttributeName : UIColor.white
//        ]
//        
        self.extendedLayoutIncludesOpaqueBars = true
    }

    @IBAction func save(_ sender: Any) {
        
        print(selectedDisease)
        
//        var selections = [AnyObject]()
//        for indexPath in selectedDisease {
//            selections.append(disease[(indexPath as! NSIndexPath).row] as AnyObject)
//        }
        
        var selections = [String]()
        for indexPath in selectedDisease {
            selections.append(disease[(indexPath as! NSIndexPath).row])
        }
        
        print(selections)
        
        let newUser:[String:AnyObject] = [
            "disease": selections as AnyObject,
        ]
        FIRDatabase.database().reference().child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").updateChildValues(newUser) { (error, ref) in
            if error == nil{
        
                FIRDatabase.database().reference().child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let dictionary = snapshot.value as? NSDictionary
                    
                    if(dictionary?["donorORrecipient"] as? String == "Hero"){
                        
                        SVProgressHUD.show()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            SVProgressHUD.dismiss()
                            
                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "tabbarVC") as! tabbarVC
                            vc.modalPresentationStyle = .custom
                            vc.modalTransitionStyle = .crossDissolve
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                        
                    }else{
                        
                        SVProgressHUD.show()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            SVProgressHUD.dismiss()
                            
                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "SelectOrganVC") as! SelectOrganVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                })
            }
        }
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "SignupVC2")
//        self.navigationController?.pushViewController(vc, animated: true)
        
/*        FIRDatabase.database().reference().child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            
            if(dictionary?["donorORrecipient"] as? String == "Donor"){
                
                SVProgressHUD.show()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    SVProgressHUD.dismiss()
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "profile") as! RootViewController
                    vc.modalPresentationStyle = .custom
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true, completion: nil)
                    
                }
                
            }else{
                
                SVProgressHUD.show()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    SVProgressHUD.dismiss()
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SelectOrganVC") as! SelectOrganVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            
            
        }) */
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "profile") as! RootViewController
//        vc.modalPresentationStyle = .custom
//        vc.modalTransitionStyle = .crossDissolve
//        self.present(vc, animated: true, completion: nil)
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return disease.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = disease[indexPath.row]
        
        if selectedDisease.contains(indexPath) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell!.accessoryType == .none {
            cell!.accessoryType = .checkmark
            selectedDisease.add(indexPath)
        }
        else {
            cell!.accessoryType = .none
            selectedDisease.remove(indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
