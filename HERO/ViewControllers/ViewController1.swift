//
//  ViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 06/10/2016.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import Firebase

class ViewController1: UIViewController {
    
    var selectedSegment: SJSegmentTab?
    
    let segmentedViewController = SJSegmentedViewController()
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    
    var donorvalue: Bool?
    
    override func viewDidLoad() {
        
//        self.setNavigationBarItem()
        
        removeValues()
        
        let viewController = getSJSegmentedViewController()
        if viewController != nil {
            addChildViewController(viewController!)
            self.view.addSubview(viewController!.view)
            viewController!.view.frame = self.view.bounds
            viewController!.didMove(toParentViewController: self)
        }
        
//        isDonor()
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.donor), name: NSNotification.Name(rawValue: "donor"), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.recipient), name: NSNotification.Name(rawValue: "recipient"), object: nil)
    }
    
//    func donor() {
//        let viewController = getSJSegmentedViewController2()
//        
//        if viewController != nil {
//            addChildViewController(viewController!)
//            self.view.addSubview(viewController!.view)
//            viewController!.view.frame = self.view.bounds
//            viewController!.didMove(toParentViewController: self)
//        }
//        
//        self.donorvalue = true
//    }
    
//    func recipient() {
//        let viewController = getSJSegmentedViewController()
//        
//        if viewController != nil {
//            addChildViewController(viewController!)
//            self.view.addSubview(viewController!.view)
//            viewController!.view.frame = self.view.bounds
//            viewController!.didMove(toParentViewController: self)
//        }
//        
//        self.donorvalue = false
//    }
    
    @IBAction func editProfile(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settingsTVC") as! settingsTVC
        vc.donor = self.donorvalue
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func removeValues() {
        donorModel.uid = nil
        donorModel.fullName = nil
        donorModel.userImage = nil
        donorModel.imageURL = nil
        donorModel.birthdate = nil
        donorModel.email = nil
        donorModel.password = nil
        donorModel.phone = nil
        donorModel.gender = nil
        donorModel.donorORrecipient = nil
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    //...
//    }
    
//    func isDonor() {
//        
//        FIRDatabase.database().reference().child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            let dictionary = snapshot.value as? NSDictionary
//            
//            if(dictionary?["donorORrecipient"] as? String == "Hero"){
//                
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "donor"), object: nil)
//                
//            }else{
//                
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "recipient"), object: nil)
//                
//            }
//            
//        })
//
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setNavigationBarItem()
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont(name: "Avenir Medium", size: 20)!]
    }
    
    //MARK:- Private Function
    //MARK:-
    
    func getSJSegmentedViewController() -> SJSegmentedViewController? {
        
        if let storyboard = self.storyboard {
            
            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "HeaderViewController1")

            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "FirstTableViewController")
            firstViewController.title = "HERO SOCIAL"
//            firstViewController.navigationItem.titleView = getSegmentTabWithImage("AddPhoto")
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "MyStoryVC")
            secondViewController.title = "MY STORY"
            
            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "heroInfoVC")
            thirdViewController.title = "INFO"
            
            
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
    
//    func getSJSegmentedViewController2() -> SJSegmentedViewController? {
//        
//        if let storyboard = self.storyboard {
//            
//            let headerViewController = storyboard
//                .instantiateViewController(withIdentifier: "HeaderViewController1")
//            
//            let firstViewController = storyboard
//                .instantiateViewController(withIdentifier: "FirstTableViewController")
//            firstViewController.title = "HERO SOCIAL"
////            firstViewController.navigationItem.titleView = getSegmentTabWithImage("AddPhoto")
//            
//            let secondViewController = storyboard
//                .instantiateViewController(withIdentifier: "MyStoryVC")
//            secondViewController.title = "ABOUT ME"
//            
//            let thirdViewController = storyboard
//                .instantiateViewController(withIdentifier: "heroInfoVC")
//            thirdViewController.title = "INFO"
//            
//            segmentedViewController.headerViewController = headerViewController
//            segmentedViewController.segmentControllers = [firstViewController, secondViewController, thirdViewController]
//            segmentedViewController.headerViewHeight = 200
//            
//            segmentedViewController.selectedSegmentViewColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
//            segmentedViewController.segmentTitleColor = UIColor.black
//            segmentedViewController.segmentViewHeight = 60.0
//            segmentedViewController.selectedSegmentViewHeight = 0.0
//            segmentedViewController.segmentShadow = SJShadow.light()
//            segmentedViewController.delegate = self
//            
//            return segmentedViewController
//        }
//        
//        return nil
//    }
    
//    func getSegmentTabWithImage(_ imageName: String) -> UIView {
//        
//        let view = UIImageView()
//        view.frame.size.width = 100
//        view.image = UIImage(named: imageName)
//        view.contentMode = .scaleAspectFit
//        view.backgroundColor = .white
//        return view
//    }
}

extension ViewController1: SJSegmentedViewControllerDelegate {
    
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

    
//    func didMoveToPage(_ controller: UIViewController, segment: UIButton?, index: Int) {
//        
//        if segmentedViewController.segments.count > 0 {
//           
//            if selectedSegment != nil {
//                selectedSegment?.backgroundColor = UIColor.white
//                selectedSegment?.setTitleColor(UIColor.black, for: .selected)
//            }
//            
//            selectedSegment = segment
//            selectedSegment?.setTitleColor(UIColor.white, for: .selected)
//            selectedSegment?.backgroundColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
//        }
//    }
}
