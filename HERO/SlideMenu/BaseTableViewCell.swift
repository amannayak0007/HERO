//
//  BaseTableViewCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/22/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//
import UIKit

open class BaseTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    open override func awakeFromNib() {
    }

    
    open class func height() -> CGFloat {
        return 50
    }
    
    open func setData(_ data: Any?) {
        self.backgroundColor = UIColor.clear
        self.textLabel?.font = UIFont(name: "Avenir Book", size:20)
        self.textLabel?.textColor = UIColor.white
        self.textLabel?.textAlignment = .center
        //        cell.textLabel.textAlignment = NSTextAlignmentCenter;

        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
    }
    
    open override func layoutSubviews() {
        self.textLabel?.frame = CGRect(x: 0, y: (self.textLabel?.frame.origin.y)!, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
  
}
