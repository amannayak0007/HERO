//
//  favoritesVC.swift
//  HERO
//
//  Created by amrun on 03/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit

class favoritesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Favorites"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont(name: "Avenir Medium", size: 20)!]
        
    }


}
