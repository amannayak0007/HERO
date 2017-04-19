//
//  SearchStoryViewController.swift
//  HERO
//
//  Created by Amrun on 01/11/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SDWebImage

class SearchStoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var databaseRef = FIRDatabase.database().reference()
    var user: User?

    @IBOutlet weak var homeTableView: UITableView!
    
    var defaultImageViewHeightConstraint:CGFloat = 160.0
    
    var posts = [Posts]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(user!.uid != nil){
 
            //get all the posts that are made by the user
            self.databaseRef.child("posts").child(self.user!.uid!).observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                self.posts.append(Posts(dictionary: dictionary))
                DispatchQueue.main.async(execute: {
                    
                    self.posts.sort(by: {$0.timestamp! > $1.timestamp!})
                    self.homeTableView.reloadData()
                    self.homeTableView.stopPullRefreshEver()
                    
                })
                
//                if let dictionary = snapshot.value as? [String: AnyObject] {
//                    let post = Posts()
//                    post.setValuesForKeys(dictionary)
//                    self.posts.append(post)
//                    self.posts.sort(by: {$0.timestamp! > $1.timestamp!})
//                    self.homeTableView.reloadData()
//                }
//                
//                self.posts.append(snapshot.value as! NSDictionary)
//                self.homeTableView.insertRows(at: [IndexPath(row:0,section:0)], with: UITableViewRowAnimation.automatic)
                
            }){(error) in
                
                print(error.localizedDescription)
            }
        
        }
        
        self.homeTableView.tableFooterView = UIView()
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
        self.homeTableView.estimatedRowHeight = 140

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell: StoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! StoryTableViewCell
            
            cell.name.text = user?.displayName
            
            let profile = user?.image
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
    
    
}

//extension SearchStoryViewController: SJSegmentedViewControllerViewSource {
//    
//    func viewForSegmentControllerToObserveContentOffsetChange(_ controller: UIViewController,
//                                                              index: Int) -> UIView {
//        return homeTableView!
//    }
//
//}

extension SearchStoryViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange() -> UIView {
        
        return homeTableView
    }
}
