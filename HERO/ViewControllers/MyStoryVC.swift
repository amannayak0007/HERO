//
//  MyStoryVC.swift
//  HERO
//
//  Created by amrun on 10/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class MyStoryVC: UIViewController {

//    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.populateData), name: NSNotification.Name(rawValue: "populatedata"), object: nil)
    }
    
    func populateData() {
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            let dictionary = snapshot.value as? NSDictionary
            if(dictionary?["story"] != nil){
                self.textview.isHidden = false
                self.textview.text = "\((dictionary?["story"])!)"
                self.image.isHidden = true
            }else{
                self.image.isHidden = false
                self.image.image = #imageLiteral(resourceName: "nostory")
                self.textview.isHidden = true
            }
        }
    }
   

}
