//
//  settingsTVC.swift
//  HERO
//
//  Created by amrun on 03/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications

class settingsTVC: UITableViewController, MFMailComposeViewControllerDelegate, FCAlertViewDelegate {

    var donor: Bool?
    
    @IBOutlet weak var myswitch: UISwitch!
    
    let alertView: FCAlertView = {
        let alert = FCAlertView(type: .warning)
        alert.dismissOnOutsideTouch = true
        return alert
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
    
        alertView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            self.myswitch.isOn = true
            
        }else{
            self.myswitch.isOn = false
        }
     
    }
    
    @IBAction func switchPressed(_ sender: Any) {
        if myswitch.isOn {
            UIApplication.shared.unregisterForRemoteNotifications()
            myswitch.isOn = false
        } else {
            notificationPermission()
            myswitch.isOn = true
            
        }
    }
    
    func notificationPermission() {
        if #available(iOS 10.0, *) {
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        
        alertView.showAlert(inView: self,
                            withTitle:"Sign Out",
                            withSubtitle:"Do You Want to Sign Out?",
                            withCustomImage: UIImage(named:"herologo"),
                            withDoneButtonTitle:"Cancel",
                            andButtons:["Sign Out"]) // Set your button titles here

    }
    
    func alertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        
        if title == "Sign Out" {
            
            SVProgressHUD.show()
             Fire.shared.updateUserWithKeyAndValue("notiToken", value: "" as AnyObject, completionHandler: nil) //set notification token to empty string
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                try! FIRAuth.auth()?.signOut()
                FBSDKAccessToken.setCurrent(nil)  //facebook

//                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
//                vc.modalPresentationStyle = .custom
//                vc.modalTransitionStyle = .crossDissolve
//                self.present(vc, animated: true, completion: nil)
//                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
                SVProgressHUD.dismiss()
            }
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            
            return 1
        }else if section == 1 {
            
            return 1
        }else if section == 2 {
            
            return 1
        }else if section == 3 {
            
            return 1
        }else if section == 4 {
            
            return 2
        }else {
            
            return 0
        }

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
        
            if indexPath.row == 0{
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                vc.donor = self.donor
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 1{
            
            if indexPath.row == 0{
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "editInfoTVC") as! editInfoTVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func termsPressed(_ sender: UIButton){
    
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "termsNav")
    self.present(vc, animated: true, completion: nil)
    
    }
    
    //Send Feedback
    
    @IBAction func btnEmailTapped(_ sender: UIButton)
    {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
        else
        {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["support@heroapp.life"])
        mailComposerVC.setSubject("Feedback")
        mailComposerVC.setMessageBody("Feedback", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert()
    {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
     @IBAction func unwindToSettings(segue: UIStoryboardSegue) {}

}

extension MFMailComposeViewController {
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = false
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = UIColor.white
    }
}
