//
//  ViewController.swift
//  FirebaseChat
//
//  Created by Colin Horsford on 9/1/16.
//  Copyright © 2016 Paerdegat. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MessagesController: UITableViewController {

    let cellId = "cellId"
    var loggedInUserData:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newMsgImage = UIImage(named: "newmessage")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMsgImage, style: .plain, target: self, action: #selector(MessagesController.handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        self.tableView.tableFooterView = UIView()
        
        //observeMessages()
        
        notificationPermission()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.setNavigationBarItem()

    }
    
    func observeUserMessages() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            FIRDatabase.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
                }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        
        let messageReference = FIRDatabase.database().reference().child("messages").child(messageId)
    
        messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            //create a dictionary to grab the messages
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let message = Message(dictionary: dictionary) //turn it into a message
                message.setValuesForKeys(dictionary)
                //self.messages.append(message)
                
                if let chatPartnerId = message.chatPartnerId() {
                    //use chatPartnerId and not toId or else messages between users will get separated into diff msgs
                    self.messagesDictionary[chatPartnerId] = message
                    
                }
                
                self.attemptToReloadTable()
                
            }
            
            }, withCancel: nil)
    }
    
    fileprivate func attemptToReloadTable() {
        
        //this is a workaround to stop the image flickering. We cause a delay so that it only loads once or else it'll load several times and constantly reload the timer
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(MessagesController.handleReloadTable), userInfo: nil, repeats: false)
        
    }
    var timer: Timer?
    
    //create a delay in reloading the table so that it doesn't reload constantly and possibly load the wrong images
    func handleReloadTable() {
        
        //using self.tableView.reloadData() alone will crash because of background thread, so lets call this on dispatch_async main thread
        
        //print("Reload") //used to illustrate how many times the console reloads
        
        self.messages = Array(self.messagesDictionary.values)
        
        //sort messages by most recent
        self.messages.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp?.int32Value > message2.timestamp?.int32Value
        })
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    /* No longer used
    //pulls together all of the messages
    func observeMessages() {
        let ref = FIRDatabase.database().reference().child("messages")
        ref.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            
            //create a dictionary to grab the messages
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeysWithDictionary(dictionary)
                //self.messages.append(message)
                
                if let toId = message.toId {
                    
                    self.messagesDictionary[toId] = message
                    
                    self.messages = Array(self.messagesDictionary.values)
                    
                    //sort messages by most recent
                    self.messages.sortInPlace({ (message1, message2) -> Bool in
                        return message1.timestamp?.intValue > message2.timestamp?.intValue
                    })
                }
                
                
                //using self.tableView.reloadData() alone will crash because of background thread, so lets call this on dispatch_async main thread
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    })
                
            }
            
            //print(snapshot)
            }, withCancelBlock: nil)
    }
*/
    
    //Swipe Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                               return
                            }
            
            let message = self.messages[indexPath.row]
            
            if let chatParterid = message.chatPartnerId(){
                
                 FIRDatabase.database().reference().child("user-messages").child(uid).child(chatParterid).removeValue(completionBlock: { (error, ref) in
                    
                    if error != nil{
                        print("Failed to delete message", error)
                        
                        return
                    }
                    
                    self.messagesDictionary.removeValue(forKey: chatParterid)
                    self.attemptToReloadTable()
                    
//                    self.messages.remove(at: indexPath.row)
//                    self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                 })
            }
            
//            FIRDatabase.database().reference().child("user-messages").child(uid).child(message.chatPartnerId()!)

//            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
//                return
//            }
//            let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
//            ref.observe(.childAdded, with: { (snapshot) in
//                
//                let userId = snapshot.key
//                let ref = FIRDatabase.database().reference().child("user-messages").child(uid).child(userId)
//                ref.removeValue()
//                
//                }, withCancel: nil)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if messages.count > 0 {
            
            tableView.backgroundView = UIImageView(image: nil)
            tableView.separatorStyle = .singleLine
            return 1
            
        }else{
            
            tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "nomessage"))
            tableView.separatorStyle = .none
            tableView.backgroundView?.contentMode = .scaleAspectFill

            
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[(indexPath as NSIndexPath).row]
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[(indexPath as NSIndexPath).row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(chatPartnerId)
        ref.observe(.value, with: { (snapshot) in
            //print(snapshot)
            
            //access user ID from snapshot
            guard let dictionary = snapshot.value as? [String:AnyObject]
                else {
                    return
            }
            
            //then cast it to User class
            let user = User()
            user.id = chatPartnerId
            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user)
            
            }, withCancel: nil)
    }
    
    func handleNewMessage() {
        
        //present newMessageController with a navbar
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self //slides over the chat log controller
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        
        //checks if user is logged in on startup
        if FIRAuth.auth()?.currentUser?.uid == nil {
//            perform(#selector(MessagesController.handleLogout), with: nil, afterDelay: 0)
            //gets rid of Unbalanced calls to begin/end appearance warnings b/c too many VCs loaded at once
            
        } else {
            
            fetchUserAndSetupNavbarTitle() //gets user's name and populates navbar
        }
    }
    
    func fetchUserAndSetupNavbarTitle() {
        
        //extract user from Firebase
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            
            //for some reason uid = nil
            return
        }
        
        FIRDatabase.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            //sets title to user name in navbar
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //self.navigationItem.title = dictionary["name"] as? String
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user)
            }
            
           // print(snapshot)
            
            }, withCancel: nil)
        
    }
    
    func setupNavBarWithUser(_ user: User) {
        
        //clears messages and reloads only the relevant ones
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = user.image {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //need x, y, width, height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.displayName
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //need x, y, width, height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        
         //        self.navigationItem.titleView = titleView
        
        //titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showChatController"))
    }
    
    func showChatControllerForUser(_ user: User) {
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout()) //fixes crash when switching to collectionView
        chatLogController.user = user //create reference in ChatLogController
        navigationController?.pushViewController(chatLogController, animated: true)
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
}

