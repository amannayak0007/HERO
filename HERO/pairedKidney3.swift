//
//  pairedKidney3.swift
//  HERO
//
//  Created by amrun on 25/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class pairedKidney3: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    var users = [User]()
    var autoCompleteViewController: AutoCompleteViewController!
    var isFirstLoad: Bool = true
    
    var pairedUID: String?
    
    let alertView: FCAlertView = {
        let alert = FCAlertView(type: .warning)
        alert.dismissOnOutsideTouch = true
        
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.becomeFirstResponder()
        self.title = "Paired Kidney Exchange"
        self.extendedLayoutIncludesOpaqueBars = true

       fetchUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            Autocomplete.setupAutocompleteForViewcontroller(self)
        }
    }

    @IBAction func connectPressed(_ sender: Any) {
        
        SVProgressHUD.show()
        
        if(self.pairedUID != nil){
            Fire.shared.updateUserWithKeyAndValue("pairedUID", value: "\(self.pairedUID!)" as AnyObject, completionHandler: nil)
            FIRDatabase.database().reference().child("users").child("\(self.pairedUID!)").updateChildValues(["pairedUID": "\(donorModel.uid!)"]) { (error, ref) in
                if error == nil{
                    self.emailField.resignFirstResponder()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        SVProgressHUD.showSuccess(withStatus: "Connected")
                        self.performSegue(withIdentifier: "unwindTokidneyview", sender: self)
                    }
                }
            }
            
        }else{
            SVProgressHUD.dismiss()
            emailField.resignFirstResponder()
            self.alertView.showAlert(inView: self,
                                     withTitle: "User Not Found!",
                                     withSubtitle:"No user found corresponding to this emial or name.",
                                     withCustomImage: UIImage(named:"herologo"),
                                     withDoneButtonTitle:"Dismiss",
                                     andButtons:nil)

            
        }
        
    }
    
    func fetchUser() {
        
        //gets users from Firebase
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key //gets ID from the user
                
//                user.setValuesForKeys(dictionary)
                self.users.append(user)
            }
        }, withCancel: nil)
    }
}

extension pairedKidney3: AutocompleteDelegate {
    
    func autoCompleteTextField() -> UITextField {
        return self.emailField
    }
    func autoCompleteThreshold(_ textField: UITextField) -> Int {
        return 1
    }
    
    func autoCompleteItemsForSearchTerm(_ term: String) -> [AutocompletableOption] {
        
        let filteredUsers = (self.users.filter({ (items: User) -> Bool in
            let tmp: NSString = "\(items.displayName!) \(items.email)" as NSString
            let range = tmp.range(of: term , options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
            
        }))
        
        let useremail: [AutocompletableOption] = filteredUsers.map { (items) -> AutocompleteCellData in
            let users = items
//            users.replaceSubrange(users.startIndex...users.startIndex, with: String(users.characters[users.startIndex]).capitalized)
            return AutocompleteCellData(text: users.displayName!, image: users.image!, uid: users.uid!)
            }.map( { $0 as AutocompletableOption })
        
        return useremail
    }
    
    func autoCompleteHeight() -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    
    func didSelectItem(_ item: AutocompletableOption) {
        self.emailField.text = item.text
        self.pairedUID = item.pairedUID
    }
}
