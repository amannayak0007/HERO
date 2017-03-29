//
//  AutoCompleteCell.swift
//  Autocomplete
//
//  Created by Amir Rezvani on 3/6/16.
//  Copyright © 2016 cjcoaxapps. All rights reserved.
//

import UIKit
import SDWebImage

open class AutoCompleteCell: UITableViewCell {
    //MARK: - outlets
    @IBOutlet fileprivate weak var lblTitle: UILabel!
    @IBOutlet fileprivate weak var imgIcon: UIImageView!

    //MARK: - public properties
    open var textImage: AutocompleteCellData? {
        didSet {
            self.lblTitle.text = textImage!.text
            
            let url = URL(string:textImage!.image!)
            self.imgIcon.layer.cornerRadius = self.imgIcon.frame.size.width/2
            self.imgIcon.clipsToBounds = true
            self.imgIcon.sd_setImage(with: url, placeholderImage: nil)
        }
    }
}
