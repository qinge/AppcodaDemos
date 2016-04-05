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
    
    
    init(){
        let client = Client(clientID: "UUQMAAIXQ2DIT52PFABIQDPYKJW3FDTPAGSNBS3ZNE0XMKHN", clientSecret: "GCVBK5KWJN0A1VHYILS3NKESBDLB2ORPCJOQ2ANLOFK2EFHE", redirectURL: "")
        
        let configuration = Configuration(client: client)
        Session.setupSharedSessionWithConfiguration(configuration)
        self.session = Session.sharedSession()
    }
    
    func getCoffeeShopsWithLocation(location: CLLocation) {
        if let session = self.session {
            var parameters = location.parameters()
            // 這個字符串是 Foursquare 中的類別 ID，表示「Coffeeshops」的意思
            parameters += [Parameter.categoryId : "4bf58dd8d48988d1e0931735"]
            parameters += [Parameter.radius : "2000"]
            parameters += [Parameter.limit : "50"]
            
            // 開始搜索，即異步調用 Foursquare，並返回地標數據
            // venue:发生地
            let searchTask = session.venues.search(parameters, completionHandler: {
                (result) -> Void in
                
                if let response = result.response {
                    if let venues = response["venues"] as? [[String : AnyObject]] {
                        autoreleasepool{
                            let realm = try! Realm()
                            realm.beginWrite()
                            
                            for venue: [String : AnyObject] in venues {
                                let venueObject: Venue = Venue()
                                
                                if let id = venue["id"] as? String {
                                    venueObject.id = id
                                }
                                
                                if let name = venue["name"] as? String {
                                    venueObject.name = name
                                }
                                
                                if let location = venue["location"] as? [String : AnyObject]{
                                    if let longitude = location["lng"] as? Float {
                                        venueObject.longitude = longitude
                                    }
                                    
                                    if let latitude = location["lat"] as? Float
                                    {
                                        venueObject.latitude = latitude
                                    }
                                    
                                    if let formattedAddress = location["formattedAddress"] as? [String]
                                    {
                                        venueObject.address = formattedAddress.joinWithSeparator(" ")
                                    }
                                }
                                
                                realm.add(venueObject, update: true)
                            }
                            
                            do {
                                try realm.commitWrite()
                                print("Comitting write ...")
                            }catch(let e){
                                print("Y U NO REALM ? \(e)")
                            }
                        }
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(API.notifications.venuesUpdated, object: nil)
                    }
                }
                
                
                print("result = \(result)")
                
            })
            searchTask.start()
        }
    }
    
}


extension CLLocation {
    
    func parameters() -> Parameters {
        let ll = "\(self.coordinate.latitude), \(self.coordinate.longitude)"
        // Accuracy: 精确度
        let llAcc = "\(self.horizontalAccuracy)"
        // altitude: 高度
        let alt = "\(self.altitude)"
        let altAcc = "\(self.verticalAccuracy)"
        
        let parameters = [
            Parameter.ll : ll,
            Parameter.llAcc : llAcc,
            Parameter.alt : alt,
            Parameter.altAcc : altAcc
        ]
        return parameters
    }
    
}