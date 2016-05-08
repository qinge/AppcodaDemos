//
//  ViewController.swift
//  Coffee
//
//  Created by qinge on 16/4/4.
//  Copyright © 2016年 Q. All rights reserved.
//
//  http://www.appcoda.com.tw/foursquare-realm-swift/
//  https://foursquare.com/developers/app/UUQMAAIXQ2DIT52PFABIQDPYKJW3FDTPAGSNBS3ZNE0XMKHN
//  http://www.appcoda.com/foursquare-realm-swift/




import UIKit
import MapKit

import RealmSwift

class ViewController: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager?
    let distanceSpan:Double = 500
    
    var lastLocation: CLLocation?
    // 声明时候需要指定泛型参数类型
//    var venues: Results<Venue>?
    var venues: [Venue]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onVenuesUpdated:"), name: API.notifications.venuesUpdated, object: nil)
    }
    
    func onVenuesUpdated(notification:NSNotification)
    {
        refreshVenues(nil)
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
        
        refreshVenues(newLocation, getDataFromFoursquare: true)
    }
    
    
    func refreshVenues(location: CLLocation?, getDataFromFoursquare: Bool = false){
        if location != nil {
            lastLocation = location
        }
        
        if let location = lastLocation {
            if getDataFromFoursquare == true {
                CoffeeAPI.sharedInstance.getCoffeeShopsWithLocation(location)
            }
            
//            let realm = try! Realm()
//            venues = realm.objects(Venue)
            let (start, stop) = calculateCoordinatesWithRegion(location)
            let predicate = NSPredicate(format: "latitude < %f AND latitude > %f AND longitude > %f AND longitude < %f", start.latitude, stop.latitude, start.longitude, stop.longitude)
            let realm = try! Realm()
            venues = realm.objects(Venue).filter(predicate).sort({ (v0, v1) -> Bool in
                return location.distanceFromLocation(v0.coordinate) < location.distanceFromLocation(v1.coordinate)
            })
            
            for venue in venues! {
                let annotation = CoffeeAnnotation(title: venue.name, subtitle: venue.address, coordinate: CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)))
                mapView.addAnnotation(annotation)
            }
            tableView.reloadData()
        }
    }
    
    
    /**
     通過簡單的計算，基於 distanceSpan，將一個 CLLocation 對象轉換成一個左上角和右下角座標。
     
     - parameter location: location
     
     - returns: point
     */
    func calculateCoordinatesWithRegion(location: CLLocation) -> (CLLocationCoordinate2D, CLLocationCoordinate2D) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distanceSpan, distanceSpan)
        
        var start: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var stop: CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        start.latitude  = region.center.latitude  + (region.span.latitudeDelta  / 2.0)
        start.longitude = region.center.longitude - (region.span.longitudeDelta / 2.0)
        stop.latitude   = region.center.latitude  - (region.span.latitudeDelta  / 2.0)
        stop.longitude  = region.center.longitude + (region.span.longitudeDelta / 2.0)
        
        return (start, stop)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("annotationIdentifier")
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationIdentifier")
        }
        // callout: 插图
        view?.canShowCallout = true
        return view
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return venues?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("cellIdentifier");
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellIdentifier")
        }
        
        if let venue = venues?[indexPath.row]
        {
            cell!.textLabel?.text = venue.name
            cell!.detailTextLabel?.text = venue.address
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let venue = venues?[indexPath.row]
        {
            let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: Double(venue.latitude), longitude: Double(venue.longitude)), distanceSpan, distanceSpan)
            mapView?.setRegion(region, animated: true)
        }
    }
    
    
}

