//
//  StoryTableViewCell.swift
//  HERO
//
//  Created by Amrun on 25/10/16.
//  Copyright © 2016 Digital Hole. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
