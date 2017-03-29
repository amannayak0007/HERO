//
//  heroInfoVC.swift
//  HERO
//
//  Created by amrun on 01/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit
import Firebase

class heroInfoVC: UITableViewController {

    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var ethnicity: UILabel!
    @IBOutlet weak var maritalStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchHeroInfo()
        
        self.tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchHeroInfo), name: NSNotification.Name(rawValue: "updateinfo"), object: nil)
    }

    func fetchHeroInfo() {
        
        SVProgressHUD.show()
        
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).observeSingleEvent(of: .value, with: {(Snapshot) in
            
            SVProgressHUD.dismiss()
            
            let dictionary = Snapshot.value as? NSDictionary
            
            self.height.text = dictionary?["height"] as? String
            self.weight.text = dictionary?["weight"] as? String
            self.bloodType.text = dictionary?["bloodtype"] as? String
            self.ethnicity.text = dictionary?["ethnicity"] as? String
            self.maritalStatus.text = dictionary?["maritalstatus"] as? String
        
//        let diseases = dictionary?["disease"] as? [String]
//        self.maritalStatus.text = diseases?.joined(separator: ", ")
        
            
        }){(error) in
            
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

}
