//
//  FirstTableViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 13/06/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class StoryTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var loggedInUserData:NSDictionary?
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var defaultImageViewHeightConstraint:CGFloat = 160.0
    
    var posts = [Posts]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: {(Snapshot) in
            
            //store the logged in users details into the variable
            self.loggedInUserData = Snapshot.value as? NSDictionary
            //            print(self.loggedInUserData)
            
            self.fetchData()
            
            })

        self.homeTableView.tableFooterView = UIView()
        
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
        self.homeTableView.estimatedRowHeight = 140
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.homeTableView.addGestureRecognizer(longPressGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchData), name: NSNotification.Name(rawValue: "loadSocial"), object: nil)
        
    }
    
    func fetchData() {
        //get all the posts that are made by the user
        
        posts.removeAll()
        self.homeTableView.reloadData()
        FIRDatabase.database().reference().child("posts").child(FIRAuth.auth()!.currentUser!.uid).observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Posts()
                post.setValuesForKeys(dictionary)
                self.posts.append(post)
                self.posts.sort(by: {$0.timestamp! > $1.timestamp!})
                self.homeTableView.reloadData()
                
//            self.posts.append(snapshot.value as! NSDictionary)
            }
//            self.homeTableView.insertRows(at: [IndexPath(row:0,section:0)], with: UITableViewRowAnimation.automatic)
            
        }){(error) in
            
            print(error.localizedDescription)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if posts.count > 0 {
            
            tableView.backgroundView = UIImageView(image: nil)
            tableView.separatorStyle = .singleLine
            return self.posts.count
            
        }else{
            
            tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "nopost"))
            tableView.backgroundView?.contentMode = .scaleAspectFill
            tableView.separatorStyle = .none
            return 0
        }
        
        
        
    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 190
//    }
//    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0 {
//            let cell: StoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "addstory", for: indexPath) as! StoryTableViewCell
//            
//            return cell
//        }else{
            
        let cell: StoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! StoryTableViewCell
            
            cell.name.text = self.loggedInUserData!["displayName"] as? String
            
            let profile = self.loggedInUserData!["image"] as? String
            let url = URL(string:profile!)
            cell.profilePic.layer.cornerRadius = 25
            cell.profilePic.clipsToBounds = true
            cell.profilePic!.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "AddPhoto"))
            
            let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.didTapMediaInPost(_:)))
            cell.postImage.addGestureRecognizer(imageTap)
        
        let timestamp = posts[(indexPath.row)].timestamp
        let dateTimeStamp = Date(timeIntervalSince1970: Double(timestamp!)!)
        cell.time.text = dateTimeStamp.shortTimeAgoSinceNow
        
            if(posts[(indexPath.row)].picture != nil && posts[(indexPath.row)].text != nil){
                
                cell.postImage.isHidden = false
                cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                
                
                let picture = posts[(indexPath.row)].picture
                
                let url = URL(string:picture!)
                cell.postImage.layer.cornerRadius = 10
                cell.postImage.clipsToBounds = true
                cell.postImage!.sd_setImage(with: url, placeholderImage: UIImage(named:"menu")!)
                
                let post = posts[(indexPath.row)].text
                
                cell.post.text = post
                cell.post.numberOfLines = 0
                cell.post.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.post.sizeToFit()
            }
            else if(posts[(indexPath.row)].picture != nil && posts[(indexPath.row)].text == nil){
                
                cell.post.text = ""
                cell.postImage.isHidden = false
                cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
                
                let picture = posts[(indexPath.row)].picture
                
                let url = URL(string:picture!)
                cell.postImage.layer.cornerRadius = 10
                cell.postImage.clipsToBounds = true
                cell.postImage!.sd_setImage(with: url, placeholderImage: UIImage(named:"menu")!)
                
            }else if(posts[(indexPath.row)].text != nil && posts[(indexPath.row)].picture == nil){
                
                cell.postImage.isHidden = true
                cell.imageViewHeightConstraint.constant = 0
                
                let post = posts[(indexPath.row)].text
                
                cell.post.text = post
                cell.post.numberOfLines = 0
                cell.post.lineBreakMode = NSLineBreakMode.byWordWrapping
                cell.post.sizeToFit()
            }else{
                //...
            }
            
            return cell

//        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didTapMediaInPost(_ sender:UITapGestureRecognizer)
    {
        let imageView = sender.view as! UIImageView
        let imageInfo   = GSImageInfo(image: imageView.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender.view!)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent //or default
    }
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = homeTableView.indexPathForRow(at: touchPoint) {
                
                // your code here, get the row for the indexPath or do whatever you want
                let alertController = UIAlertController(title: "Delete this post", message: "Do you want to delete this post?", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                let DestructiveAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive) {
                    (result : UIAlertAction) -> Void in
                    print("Delete")
                    SVProgressHUD.show()
                    FIRDatabase.database().reference().child("posts/\((FIRAuth.auth()?.currentUser?.uid)!)/\(self.posts[(indexPath.row)].key!)").removeValue(completionBlock: { (error, refer) in
                        if error != nil {
                            print(error!)
                        }else {
                            
                            print(refer)
                            FIRDatabase.database().reference().child("social/\(self.posts[(indexPath.row)].key!)").removeValue()
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchpost"), object: nil)
                            self.fetchData()
                            SVProgressHUD.dismiss()
                            
                        }
                })
                }
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                let okAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("Cancel")
                }
                
                alertController.addAction(DestructiveAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }

}


//
//extension StoryTableViewController: SJSegmentedViewControllerViewSource {
//    
//    func viewForSegmentControllerToObserveContentOffsetChange(_ controller: UIViewController,
//                                                              index: Int) -> UIView {
//        return homeTableView!
//    }
//}

extension StoryTableViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        
        return homeTableView
    }
}
