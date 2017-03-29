//
//  searchMyStoryVC.swift
//  HERO
//
//  Created by amrun on 10/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class searchMyStoryVC: UIViewController {

//    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var image: UIImageView!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        populateData()
    }

    func populateData() {
        FIRDatabase.database().reference().child("users").child((user?.uid)!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
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
