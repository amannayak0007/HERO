//
//  LoginViewController.swift
//  WatchClub
//
//  Created by AMAN JAIN on 7/11/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController{
    
    var backgroundImageNames: [String]?
    var introductionView: ZWIntroductionViewController?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let alertView1: FCAlertView = {
        let alert1 = FCAlertView(type: .warning)
        alert1.dismissOnOutsideTouch = true
        return alert1
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //placeholder text & color
        emailField.attributedPlaceholder = NSAttributedString(string:"Email Address",
                                                              attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
        
        isAppAlreadyLaunchedOnce()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //      SVProgressHUD.show()
    }
    
    
    @IBAction func loginAction(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        if requiredFieldsAreNotEmpty() {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: {
                user, error in
                
                if error == nil {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.updateUIElements()
                        SVProgressHUD.dismiss()
                    }
                    
                } else {
                    
                    SVProgressHUD.dismiss()
                    self.alertView1.showAlert(inView: self,
                                              withTitle: "Alert!",
                                              withSubtitle:"\(error!.localizedDescription)",
                        withCustomImage: UIImage(named:"herologo"),
                        withDoneButtonTitle:"Dismiss",
                        andButtons:nil)
                }
            })
        } else {
            
            SVProgressHUD.dismiss() //indicator dismiss
            
            alertView1.showAlert(inView: self,
                                 withTitle: "Empty Field",
                                 withSubtitle:"Please enter an email and password",
                                 withCustomImage: UIImage(named:"herologo"),
                                 withDoneButtonTitle:"Ok",
                                 andButtons:nil) // Set your button titles here
            
        }
    }
    
    func requiredFieldsAreNotEmpty() -> Bool {
        return !(self.emailField.text == "" || self.passwordField.text == "")
    }
    
    func updateUIElements() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabbarVC") as! tabbarVC
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func checkIfUserExists(_ user: FIRUser, completionHandler: @escaping (Bool) -> ()) {
        FIRDatabase.database().reference().child("users").child(user.uid).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            if snapshot.value is NSNull {
                completionHandler(false)
            } else {
                let userDict:[String:AnyObject] = snapshot.value as! [String:AnyObject]
                if(userDict["createdAt"] != nil){
                    completionHandler(true)
                } else{
                    completionHandler(false)
                }
            }
        }
    }
    
    //facebook login
    @IBAction func facebookLogin (sender: AnyObject){
        
        let facebookLogin = FBSDKLoginManager()
        
        print("Logging In")
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self, handler:{(facebookResult, facebookError) -> Void in
            
            if facebookError != nil {
                
                print("Facebook login failed.Error \(facebookError)")
                SVProgressHUD.dismiss()
                self.alertView1.showAlert(inView: self,
                                          withTitle: "Alert!",
                                          withSubtitle:"\(facebookError!)",
                    withCustomImage: UIImage(named:"herologo"),
                    withDoneButtonTitle:"Dismiss",
                    andButtons:nil)
            }
                
            else if (facebookResult?.isCancelled)! {
                
                print("Facebook login was cancelled.")
                SVProgressHUD.dismiss()
            }
                
            else {
                print("You’re in")
                SVProgressHUD.dismiss()
                
                let accessToken = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                FIRAuth.auth()?.signIn(with: accessToken) { (user, error) in
                    
                    if error != nil {
                        print("Login Failed, \(error)")
                        SVProgressHUD.dismiss()
                        self.alertView1.showAlert(inView: self,
                                                  withTitle: "Alert!",
                                                  withSubtitle:"\(error!)",
                            withCustomImage: UIImage(named:"herologo"),
                            withDoneButtonTitle:"Dismiss",
                            andButtons:nil)
                    }else {
                        SVProgressHUD.show()
                        print("Logged in! \(user)")
                        
                        self.checkIfUserExists(user!, completionHandler: { (exists) in
                            
                            if(exists){
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.updateUIElements()
                                    SVProgressHUD.dismiss()
                                }
                            }else{
                                
                                //                                let newUser:[String:AnyObject] = [
                                //                                    "displayName": user!.displayName! as String as AnyObject,
                                //                                    "image"    : user!.photoURL!.absoluteString as String as AnyObject,
                                //                                    "email": user?.email! as AnyObject,
                                //                                    "createdAt": Date.init().timeIntervalSince1970 as AnyObject,
                                //                                    "uid": user!.uid as String as AnyObject
                                //                                ]
                                //
                                //                                FIRDatabase.database().reference().child("users").child((user?.uid)!).updateChildValues(newUser) { (error, ref) in
                                //
                                //                                    if error == nil{
                                //
                                //                                        SVProgressHUD.dismiss()
                                //
                                //                                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                //                                        let vc = storyboard.instantiateViewController(withIdentifier: "signupnav") as! UINavigationController
                                //                                        vc.modalPresentationStyle = .custom
                                //                                        vc.modalTransitionStyle = .crossDissolve
                                //                                        self.present(vc, animated: true, completion: nil)
                                //
                                //
                                //                                    }else{
                                //                                        // error creating user
                                //                                        SVProgressHUD.dismiss()
                                //                                        let alert = UIAlertController(title: "Bad News", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                                //                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                //                                        self.present(alert, animated: true, completion: nil)
                                //                                    }
                                //                                }
                                
                                let params: [String : Any] = ["redirect": false, "height": 400, "width": 400, "type": "large"]
                                let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture", parameters: params, httpMethod: "GET")
                                pictureRequest?.start(completionHandler: {
                                    (connection, result, error) -> Void in
                                    if error == nil {
                                        print("\(result)")
                                        
                                        let dictionary = result as? [String:Any]
                                        let dataDic = dictionary?["data"] as? [String:Any]
                                        let urlPic = dataDic?["url"] as? String
                                        
                                        donorModel.imageURL = urlPic!
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            
                                            SVProgressHUD.dismiss()
                                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                            let vc = storyboard.instantiateViewController(withIdentifier: "signupnav") as! UINavigationController
                                            vc.modalPresentationStyle = .custom
                                            vc.modalTransitionStyle = .crossDissolve
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                        
                                    } else {
                                        print("\(error)")
                                        SVProgressHUD.dismiss()
                                        self.alertView1.showAlert(inView: self,
                                                                  withTitle: "Alert!",
                                                                  withSubtitle:"\(error)",
                                            withCustomImage: UIImage(named:"herologo"),
                                            withDoneButtonTitle:"Dismiss",
                                            andButtons:nil)
                                        
                                    }
                                })
                                
                                donorModel.fullName = user!.displayName! as String
                                donorModel.email = user!.email! as String
//                                donorModel.imageURL = user!.photoURL!.absoluteString as String
                                donorModel.uid = user!.uid as String
                                
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                    
//                                    SVProgressHUD.dismiss()
//                                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                    let vc = storyboard.instantiateViewController(withIdentifier: "signupnav") as! UINavigationController
//                                    vc.modalPresentationStyle = .custom
//                                    vc.modalTransitionStyle = .crossDissolve
//                                    self.present(vc, animated: true, completion: nil)
//                                }
                                
                            }
                        })
                    }
                }
            }
        });
    }
    
    //Launch only First Time
    func isAppAlreadyLaunchedOnce()->Bool{
        
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            
            SVProgressHUD.show()
            print("App already launched")
            
            if (FIRAuth.auth()?.currentUser) != nil {
                
                SVProgressHUD.show()
                let user = FIRAuth.auth()?.currentUser
                self.checkIfUserExists(user!, completionHandler: { (exists) in
                    SVProgressHUD.show()
                    if(exists){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.updateUIElements()
                            SVProgressHUD.dismiss()
                        }
                    }else{
                        SVProgressHUD.show()
                        
                        let params: [String : Any] = ["redirect": false, "height": 400, "width": 400, "type": "large"]
                        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture", parameters: params, httpMethod: "GET")
                        pictureRequest?.start(completionHandler: {
                            (connection, result, error) -> Void in
                            if error == nil {
                                print("\(result)")
                                
                                let dictionary = result as? [String:Any]
                                let dataDic = dictionary?["data"] as? [String:Any]
                                let urlPic = dataDic?["url"] as? String
                                
                                donorModel.imageURL = urlPic
                                
                                print(donorModel.imageURL)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    
                                    SVProgressHUD.dismiss()
                                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc = storyboard.instantiateViewController(withIdentifier: "signupnav") as! UINavigationController
                                    vc.modalPresentationStyle = .custom
                                    vc.modalTransitionStyle = .crossDissolve
                                    self.present(vc, animated: true, completion: nil)
                                }
                             
                                
                            } else {
                                print("\(error)")
                            }
                        })
                        
                        donorModel.fullName = user!.displayName! as String
                        donorModel.email = user!.email! as String
//                        donorModel.imageURL = user!.photoURL!.absoluteString as String
                        donorModel.uid = user!.uid as String
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            
//                            SVProgressHUD.dismiss()
//                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                            let vc = storyboard.instantiateViewController(withIdentifier: "signupnav") as! UINavigationController
//                            vc.modalPresentationStyle = .custom
//                            vc.modalTransitionStyle = .crossDissolve
//                            self.present(vc, animated: true, completion: nil)
//                        }
                        
                    }
                })
                
            }else {
                SVProgressHUD.dismiss()
            }
            return true
        }
        else {
            
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            
            do {
                SVProgressHUD.dismiss()
                try FIRAuth.auth()?.signOut()
                walkthrough()
            }catch {
                //
            }
            
            return false
        }
    }
    
    func walkthrough() {
        
        self.backgroundImageNames = ["screen1","screen2", "screen3"]
        
        self.introductionView = self.simpleIntroductionView()
        self.introductionView?.modalPresentationStyle = .custom
        self.introductionView?.modalTransitionStyle = .crossDissolve
        present(introductionView!, animated: true, completion: nil)
//        self.view.addSubview(introductionView!.view)
        
        self.introductionView?.didSelectedEnter = {
//            self.introductionView?.view.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
            self.introductionView = nil;
            //             enter main view , write your code ...
        }
        
    }
    
    func simpleIntroductionView() -> ZWIntroductionViewController {
        let vc = ZWIntroductionViewController(coverImageNames: self.backgroundImageNames)
        return vc!
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
}
