//
//  posts.swift
//  HERO
//
//  Created by amrun on 19/03/17.
//  Copyright © 2017 Digital Hole. All rights reserved.
//

import UIKit

class Posts: NSObject {

    var key: String?
    var image: String?
    var name: String?
    var picture: String?
    var text: String?
    var timestamp: String?
    var uid: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        key = dictionary["key"] as? String
        image = dictionary["image"] as? String
        name = dictionary["name"] as? String
        picture = dictionary["picture"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? String
        uid = dictionary["uid"] as? String
    }
}
