//
//  UserCell.swift
//  FirebaseChat
//
//  Created by Colin Horsford on 9/3/16.
//  Copyright © 2016 Paerdegat. All rights reserved.
//

import UIKit
import Firebase

//creates a custom cell type that has the subtitle. Make sure to register it up top
class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            
            //convert and format date
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a" //google different format
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
        }
    }
    
    fileprivate func setupNameAndProfileImage() {
             
        if let id = message?.chatPartnerId() {
            
            let ref = FIRDatabase.database().reference().child("users").child(id)
            ref.observe(.value, with: { (snapshot) in
                
                //prints out name of recipient
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["displayName"] as? String
                    
                    //show recipient profile pic next to their message
                    if let profileImageUrl = dictionary["image"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl) //cast "cell" down to as! UserCell
                    }
                    else{
                    self.profileImageView.image = UIImage(named: "default-profile")
                    }
                }
                
                
                }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //moves username and email detail over
        //56 means 8 on each side and 40
        textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y+2, width: self.frame.size.width - 150, height: detailTextLabel!.frame.height) // +/-2 adds spacing between the two labels
    }
    
    //fixes inconsistent profile pic saving
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "default-profile") //set default image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30 //should match half of height/width anchor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
        }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        //label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        //ios 9 contraints anchors
        //need x, y, width, height anchors
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //time label constraints
        //x,y,w,h
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 30).isActive = true
        timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
