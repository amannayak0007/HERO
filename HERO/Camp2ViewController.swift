//
//  Camp2ViewController.swift
//  HERO
//
//  Created by Amrun on 24/10/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit

class Camp2ViewController: UIViewController {

    @IBOutlet weak var campTitle: UILabel!
    @IBOutlet weak var campCost: UILabel!
    @IBOutlet weak var campDuration: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            self.campTitle.text = "\(userData["CampaignTitle"]!)"
        }
        else{
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
