//
//  termsVC.swift
//  HERO
//
//  Created by amrun on 30/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit

class termsVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let pdf = Bundle.main.url(forResource: "terms", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = NSURLRequest(url: pdf)
            webView.loadRequest(req as URLRequest)
        }
    }

    @IBAction func dismissVC(_ sender: Any) {
     self.dismiss(animated: true, completion: nil)
    }

}
