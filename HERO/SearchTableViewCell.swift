//
//  SearchTableViewCell.swift
//  HERO
//
//  Created by Amrun on 19/10/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var AboutUS: UILabel!
    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var bloodType: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var PKEimage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.width/2
        self.ProfileImage.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
