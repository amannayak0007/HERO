//
//  ViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 06/10/2016.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewforsegment: UIView!
    @IBOutlet weak var SegmentedView: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var segment = UISegmentedControl()
    var loggedInUserData:NSDictionary?
    var searchbutton = UIBarButtonItem()
    
    var users = [User]()
    var searchResult: [User] = []
    var searchActive: Bool = false
//    var noSearchResult: Bool = false
    
    var messagesController: MessagesController?
    var menuView: BTNavigationDropdownMenu!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView()
        self.automaticallyAdjustsScrollViewInsets = false
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
            
            //store the logged in users details into the variable
            self.loggedInUserData = snapshot.value as? NSDictionary
            
        }
        
//        setupNavigationItem()
        
        // Style the Segmented Control
        SegmentedView.layer.cornerRadius = 5.0  // Don't let background bleed
        SegmentedView.backgroundColor = UIColor.white
        SegmentedView.tintColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
    
        segment = UISegmentedControl(items: ["Hero", "Recipient"])
        segment.sizeToFit()
        segment.layer.cornerRadius = 5.0  // Don't let background bleed
        segment.backgroundColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        segment.tintColor = UIColor.white
        segment.selectedSegmentIndex = 0;
        segment.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Avenir Medium", size: 15)!],
                                       for: UIControlState.normal)
        segment.addTarget(self, action: #selector(self.segmentedControlValueChanged(segment:)), for:.valueChanged)
        self.navigationItem.titleView = segment
        
        searchbutton = UIBarButtonItem(image: UIImage(named: "searchbtn"), style: .plain, target: self, action: #selector(self.showsearch))
        self.navigationItem.rightBarButtonItem = searchbutton

        users.removeAll()
        searchResult.removeAll()
//        fetchUser()
        loadHero()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setNavigationBarItem()
//        users.removeAll()
//        fetchUser()
        
    }
    
    func showsearch() {
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        self.navigationItem.titleView = searchController.searchBar
        self.navigationItem.rightBarButtonItem = nil
        
        searchController.isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            
            self.searchController.searchBar.becomeFirstResponder()
        }
        

    }
    
    func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            
            SVProgressHUD.show()
            self.viewforsegment.isHidden = true
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.tableView.contentInset = UIEdgeInsetsMake(55, 0, tabBarController!.tabBar.frame.size.height, 0)
            
            users.removeAll()
            searchResult.removeAll()
            self.searchActive = false
            self.tableView.reloadData()

            FIRDatabase.database().reference().child("users").queryOrdered(byChild: "donorORrecipient").queryEqual(toValue: "Hero").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User()
                    user.setValuesForKeys(dictionary)
                    self.users.append(user)
                    //                        print(dictionary)
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        
                    })
                }
                
            }, withCancel: nil)
        
        }else{
            SVProgressHUD.show()
            self.viewforsegment.isHidden = false
            self.tableView.frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.tableView.contentInset = UIEdgeInsetsMake(55, 0, tabBarController!.tabBar.frame.size.height, 0)
            
            users.removeAll()
            searchResult.removeAll()
            
            SegmentedView.selectedSegmentIndex = 0;
            
            self.searchActive = false
            FIRDatabase.database().reference().child("users").queryOrdered(byChild: "donorORrecipient").queryEqual(toValue: "Recipient").observe(.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let user = User()
                    user.setValuesForKeys(dictionary)
                    self.users.append(user)
                    //                        print(dictionary)
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.searchActive = true
                        
                        self.searchResult = (self.users.filter({ (items: User) -> Bool in
                            let tmp: NSString = items.Organ! as NSString
                            let range = tmp.range(of: "Kidney" , options: NSString.CompareOptions.caseInsensitive)
                            return range.location != NSNotFound
                            
                        }))
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        
                    })
                }
                
            }, withCancel: nil)
        }
    }
    
    func loadHero() {
        SVProgressHUD.show()
        self.viewforsegment.isHidden = true
        self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, tabBarController!.tabBar.frame.size.height, 0)
        
        FIRDatabase.database().reference().child("users").queryOrdered(byChild: "donorORrecipient").queryEqual(toValue: "Hero").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                //                        print(dictionary)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    
                })
            }
            
        }, withCancel: nil)
    }
    
    @IBAction func SegmentedView(_ sender: AnyObject) {
        
        if(SegmentedView.selectedSegmentIndex == 0)
        {
//            SVProgressHUD.show()
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                
//                self.searchActive = true
//                self.searchResult = self.users
//                self.tableView.reloadData()
//                SVProgressHUD.dismiss()
//                
//            }
            
            SVProgressHUD.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                
                self.searchActive = true
                
                self.searchResult = (self.users.filter({ (items: User) -> Bool in
                    let tmp: NSString = items.Organ! as NSString
                    let range = tmp.range(of: "Kidney" , options: NSString.CompareOptions.caseInsensitive)
                    return range.location != NSNotFound
                    
                }))
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                
            }


        }
        else if(SegmentedView.selectedSegmentIndex == 1)
        {
            SVProgressHUD.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                
                self.searchActive = true
                
                self.searchResult = (self.users.filter({ (items: User) -> Bool in
                    let tmp: NSString = items.Organ! as NSString
                    let range = tmp.range(of: "Liver" , options: NSString.CompareOptions.caseInsensitive)
                    return range.location != NSNotFound
                    
                }))
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                
            }


        }
        else if(SegmentedView.selectedSegmentIndex == 2)
        {
            SVProgressHUD.show()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                
                self.searchActive = true
                
                self.searchResult = (self.users.filter({ (items: User) -> Bool in
                    let tmp: NSString = items.Organ! as NSString
                    let range = tmp.range(of: "Bone", options: NSString.CompareOptions.caseInsensitive)
                    return range.location != NSNotFound
                    
                }))
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        if searchActive{
////            NoResult.text = ""
//            return 1
//        }else if searchActive && searchController.searchBar.text != ""{
//            //            NoResult.text = ""
//            return 1
//        } else {
////            NoResult.text = ""
//            return 1
//            
//        }
        
        return 1

    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    if searchActive{
            return searchResult.count
    }else if searchActive && searchController.searchBar.text != ""{
            return searchResult.count
    }else {
            return users.count
            
        }

    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! SearchTableViewCell
        
        
        if searchActive && searchController.searchBar.text != ""{
        //returns all users byname
        let user = searchResult[(indexPath as NSIndexPath).row]
        
        cell.Name.text = user.displayName
        cell.Location.text = user.City
        cell.AboutUS.text = user.email
        cell.bloodType.text = user.bloodtype
         
            if(user.pairedUID != nil){
                cell.PKEimage.image = #imageLiteral(resourceName: "verified")
            }else{
                cell.PKEimage.image = nil
            }
            
            let lati = self.loggedInUserData!["latitude"] as AnyObject
            let longi = self.loggedInUserData!["longitude"] as AnyObject
            
            let lati1 = user.latitude
            let longi1 = user.longitude
            
            let coordinate₀ = CLLocation(latitude: lati1 as! CLLocationDegrees, longitude: longi1 as! CLLocationDegrees)
            let coordinate₁ = CLLocation(latitude: lati as! CLLocationDegrees, longitude: longi as! CLLocationDegrees)
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            let distanceInMiles = ((distanceInMeters/1609.344) * 100).rounded() / 100
            
            cell.distance.text = "\(distanceInMiles) mi."
            
            if let profileImageUrl = user.image {
                
                cell.ProfileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
            }else{
                cell.ProfileImage.image = #imageLiteral(resourceName: "default-profile")
            }
        
        }else if searchActive{
            let user = searchResult[(indexPath as NSIndexPath).row]
            
            cell.Name.text = user.displayName
            cell.Location.text = user.City
            cell.AboutUS.text = user.email
            cell.bloodType.text = user.bloodtype
            
            if(user.pairedUID != nil){
                cell.PKEimage.image = #imageLiteral(resourceName: "verified")
            }else{
                cell.PKEimage.image = nil
            }
            
            let lati = self.loggedInUserData!["latitude"] as AnyObject
            let longi = self.loggedInUserData!["longitude"] as AnyObject
            
            let lati1 = user.latitude
            let longi1 = user.longitude
            
            let coordinate₀ = CLLocation(latitude: lati1 as! CLLocationDegrees, longitude: longi1 as! CLLocationDegrees)
            let coordinate₁ = CLLocation(latitude: lati as! CLLocationDegrees, longitude: longi as! CLLocationDegrees)
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            let distanceInMiles = ((distanceInMeters/1609.344) * 100).rounded() / 100
            
            cell.distance.text = "\(distanceInMiles) mi."
            
            if let profileImageUrl = user.image {
                
                cell.ProfileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
            }else{
                cell.ProfileImage.image = #imageLiteral(resourceName: "default-profile")
            }
        }else{
            
            //returns all users byname
            let user = users[(indexPath as NSIndexPath).row]
            
            cell.Name.text = user.displayName
            cell.Location.text = user.City
            cell.AboutUS.text = user.email
            cell.bloodType.text = user.bloodtype
            
            if(user.pairedUID != nil){
                cell.PKEimage.image = #imageLiteral(resourceName: "verified")
            }else{
                cell.PKEimage.image = nil
            }
            
            let lati = self.loggedInUserData!["latitude"] as AnyObject
            let longi = self.loggedInUserData!["longitude"] as AnyObject
            
            let lati1 = user.latitude
            let longi1 = user.longitude
            
            let coordinate₀ = CLLocation(latitude: lati1 as! CLLocationDegrees, longitude: longi1 as! CLLocationDegrees)
            let coordinate₁ = CLLocation(latitude: lati as! CLLocationDegrees, longitude: longi as! CLLocationDegrees)
            
            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            let distanceInMiles = ((distanceInMeters/1609.344) * 100).rounded() / 100
            
            cell.distance.text = "\(distanceInMiles) mi."
            
            if let profileImageUrl = user.image {
                
                cell.ProfileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
            }else{
                cell.ProfileImage.image = #imageLiteral(resourceName: "default-profile")
            }

        }
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //....
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if searchActive && searchController.searchBar.text != ""{
        
            if segue.identifier == "user" ,
                let DestVC = segue.destination as? SearchRootViewController,
                let indexPath = self.tableView.indexPathForSelectedRow {
                let user = self.searchResult[(indexPath as NSIndexPath).row]
                DestVC.user = user
            }
        }else if searchActive{
        
            if segue.identifier == "user" ,
                let DestVC = segue.destination as? SearchRootViewController,
                let indexPath = self.tableView.indexPathForSelectedRow {
                let user = self.searchResult[(indexPath as NSIndexPath).row]
                DestVC.user = user
            }
        }else{
        if segue.identifier == "user" ,
            let DestVC = segue.destination as? SearchRootViewController,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let user = self.users[(indexPath as NSIndexPath).row]
            DestVC.user = user
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = segment
        searchbutton = UIBarButtonItem(image: UIImage(named: "searchbtn"), style: .plain, target: self, action: #selector(self.showsearch))
        self.navigationItem.rightBarButtonItem = searchbutton
        
        self.searchActive = false
//        searchResult = users
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchActive = true
        
        self.searchResult = (self.users.filter({ (items: User) -> Bool in
            let tmp: NSString = "\(items.displayName!) \(items.email)" as NSString
            let range = tmp.range(of: searchText , options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
            
        }))
        self.tableView.reloadData()
    }
}

