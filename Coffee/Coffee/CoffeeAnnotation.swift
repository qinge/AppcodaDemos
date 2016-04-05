//
//  CoffeeAnnotation.swift
//  Coffee
//
//  Created by snqu-ios on 16/4/5.
//  Copyright © 2016年 Q. All rights reserved.
//

import Foundation
import MapKit

class CoffeeAnnotation: NSObject, MKAnnotation {
    
    let title:String?
    let subtitle:String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle:String?, coordinate: CLLocationCoordinate2D)
    {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}
