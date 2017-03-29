//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit


enum LeftMenu: Int {
    case HeroSocial = 0
    case Profile
    case Search
    case Messages
    case Matches
    case Favorites
    case Settings
    case Signout
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol{
    
    @IBOutlet weak var HEROtag: UILabel!
    
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var CityState: UILabel!
    
    let alertView: FCAlertView = {
        let alert = FCAlertView(type: .success)
        alert.dismissOnOutsideTouch = true
        return alert
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["Hero Social", "Profile", "Search", "Messages", "Matches", "Favorites", "Settings", "Sign Out"]
    
    var herosocialVC: UIViewController!
    var viewController1: UIViewController!
    var searchViewController: UIViewController!
    var messagesController: UIViewController!
    var matchesViewController: UIViewController!
    var favoritesVC: UIViewController!
    var settingsTVC: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.delegate = self
        self.profileimage.layer.cornerRadius = self.profileimage.frame.size.width/2
        self.profileimage.clipsToBounds = true
        self.profileimage.layer.borderWidth = 2.5
        self.profileimage.layer.borderColor = UIColor.white.cgColor
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let herosocialVC = storyboard.instantiateViewController(withIdentifier: "socialVC") as! socialVC
        self.herosocialVC = UINavigationController(rootViewController: herosocialVC)
        
        let viewController1 = storyboard.instantiateViewController(withIdentifier: "ViewController1") as! ViewController1
        self.viewController1 = UINavigationController(rootViewController: viewController1)
        
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.searchViewController = UINavigationController(rootViewController: searchViewController)
        
        let messagesController = storyboard.instantiateViewController(withIdentifier: "MessagesController") as! MessagesController
        self.messagesController = UINavigationController(rootViewController: messagesController)
        messagesController.setNavigationBarItem()
        
        let matchesViewController = storyboard.instantiateViewController(withIdentifier: "MatchesViewController") as! MatchesViewController
        self.matchesViewController = UINavigationController(rootViewController: matchesViewController)
        
        let favoritesVC = storyboard.instantiateViewController(withIdentifier: "favoritesVC") as! favoritesVC
        self.favoritesVC = UINavigationController(rootViewController: favoritesVC)
        favoritesVC.setNavigationBarItem()
        
        let settingsTVC = storyboard.instantiateViewController(withIdentifier: "settingsTVC") as! settingsTVC
        self.settingsTVC = UINavigationController(rootViewController: settingsTVC)
        settingsTVC.setNavigationBarItem()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.donor), name: NSNotification.Name(rawValue: "donor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.recipient), name: NSNotification.Name(rawValue: "recipient"), object: nil)
    }
    
    func donor() {
        print("aaaaaaaaaaaaaaa")
        self.HEROtag.text = "HERO"
    }
    
    func recipient() {
        print("bbbbbbbbbbbbbbbb")
        self.HEROtag.text = "RECIPIENT"
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
        if(userData["image"] != nil){
            profileimage.profileImageFromUserUID(uid)
        }
        else{
            // blank profile image
            profileimage.image = #imageLiteral(resourceName: "AddPhoto")
        }
        
        if(userData["displayName"] != nil){
            
            self.namelabel.text = userData["displayName"] as! String?
            
        }else{
            //...
        }
        
        let state = userData["State"]
        let city = userData["City"]
        
        if(state != nil),(city != nil){
            
            self.CityState.text = "\(city!),\(state!)"
            
        }else{
            self.CityState.text = ""
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func ProfileButton(_ sender: AnyObject) {
        self.slideMenuController()?.changeMainViewController(self.viewController1, close: true)
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .HeroSocial:
            self.slideMenuController()?.changeMainViewController(self.herosocialVC, close: true)
        case .Profile:
            self.slideMenuController()?.changeMainViewController(self.viewController1, close: true)
        case .Search:
            self.slideMenuController()?.changeMainViewController(self.searchViewController, close: true)
        case .Messages:
            self.slideMenuController()?.changeMainViewController(self.messagesController, close: true)
        case .Matches:
            self.slideMenuController()?.changeMainViewController(self.matchesViewController, close: true)
        case .Favorites:
            self.slideMenuController()?.changeMainViewController(self.favoritesVC, close: true)
        case .Settings:
            self.slideMenuController()?.changeMainViewController(self.settingsTVC, close: true)
        case .Signout:
            print("Signout")
            alertView.showAlert(inView: self,
                                withTitle:"Sign Out",
                                withSubtitle:"Do You Want to Sign Out?",
                                withCustomImage: UIImage(named:"herologo"),
                                withDoneButtonTitle:"Cancel",
                                andButtons:["Sign Out"]) // Set your button titles here
        }
    }
}

extension LeftViewController : UITableViewDelegate, FCAlertViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .HeroSocial, .Profile, .Search, .Messages, .Matches, .Favorites, .Settings, .Signout:
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
    
    func alertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        
        if title == "Sign Out" {
            
            try! FIRAuth.auth()?.signOut()
            FBSDKAccessToken.setCurrent(nil)  //facebook
            //            GIDSignIn.sharedInstance().signOut()  //google
            
            //            // twitter
            //            let store = Twitter.sharedInstance().sessionStore
            //            if let userID = store.session()?.userID {
            //                store.logOutUserID(userID)}
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: LoginViewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
                vc.modalPresentationStyle = .custom
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
                
            }
            
        }
    }
    
    func FCAlertViewDismissed(alertView: FCAlertView) {
        print("Delegate handling dismiss")
    }
    
    func FCAlertViewWillAppear(alertView: FCAlertView) {
        print("Delegate handling appearance")
    }
    
    
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .HeroSocial, .Profile, .Search, .Messages, .Matches, .Favorites, .Settings, .Signout:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
