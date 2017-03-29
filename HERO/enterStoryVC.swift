//
//  enterStoryVC.swift
//  HERO
//
//  Created by amrun on 10/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class enterStoryVC: UIViewController,UITextViewDelegate {

    var donor: Bool?
    
    @IBOutlet weak var storyTextview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if donor == true{
            self.title = "Enter About Me"
        }else{
            self.title = "Enter Your Story"
        }
        
        storyTextview.delegate = self
        storyTextview.textContainerInset = UIEdgeInsetsMake(15, 10, 10, 10)
        storyTextview.text = "Enter here..."
        storyTextview.textColor = UIColor.lightGray
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = true

        populateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        storyTextview.becomeFirstResponder()
    }
    
    func populateData() {
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            if(dictionary?["story"] != nil){
                self.storyTextview.text = "\((dictionary?["story"])!)"
                self.storyTextview.textColor = UIColor.black
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(storyTextview.textColor == UIColor.lightGray)
        {
            storyTextview.text = nil
            storyTextview.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if storyTextview.text.isEmpty {
            storyTextview.text = "Enter here..."
            storyTextview.textColor = UIColor.lightGray
        }
    }
    

    @IBAction func savePressed(_ sender: Any) {
        SVProgressHUD.show()
        
        let childUpdates = ["story":self.storyTextview.text as String]

        FIRDatabase.database().reference().child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").updateChildValues(childUpdates) { (error, ref) in
            if error == nil{
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "populatedata"), object: nil)
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "unwindToProfile", sender: self)
                
            }
        }
    }
}
