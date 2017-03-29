//
//  Extensions.swift
//  FirebaseChat
//
//  Created by Colin Horsford on 9/3/16.
//  Copyright © 2016 Paerdegat. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>() //cache bank for all images

extension UIImageView {
    
    //saves the image in cache so it isn't constantly downloaded when scrolling. Check netweork debugger and you'll see how much data you're pulling without it
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        //sets image to nil so that you don't see the image from the reused cell. Makes it blank instead
        self.image = nil
        
        //check cache for image first, then fetch them
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise, download from network
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                //imageCache setObject needs non-optional so cast it here
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}
