//
//  ViewController.swift
//  Coffee
//
//  Created by qinge on 16/4/4.
//  Copyright © 2016年 Q. All rights reserved.
//
//  http://www.appcoda.com.tw/foursquare-realm-swift/
//  https://foursquare.com/developers/app/UUQMAAIXQ2DIT52PFABIQDPYKJW3FDTPAGSNBS3ZNE0XMKHN



import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager?
    let distanceSpan:Double = 500
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            // 向用户提出使用gps 请求
            locationManager?.requestAlwaysAuthorization()
            // Don't send location updates with a distance smaller than 50 meters between them
            locationManager?.distanceFilter = 50
            locationManager?.startUpdatingLocation()
        }
    }


    // MARK: -  MKMapViewDelegate
    
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceSpan, distanceSpan)
        mapView.setRegion(region, animated: true)
    }
    
}

