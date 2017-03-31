//
//  HeaderViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 13/06/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import Social
import MessageUI

class HeaderViewController: UIViewController, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var namelabel: UILabel!
//    @IBOutlet weak var storylabel: UILabel!
    @IBOutlet weak var CityState: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
//    @IBOutlet weak var transplantLabel: UILabel!
   
    var name = ""
        
    @IBOutlet weak var PKEView: UIView!
    @IBOutlet weak var PKEUser: UIImageView!
    var PKEData: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.width/2
        self.ProfileImage.clipsToBounds = true
        self.ProfileImage.layer.borderWidth = 2.0
        self.ProfileImage.layer.borderColor = UIColor.white.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        ProfileImage.addGestureRecognizer(tap)
        ProfileImage.isUserInteractionEnabled = true

        PKEView.isHidden = true
        
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
    
    func tap(_ sender:UITapGestureRecognizer) {
        
        let imageView = sender.view as! UIImageView
        let imageInfo   = GSImageInfo(image: imageView.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender.view!)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
    }

    @IBAction func PKEButton(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchRootViewController") as! SearchRootViewController
        vc.uid = self.PKEData?["uid"] as? String
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent //or default
//    }
    
    func populateUserData(_ uid:String, userData:[String:AnyObject]){
        if(userData["image"] != nil){
            ProfileImage.profileImageFromUserUID(uid)
        }
        else{
            // blank profile image
            ProfileImage.image = #imageLiteral(resourceName: "AddPhoto")
        }
        
//        if(userData["Organ"] != nil){
//            self.transplantLabel.text = "\(userData["Organ"] as! String) Transplant"
//        }
        
        if(userData["pairedUID"] != nil){
        PKEView.isHidden = false
        FIRDatabase.database().reference().child("users/\(userData["pairedUID"] as! String)").observeSingleEvent(of: .value, with: {(Snapshot) in
            
            self.PKEData = Snapshot.value as? NSDictionary
            
            let url = URL(string: self.PKEData?["image"] as! String)
            self.PKEUser.layer.cornerRadius = self.PKEUser.frame.size.width/2
            self.PKEUser.clipsToBounds = true
            self.PKEUser.sd_setImage(with: url, placeholderImage: nil)
            
        }){(error) in
            
            print(error.localizedDescription)
        }
        }else{
            PKEView.isHidden = true
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
//            self.storylabel.text = "Help Spread \(name)'s Story"
    
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
    
    
//    @IBAction func fb(_ sender: AnyObject) {
//   
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
//            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//            facebookSheet.setInitialText("Share on Facebook #HERO")
//            self.present(facebookSheet, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//    
//    @IBAction func messenger(_ sender: AnyObject) {
//   
//        let textToShare = "Read about \(name)'s story on the Hero App. Anyone can be Hero! #HERO"
//        
//        if let myWebsite = NSURL(string: "www.heroapp.life") {
//            let objectsToShare = [textToShare, myWebsite] as [Any]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//            
//            //New Excluded Activities Code
//            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
//            //
//            
//            activityVC.popoverPresentationController?.sourceView = sender as! UIView
//            self.present(activityVC, animated: true, completion: nil)
//        }
//
//    }
//    
//    @IBAction func tw(_ sender: AnyObject) {
//    
//        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
//            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
//            twitterSheet.setInitialText("Read about \(name)'s story on the Hero App. Anyone can be Hero! #HERO")
//            self.present(twitterSheet, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
  
    @IBAction func imessage(_ sender: AnyObject) {
        let textToShare = "Read about \(name)'s story on the Hero App. Anyone can be Hero! Bit.ly/HeroApp #HERO"
        
        if let myWebsite = NSURL(string: "www.heroapp.life") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender as! UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
//    @IBAction func mail(_ sender: AnyObject) {
//  
//        let mailComposeViewController = configuredMailComposeViewController()
//        if MFMailComposeViewController.canSendMail() {
//            self.present(mailComposeViewController, animated: true, completion: nil)
//        } else {
//            self.showSendMailErrorAlert()
//        }
//        
//    }
//    
//    
//    func configuredMailComposeViewController() -> MFMailComposeViewController {
//        
//
//        UINavigationBar.appearance().tintColor = UIColor.white
//    
//        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//        
//        mailComposerVC.setToRecipients([""])
//        mailComposerVC.setSubject("Mail")
//        mailComposerVC.setMessageBody("Read about \(name)'s story on the Hero App. Anyone can be Hero! #HERO", isHTML: false)
//        
//        return mailComposerVC
//    }
//    
//    func showSendMailErrorAlert() {
//        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//        sendMailErrorAlert.show()
//    }
//    
//    // MARK: MFMailComposeViewControllerDelegate Method
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
}

//extension MFMailComposeViewController {
//    override open func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
//    }
//    
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationBar.isTranslucent = false
//        navigationBar.isOpaque = false
//        navigationBar.barTintColor = UIColor.white
//        navigationBar.tintColor = UIColor.white
//    }
//}
