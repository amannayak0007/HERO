//
//  NewMessageController.swift
//  FirebaseChat
//
//  Created by Colin Horsford on 9/2/16.
//  Copyright © 2016 Paerdegat. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let cellId = "cellId"
    
    var users = [User]()
    var searchResult: [User] = []
    var searchActive: Bool = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //cancel new message
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(NewMessageController.handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar

        
        fetchUser()
    }
    
    func fetchUser() {
        
//        FIRDatabase.database().reference().child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            let dictionary = snapshot.value as? NSDictionary
//            
//            if(dictionary?["donorORrecipient"] as? String == "Hero"){
//                
//                FIRDatabase.database().reference().child("users").queryOrdered(byChild: "donorORrecipient").queryEqual(toValue: "Recipient").observe(.childAdded, with: { (snapshot) in
//                    
//                    if let dictionary = snapshot.value as? [String: AnyObject] {
//                        let user = User()
//                        user.id = snapshot.key
//                        user.setValuesForKeys(dictionary)
//                        self.users.append(user)
//                        
//                        DispatchQueue.main.async(execute: {
//                            self.tableView.reloadData()
//                            SVProgressHUD.dismiss()
//                            
//                        })
//                    }
//                    
//                }, withCancel: nil)
//                
//                
//            }else{
//                
//                FIRDatabase.database().reference().child("users").queryOrdered(byChild: "donorORrecipient").queryEqual(toValue: "Hero").observe(.childAdded, with: { (snapshot) in
//                    
//                    if let dictionary = snapshot.value as? [String: AnyObject] {
//                        let user = User()
//                        user.id = snapshot.key
//                        user.setValuesForKeys(dictionary)
//                        self.users.append(user)
//                        
//                        DispatchQueue.main.async(execute: {
//                            self.tableView.reloadData()
//                            SVProgressHUD.dismiss()
//                            
//                        })
//                    }
//                    
//                }, withCancel: nil)
//                
//            }
//            
//            
//        })
        
        //gets users from Firebase
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key //gets ID from the user
                
                //if you use this setter, your app will crash if your class properties don't exavtly match up with the Firebase dictionary keys
//                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                //relaoding without dispatching queue will crash because of background thread so you need to dispatch_async
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
                //here's a safer way to do it
//                user.name = dictionary["name"]
//                user.email = dictionary["email"]
//                user.password = dictionary["password"]
                
                //print(user.name, user.email, user.password)
            }
            
            }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if searchActive && searchController.searchBar.text != ""{
            return searchResult.count
        }else {
            return users.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        //let's use a hack for now
        //let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        
        //returns all users byname with a subtitle of their email
//        let user = users[(indexPath as NSIndexPath).row]
//        cell.textLabel?.text = user.displayName
//        cell.detailTextLabel?.text = user.email
//        
//        
//        if let profileImageUrl = user.image {
//            
//            //see Extensions.swift file for code. Moved it there 
//            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
//        }else{
//        cell.profileImageView.image = UIImage(named: "default-profile")
//        }
        
        if searchActive && searchController.searchBar.text != ""{
            let user = searchResult[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = user.displayName
            cell.detailTextLabel?.text = user.email
            
            
            if let profileImageUrl = user.image {
                
                //see Extensions.swift file for code. Moved it there
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }else{
                cell.profileImageView.image = UIImage(named: "default-profile")
            }
        }else {
            let user = users[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = user.displayName
            cell.detailTextLabel?.text = user.email
            
            
            if let profileImageUrl = user.image {
                
                //see Extensions.swift file for code. Moved it there
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            }else{
                cell.profileImageView.image = UIImage(named: "default-profile")
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.dismiss(animated: true) {
           //print("Dismiss completed")
            
            if self.searchActive && self.searchController.searchBar.text != ""{
                let user = self.searchResult[(indexPath as NSIndexPath).row]
                self.messagesController?.showChatControllerForUser(user) //need to make reference above
            }else {
                let user = self.users[(indexPath as NSIndexPath).row]
                self.messagesController?.showChatControllerForUser(user) //need to make reference above
            }
            
            
            //you're sending the user in from the newMessageController to messagesController and then chatLogController
        }
      }
    }
}

extension NewMessageController: UISearchBarDelegate {
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            
            self.searchActive = false
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
