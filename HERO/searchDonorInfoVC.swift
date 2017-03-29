//
//  searchDonorVC.swift
//  HERO
//
//  Created by amrun on 01/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit

class searchDonorInfoVC: UITableViewController {
    
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var ethnicity: UILabel!
    @IBOutlet weak var maritalStatus: UILabel!

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        
        ShowData()
        
    }

    func ShowData() {
        
        //table data
        
        self.height.text = user?.height
        self.weight.text = user?.weight
        self.bloodType.text = user?.bloodtype
        self.ethnicity.text = user?.ethnicity
        self.maritalStatus.text = user?.maritalstatus
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
