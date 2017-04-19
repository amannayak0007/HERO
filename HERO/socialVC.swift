//
//  socialVC.swift
//  HERO
//
//  Created by amrun on 03/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import DateToolsSwift
import PullToRefreshSwift

class socialVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var homeTableView: UITableView!
    var backgroundImageNames: [String]?
    var introductionView: ZWIntroductionViewController?
    
    var defaultImageViewHeightConstraint:CGFloat = 160.0
    
    var posts = [Posts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.setNavigationBarItem()
        
        self.homeTableView.tableFooterView = UIView()
        
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
        self.homeTableView.estimatedRowHeight = 140
        
        var options = PullToRefreshOption()
        options.indicatorColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        
        self.homeTableView.addPullRefresh(options: options, refreshCompletion: { [weak self] in
            // some code
            
            self?.fetchPosts()
        })
        
        self.homeTableView.startPullRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchPosts), name: NSNotification.Name(rawValue: "fetchpost"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchPosts), name: NSNotification.Name(rawValue: "loadSocial"), object: nil)
    }
    
    func fetchPosts() {
        
        posts.removeAll()
        self.homeTableView.reloadData()
        FIRDatabase.database().reference().child("social").observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            self.posts.append(Posts(dictionary: dictionary))
            DispatchQueue.main.async(execute: {

                self.posts.sort(by: {$0.timestamp! > $1.timestamp!})
                self.homeTableView.reloadData()
                self.homeTableView.stopPullRefreshEver()

            })
            
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let post = Posts()
//                post.setValuesForKeys(dictionary)
//                self.posts.append(post)
//                self.posts.sort(by: {$0.timestamp! > $1.timestamp!})
//                self.homeTableView.reloadData()
//                self.homeTableView.stopPullRefreshEver()
//            }
            
        }){(error) in
            
            print(error.localizedDescription)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! StoryTableViewCell
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.didTapMediaInPost(_:)))
        cell.postImage.addGestureRecognizer(imageTap)
        
        cell.name.text = posts[indexPath.row].name
        
        let timestamp = posts[indexPath.row].timestamp
        let dateTimeStamp = Date(timeIntervalSince1970: Double(timestamp!)!)
        cell.time.text = dateTimeStamp.shortTimeAgoSinceNow
        
        let pic = posts[indexPath.row].image
        let url = URL(string:pic!)
        cell.profilePic.layer.cornerRadius =  cell.profilePic.frame.width/2
        cell.profilePic.clipsToBounds = true
        cell.profilePic!.sd_setImage(with: url, placeholderImage: UIImage(named:"AddPhoto")!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedProfilepic(_:)))
        cell.profilePic.addGestureRecognizer(tap)
        cell.profilePic.isUserInteractionEnabled = true
        cell.profilePic.tag = indexPath.row
        
        if(posts[indexPath.row].picture != nil && posts[indexPath.row].text != nil){
            
            cell.postImage.isHidden = false
            cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
            
            
            let picture = posts[indexPath.row].picture
            
            let url = URL(string:picture!)
            cell.postImage.layer.cornerRadius = 10
            cell.postImage.clipsToBounds = true
            cell.postImage!.sd_setImage(with: url, placeholderImage: UIImage(named:"menu")!)
            
            let post = posts[indexPath.row].text
            
            cell.post.text = post
            cell.post.numberOfLines = 0
            cell.post.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.post.sizeToFit()
        }
        else if(posts[indexPath.row].picture != nil && posts[indexPath.row].text == nil){
            
            cell.post.text = ""
            cell.postImage.isHidden = false
            cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
            
            let picture = posts[indexPath.row].picture
            
            let url = URL(string:picture!)
            cell.postImage.layer.cornerRadius = 10
            cell.postImage.clipsToBounds = true
            cell.postImage!.sd_setImage(with: url, placeholderImage: UIImage(named:"menu")!)
            
        }else if(posts[indexPath.row].text != nil && posts[indexPath.row].picture == nil){
            
            cell.postImage.isHidden = true
            cell.imageViewHeightConstraint.constant = 0
            
            let post = posts[indexPath.row].text
            
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
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! socialCell
//        
//        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.didTapMediaInPost(_:)))
//        cell.postImage.addGestureRecognizer(imageTap)
//        
//        cell.name.text = posts[indexPath.row].name
//        
//        let timestamp = posts[indexPath.row].timestamp
//        let dateTimeStamp = Date(timeIntervalSince1970: Double(timestamp!)!)
//        cell.time.text = dateTimeStamp.shortTimeAgoSinceNow
//        
////        let dateFormatter = DateFormatter()
////        dateFormatter.timeZone = NSTimeZone.local //Edit
////        dateFormatter.dateFormat = "yyyy-MM-dd"
////        dateFormatter.dateStyle = .full
////        dateFormatter.timeStyle = .short
////    
////        let strDateSelect = dateFormatter.string(from: dateTimeStamp as Date)
////        print(strDateSelect) //Local time
//        
//        let pic = posts[indexPath.row].image
//        let url = URL(string:pic!)
//        cell.profilePic.layer.cornerRadius =  cell.profilePic.frame.width/2
//        cell.profilePic.clipsToBounds = true
//        cell.profilePic!.sd_setImage(with: url, placeholderImage: UIImage(named:"AddPhoto")!)
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedProfilepic(_:)))
//        cell.profilePic.addGestureRecognizer(tap)
//        cell.profilePic.isUserInteractionEnabled = true
//        cell.profilePic.tag = indexPath.row
//        
//        if(posts[indexPath.row].picture != nil && posts[indexPath.row].text != nil){
//            
//            cell.postImage.isHidden = false
//            cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
//            
//            
//            let picture = posts[indexPath.row].picture
//            
//            let url = URL(string:picture!)
//            cell.postImage.layer.cornerRadius = 10
//            cell.postImage.clipsToBounds = true
//            cell.postImage!.sd_setImage(with: url, placeholderImage: UIImage(named:"menu")!)
//            
//            let post = posts[indexPath.row].text
//            
//            cell.post.text = post
//            cell.post.numberOfLines = 0
//            cell.post.lineBreakMode = NSLineBreakMode.byWordWrapping
//            cell.post.sizeToFit()
//        }
//        else if(posts[indexPath.row].picture != nil && posts[indexPath.row].text == nil){
//            
//            cell.post.text = ""
//            cell.postImage.isHidden = false
//            cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
//            
//            let picture = posts[indexPath.row].picture
//            
//            let url = URL(string:picture!)
//            cell.postImage.layer.cornerRadius = 10
//            cell.postImage.clipsToBounds = true
//            cell.postImage!.sd_setImage(with: url, placeholderImage: UIImage(named:"menu")!)
//            
//        }else if(posts[indexPath.row].text != nil && posts[indexPath.row].picture == nil){
//            
//            cell.postImage.isHidden = true
//            cell.imageViewHeightConstraint.constant = 0
//            
//            let post = posts[indexPath.row].text
//            
//            cell.post.text = post
//            cell.post.numberOfLines = 0
//            cell.post.lineBreakMode = NSLineBreakMode.byWordWrapping
//            cell.post.sizeToFit()
//        }else{
//            //...
//        }
//
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//    }

    @IBAction func heroAction(_ sender: Any) {
   
        walkthrough()
    }
    
    func didTapMediaInPost(_ sender:UITapGestureRecognizer)
    {
        let imageView = sender.view as! UIImageView
        let imageInfo   = GSImageInfo(image: imageView.image!, imageMode: .aspectFit)
        let transitionInfo = GSTransitionInfo(fromView: sender.view!)
        let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
    }
    
    func tappedProfilepic(_ sender:UITapGestureRecognizer)
    {
        if let row = sender.view?.tag {
            // use row number
            print("row number is \(row)")
            print(self.posts[row].uid!)
            
            print("hiiii")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchRootViewController") as! SearchRootViewController
            vc.uid = self.posts[row].uid!

            self.navigationController?.pushViewController(vc, animated: true)
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
            self.dismiss(animated: true, completion: nil)
//            self.introductionView?.view.removeFromSuperview()
            self.introductionView = nil;
            //             enter main view , write your code ...
        }
        
    }
    
    func simpleIntroductionView() -> ZWIntroductionViewController {
        let vc = ZWIntroductionViewController(coverImageNames: self.backgroundImageNames)
        return vc!
    }
}
