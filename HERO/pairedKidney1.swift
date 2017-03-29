//
//  pairedKidney1.swift
//  HERO
//
//  Created by amrun on 24/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit

class pairedKidney1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Paired Kidney Exchange"
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    @IBAction func yesPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            SVProgressHUD.dismiss()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pairedKidney2") as! pairedKidney2
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func noPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            SVProgressHUD.dismiss()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabbarVC") as! tabbarVC
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        }
    }
    
}
