//
//  RootViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Amrun on 20/10/16.
//  Copyright © 2016 Yuji Hato. All rights reserved.
//

import UIKit

class RootViewController: SlideMenuController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "socialNavi") {
            self.mainViewController = controller
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LeftViewController") {
            self.leftViewController = controller
        }
        super.awakeFromNib()
    }
    
    
}
