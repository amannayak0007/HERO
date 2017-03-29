//
//  donorHeaderVC.swift
//  HERO
//
//  Created by amrun on 01/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class heroHeaderVC: UIViewController {

    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var CityState: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.width/2
        self.ProfileImage.clipsToBounds = true
        self.ProfileImage.layer.borderWidth = 2.0
        self.ProfileImage.layer.borderColor = UIColor.white.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        ProfileImage.addGestureRecognizer(tap)
        ProfileImage.isUserInteractionEnabled = true
        
        
        // populate screen
        Fire.shared.getUser { (uid, userData) in
            if(uid != nil && userData != nil){
                self.populateUserData(uid!, userData: userData!)
                //                    self.populateCampaign(uid!, userData: userData!)
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

    func tap(_ sender:UITapGestureRecognizer) {
        
        let imageView = sender.view as! UIImageView
        let imageInfo   = GSImageInfo(image: imageView.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender.view!)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
    }
    
    func populateUserData(_ uid:String, userData:[String:AnyObject]){
        if(userData["image"] != nil){
            ProfileImage.profileImageFromUserUID(uid)
        }
        else{
            // blank profile image
            ProfileImage.image = #imageLiteral(resourceName: "AddPhoto")
        }
        
        // Calculate DOB
        let birthday = userData["DOB"] as! String
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        dateFormater.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now as Date, options: [])
        let age = calcAge.year
        
        name = userData["displayName"] as! String
        
        if(userData["displayName"] != nil){
            
            self.namelabel.text = "\(name),\(age!)"
            
        }else{
            // ....
        }
        
        let state = userData["State"]
        let city = userData["City"]
        
        if(state != nil && userData["State"] as! String != ""),(city != nil && userData["City"] as! String != ""){
            
            self.CityState.text = "\(city!),\(state!)"
            
        }else{
            self.CityState.text = ""
        }
        
    }

}
