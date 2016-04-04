//
//  CoffeeAPI.swift
//  Coffee
//
//  Created by qinge on 16/4/5.
//  Copyright © 2016年 Q. All rights reserved.
//

import Foundation
import QuadratTouch
import MapKit
import RealmSwift


struct API {
    struct notifications {
        static let venuesUpdated = "venues updated"
    }
}


class CoffeeAPI {
    
    static let sharedInstance = CoffeeAPI()
    
    var session: Session?
}