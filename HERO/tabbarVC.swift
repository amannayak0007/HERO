//
//  tabbarVC.swift
//  HERO
//
//  Created by amrun on 15/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit

class tabbarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().tintColor = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        } else {
            // Fallback on earlier versions
        }
        UITabBar.appearance().barTintColor = UIColor.white
    }

}
