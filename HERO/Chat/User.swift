//
//  User.swift
//  FirebaseChat
//
//  Created by Colin Horsford on 9/2/16.
//  Copyright © 2016 Paerdegat. All rights reserved.
//

import UIKit

class User: NSObject {

    var id: String?
    var displayName: String?
    var email: String?
    var password: String?
    var image: String?
    var Gender: String?
    var DOB: String?
    var createdAt: NSNumber?
    var Organ: String?
    var Phone: String?
    var State: String?
    var City: String?
    var Amount: String?
    var CampaignTitle: String?
    var CampPeriod: String?
    var uid: String?
    var social: String?
    var donorORrecipient: String?
    var height: String?
    var weight: String?
    var BMI: String?
    var bloodtype: String?
    var ethnicity: String?
    var maritalstatus: String?
    var smoke: String?
    var drink: String?
    var drug: String?
    var drugName: String?
    var story: String?
    var latitude: AnyObject?
    var longitude: AnyObject?
    var pairedUID: String?
    var notiToken: String?
    var disease = [NSMutableArray]()
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
//        id = dictionary["id"] as? String
        displayName = dictionary["displayName"] as? String
        email = dictionary["email"] as? String
//        password = dictionary["password"] as? String
        image = dictionary["image"] as? String
        Gender = dictionary["Gender"] as? String
        DOB = dictionary["DOB"] as? String
        createdAt = dictionary["createdAt"] as? NSNumber
        Organ = dictionary["Organ"] as? String
        Phone = dictionary["Phone"] as? String
        State = dictionary["State"] as? String
        City = dictionary["City"] as? String
//        Amount = dictionary["Amount"] as? String
//        CampaignTitle = dictionary["CampaignTitle"] as? String
//        CampPeriod = dictionary["CampPeriod"] as? String
        uid = dictionary["uid"] as? String
//        social = dictionary["social"] as? String
        donorORrecipient = dictionary["donorORrecipient"] as? String
        height = dictionary["height"] as? String
        weight = dictionary["weight"] as? String
//        BMI = dictionary["BMI"] as? String
        bloodtype = dictionary["bloodtype"] as? String
        ethnicity = dictionary["ethnicity"] as? String
        maritalstatus = dictionary["maritalstatus"] as? String
        smoke = dictionary["smoke"] as? String
        drink = dictionary["drink"] as? String
        drug = dictionary["drug"] as? String
        drugName = dictionary["drugName"] as? String
        story = dictionary["story"] as? String
        latitude = dictionary["latitude"] as? AnyObject
        longitude = dictionary["longitude"] as? AnyObject
        pairedUID = dictionary["pairedUID"] as? String
        notiToken = dictionary["notiToken"] as? String
//        disease = dictionary["disease"] as? [NSMutableArray]()
    }
    
}
