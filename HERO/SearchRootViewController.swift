//
//  SearchRootViewController.swift
//  HERO
//
//  Created by Amrun on 01/11/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class SearchRootViewController: UIViewController {
    
    var selectedSegment: SJSegmentTab?
    let segmentedViewController = SJSegmentedViewController()
    
    var uid: String?
    var user: User?

    override func viewDidLoad() {

        if uid == nil{
                    self.title = user?.displayName
            
                    Setupsegment()
        }else{
        
            fetchUser()
        }
        
//        self.title = user?.displayName
//        
//        Setupsegment()
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    func Setupsegment() {
        
        let viewController = getSJSegmentedViewController()
        
        if viewController != nil {
            addChildViewController(viewController!)
            self.view.addSubview(viewController!.view)
            viewController!.view.frame = self.view.bounds
            viewController!.didMove(toParentViewController: self)
        }

        
//        if user?.donorORrecipient == "Hero"{
//            
//            let viewController = getSJSegmentedViewController2()
//            
//            if viewController != nil {
//                addChildViewController(viewController!)
//                self.view.addSubview(viewController!.view)
//                viewController!.view.frame = self.view.bounds
//                viewController!.didMove(toParentViewController: self)
//            }
//
//        }else{
//        
//            let viewController = getSJSegmentedViewController()
//            
//            if viewController != nil {
//                addChildViewController(viewController!)
//                self.view.addSubview(viewController!.view)
//                viewController!.view.frame = self.view.bounds
//                viewController!.didMove(toParentViewController: self)
//            }
//
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont(name: "Avenir Medium", size: 20)!]
    }
    
    //MARK:- Private Function
    
    func getSJSegmentedViewController() -> SJSegmentedViewController? {
        
        if let storyboard = self.storyboard {
            
            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "SearchProfileViewController") as! SearchProfileViewController
            headerViewController.user = user
            
            
            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "SearchStoryViewController") as! SearchStoryViewController
            firstViewController.title = "HERO SOCIAL"
            firstViewController.user = user
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "searchMyStoryVC") as! searchMyStoryVC
            secondViewController.title = "MY STORY"
            secondViewController.user = user
            
            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "searchDonorInfoVC") as! searchDonorInfoVC
            thirdViewController.title = "INFO"
            thirdViewController.user = user
            
            
            segmentedViewController.headerViewController = headerViewController
            segmentedViewController.segmentControllers = [firstViewController, secondViewController, thirdViewController]
            segmentedViewController.headerViewHeight = 200
            
            segmentedViewController.selectedSegmentViewColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
            segmentedViewController.segmentTitleColor = UIColor.black
            segmentedViewController.segmentViewHeight = 60.0
            segmentedViewController.selectedSegmentViewHeight = 0.0
            segmentedViewController.segmentShadow = SJShadow.light()
            segmentedViewController.delegate = self
            
            
            return segmentedViewController
        }
        
        return nil
    }

// donor segment
//
//func getSJSegmentedViewController2() -> SJSegmentedViewController? {
//    
//    if let storyboard = self.storyboard {
//        
//        let headerViewController = storyboard
//            .instantiateViewController(withIdentifier: "SearchProfileViewController") as! SearchProfileViewController
//        headerViewController.user = user
//        
//        
//        let firstViewController = storyboard
//            .instantiateViewController(withIdentifier: "SearchStoryViewController") as! SearchStoryViewController
//        firstViewController.title = "HERO SOCIAL"
//        firstViewController.user = user
//        
//        let secondViewController = storyboard
//            .instantiateViewController(withIdentifier: "searchMyStoryVC") as! searchMyStoryVC
//        secondViewController.title = "ABOUT ME"
//        secondViewController.user = user
//        
//        let thirdViewController = storyboard
//            .instantiateViewController(withIdentifier: "searchDonorInfoVC") as! searchDonorInfoVC
//        thirdViewController.title = "INFO"
//        thirdViewController.user = user
//        
//        
//        segmentedViewController.headerViewController = headerViewController
//        segmentedViewController.segmentControllers = [firstViewController, secondViewController, thirdViewController]
//        segmentedViewController.headerViewHeight = 200
//        
//        segmentedViewController.selectedSegmentViewColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
//        segmentedViewController.segmentTitleColor = UIColor.black
//        segmentedViewController.segmentViewHeight = 60.0
//        segmentedViewController.selectedSegmentViewHeight = 0.0
//        segmentedViewController.segmentShadow = SJShadow.light()
//        segmentedViewController.delegate = self
//        
//        
//        return segmentedViewController
//    }
//    
//    return nil
//}

//func getSegmentTabWithImage(_ imageName: String) -> UIView {
//    
//    let view = UIImageView()
//    view.frame.size.width = 100
//    view.image = UIImage(named: imageName)
//    view.contentMode = .scaleAspectFit
//    view.backgroundColor = .white
//    return view
//}
    
    func fetchUser() {
        SVProgressHUD.show()
    FIRDatabase.database().reference().child("users").child(self.uid!).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
        
        guard let dictionary = snapshot.value as? [String: AnyObject] else {
            return
        }
        let users = User(dictionary: dictionary)
        
        self.user = users
        
        self.title = self.user?.displayName
        
        self.Setupsegment()
        SVProgressHUD.dismiss()
        
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                
//                let users = User()
//                users.setValuesForKeys(dictionary)
//                
//                print(users.displayName)
//                self.user = users
//                
//                self.title = self.user?.displayName
//                
//                self.Setupsegment()
//                SVProgressHUD.dismiss()
//
//        }
      }

    }

}

extension SearchRootViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.backgroundColor = UIColor.white
            selectedSegment?.titleColor(.black)
        }
        
        if segmentedViewController.segments.count > 0 {
            
            selectedSegment = segmentedViewController.segments[index]
            selectedSegment?.backgroundColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
            selectedSegment?.titleColor(.white)
        }

}

}

