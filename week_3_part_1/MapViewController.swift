//
//  MapViewController.swift
//  week_3_part_1
//
//  Created by Lin Yi-Cheng on 2016/4/27.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// Setting the protocol for delegation of getting basic info (latitude and lontitude) of the selecting cell from TableViewController
protocol MapDelegation {
    func giveAddress(map:MapViewController) -> String
    func giveAddressSubtitle(map:MapViewController) -> String
    func giveBikeNumber(map:MapViewController) -> String
    func giveLat(map:MapViewController) -> Double
    func giveLng(map:MapViewController) -> Double
    func giveCellBool(map:MapViewController) -> Bool
    
}


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var TabBarView: UIView!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    
    
//    @IBOutlet weak var SegmentControl: UISegmentedControl!
    
    
    // Set for Current Location
    let locationManger = CLLocationManager()
    
    // 宣告法定代理人之權力
    var delegate1: MapDelegation? = nil
    
    // Setting variables for holding the info from TableViewController
    // variables for StationInfo
    var stAddress: String = "address"
    var stAddressSubtitle: String = "subtitle"
    var stBikeNumber: String = "0"
    
    // variables for map view part
    var locLat : Double = 10.0
    var locLng : Double = 25.0
    var showCell = true
    var myRoute : MKRoute?
    
    // current location
    var cllat =  Double ()
    var cllng = Double ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        
        // Set Navigation Bar title
        navigationItem.title = stAddress
        
        
        // Performing delegation from TabelViewController for getting latitude and longtitude info
        askForCellInfo()
        settingAndShowingMap()
        SetForCurrentLocation()
        FindingDrections()

        
    } // end of func viewDidLoad()
    
    func setTabBar(){
        self.TabBarView.backgroundColor = UIColor.ybkCharcoalGreyColor()
        self.SegmentControl.tintColor = UIColor.ybkPaleGoldColor()
    }
    
    func settingAndShowingMap(){
        if showCell == true {
            /// Cell Info Part to Container
            // Add CellInfoView in storyboard to this controller as subViwController
            let CellInfoView = self.storyboard!.instantiateViewControllerWithIdentifier("CellInfoViewController")
            self.addChildViewController(CellInfoView)
            CellInfoView.view.frame = CGRectMake(0, 64, 600, 122) //content.view.frame = [self frameForContentController];
            CellInfoView.view.backgroundColor = UIColor.ybkPaleColor()
            view.addSubview(CellInfoView.view)
            CellInfoView.didMoveToParentViewController(self)
            
            // CellInfoView Makeup
            // Setting appereance of the table view cell
            
            _ = CellInfoView.view.viewWithTag(1) as! UIImageView
            
            let textLabel2 = CellInfoView.view.viewWithTag(2) as! UILabel
            textLabel2.text = stAddress
            textLabel2.textColor = UIColor.ybkBrownishColor()
            textLabel2.font = UIFont.ybkTextStyle2Font()
            
            let textLabel3 = CellInfoView.view.viewWithTag(3) as! UILabel
            textLabel3.text = stAddressSubtitle
            textLabel3.textColor = UIColor.ybkSandBrownColor()
            textLabel3.font = UIFont.ybkTextStyle3Font()
            
            let textLabel4 = CellInfoView.view.viewWithTag(4) as! UILabel
            textLabel4.text = stBikeNumber
            textLabel4.textColor = UIColor.ybkDarkSalmonColor()
            textLabel4.font = UIFont.ybkTextStyleFont()
            
            let textLabel5 = CellInfoView.view.viewWithTag(5) as! UILabel
            textLabel5.textColor = UIColor.ybkSandBrownColor()
            textLabel5.font = UIFont.ybkTextStyle4Font()
            
            let textLabel6 = CellInfoView.view.viewWithTag(6) as! UILabel
            textLabel6.textColor = UIColor.ybkSandBrownColor()
            textLabel6.font = UIFont.ybkTextStyle4Font()
            
            let viewLine = CellInfoView.view.viewWithTag(8)! as UIView
            viewLine.backgroundColor = UIColor.ybkDarkSandColor()
            
            let viewMapButton = CellInfoView.view.viewWithTag(7) as! UIButton
            viewMapButton.frame = CGRectMake(0, 0, 375, 122)
            viewMapButton.setTitle(NSLocalizedString("看地圖", comment: "see the map button") , forState: UIControlState.Normal)
            viewMapButton.setTitleColor(UIColor.ybkDarkSalmonColor(), forState: UIControlState.Normal)
            viewMapButton.layer.cornerRadius = 4
            viewMapButton.layer.borderWidth = 1
            viewMapButton.layer.borderColor = UIColor.ybkDarkSalmonColor().CGColor
            
            // Setting and showing the map
            let location = CLLocationCoordinate2DMake(locLat, locLng)
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegion(center: location, span: span)
            
            // Draw  the map
            map.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            map.addAnnotation(annotation)
            
        }
        else {
            // Setting and showing the map
            let location = CLLocationCoordinate2DMake(locLat, locLng)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            
            // Draw  the map
            map.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            map.addAnnotation(annotation)
        }
    }
    
    func SetForCurrentLocation(){
        // set for manager
        self.locationManger.delegate = self
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManger.requestWhenInUseAuthorization() // Only use this in app, not background
        self.locationManger.startUpdatingLocation()
        self.map.showsUserLocation = true
    }
    
    func FindingDrections(){
        let maprequest = MKDirectionsRequest()
        maprequest.source = MKMapItem .mapItemForCurrentLocation()
        maprequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: locLat, longitude: locLng), addressDictionary: nil))
        
        maprequest.requestsAlternateRoutes = true
        maprequest.transportType = .Walking
        
        // showing the direction route
        self.map.delegate = self
        let directions = MKDirections(request: maprequest)
        directions.calculateDirectionsWithCompletionHandler() { (response: MKDirectionsResponse?, error: NSError?) in
            guard let response = response else{
                print(error); return}
            let route = response.routes[0]
            let poly = route.polyline
            self.map.addOverlay(poly)
            for step in route.steps{
                print("After \(step.distance) metres: \(step.instructions)")
            }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        print("did--------------------------")
        if let overlay = overlay as? MKPolyline {
            let v = MKPolylineRenderer(polyline: overlay)
            v.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.8)
            v.lineWidth = 4
            return v
            print("did")
        }
        return MKOverlayRenderer()
    }
    
    
    /// Other functions-------------------
    
    // Ask for performing delegation from TabelViewController for giving latitude info
    func askForCellInfo() -> AnyObject{
        if (delegate1 != nil){
            
            stAddress = (delegate1!.giveAddress(self))
            stAddressSubtitle = (delegate1!.giveAddressSubtitle(self))
            stBikeNumber = (delegate1!.giveBikeNumber(self))
            locLat  = (delegate1!.giveLat(self))
            locLng  = (delegate1!.giveLng(self))
            showCell = (delegate1!.giveCellBool(self))
            return locLat
        }
        return locLat
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.map.setRegion(region, animated: true)
        self.locationManger.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    @IBAction func SegmentControlWasPressed(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.map.mapType = .Standard
        case 1:
            self.map.mapType = .Satellite
        default:
            self.map.mapType = .Hybrid
        }
        
    }
    
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */




/*-----Usable Code
 
 
 self.view.bounds.width
 self.view.bounds.height
 
 let mapViewCtrl = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
 
 mapViewCtrl.setStationInfo(station, isShowStationCell: isShowStationCell)
 
 self.navigationController!.pushViewController(mapViewCtrl, animated: true)
 
 */
