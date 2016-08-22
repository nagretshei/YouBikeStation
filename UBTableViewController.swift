//
//  UBTableViewController.swift
//  week_3_part_1
//
//  Created by Lin Yi-Cheng on 2016/4/25.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit
import CoreData
import FZURefresh



class UBTableViewController: UITableViewController, CellDelegation, MapDelegation, StationJsonDataDelegate, NSFetchedResultsControllerDelegate {
    //宣告符合法定權力
    
    //        JsonObject.instance.address
    
    
    var x = 1
    //create Station Objcet
    let Station = YouBikeManager.instance
    
    // Setting empty array for indivual data
    var imageArray = [String]()
    var addressArray = [String]()
    var addressSubtitleArray = [String]()
    var bikeNumber = [String]()
    var latitudeArray = [Double]()
    var longitudeArray = [Double]()
    
    // Setting empty array for indivual data of selected cell
    var theLatitude = Double()
    var theLongtitude = Double()
    var theAddress = String()
    var theAddressSubtitle = String()
    var theBikeNumber = String()
    var showCell = true
    
    
    //create Map View Object
    let googleMap = MapViewController()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()


        //Create and get station data from Json file
        self.Station.sendAGetRequestToServer()
        self.Station.sendAPostRequestToServer(["latitude": 123.0, "longitude": 567.0])

        
        //self.Station.sendAGetRequestToServer()
        Station.JsonDelegate = self
        
        
        // Loading all the data into empty arrays of individual data
        self.addressArray = Station.address
        self.addressSubtitleArray = Station.addressSubtitle
        self.bikeNumber = Station.bikeNumber
        self.imageArray = Station.image
        self.latitudeArray = Station.latitude
        self.longitudeArray = Station.longitude
        self.navigationItem.title = "Youbike"
        //print(Station.address)
        

    }
    
    func setStationVariables(){
        // Loading all the data into empty arrays of individual data
        print("3-1")
        self.addressArray = Station.address
        self.addressSubtitleArray = Station.addressSubtitle
        self.bikeNumber = Station.bikeNumber
        self.imageArray = Station.image
        self.latitudeArray = Station.latitude
        self.longitudeArray = Station.longitude
        self.navigationItem.title = "Youbike"
        //print(Station.address)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.toRefresh {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                self.tableView.doneRefresh()
            });
        }
        self.tableView.toLoadMore {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                self.Station.getFollowingPageData()
                self.tableView.reloadData()
                self.tableView.doneRefresh()
            });
        }
    }
    

    

//    override func viewWillAppear(animated: Bool) {
//    }
//
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        Station.JsonDelegate = self
//        self.Station.sendAGetRequestToServer()
//        
//        setStationVariables()
//        
//        
//        let completionHandler: () -> Void = { [unowned self] in
//            
//            self.tableView.reloadData()
//            
//        }
//    
////        Station.sendAGetRequestToServerWithCompletion(completionHandler)
//    }
////
//
//        
//        // Advance.
//        
//        //        stationModel.getYoubikeDataFromServerWithCompletionHandler({ [unowned self] in
//        //
//        //            self.tableView.reloadData()
//        //
//        //        })
//        
//    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    
    
    // Creating Table View 
    // counting for cell number of the table view
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("***** count")
        print(self.addressArray.count)
        return addressArray.count
    }
    
   // writing for each cell of the table view
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Returns a reusable table-view cell object located by its identifier.
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UBTableViewCell!
        
        // Puting indivual info into each cell
        let address = cell.viewWithTag(2) as! UILabel
        address.text = addressArray[indexPath.row]
        
        let addressSubtitle = cell.viewWithTag(3) as! UILabel
        addressSubtitle.text = addressSubtitleArray[indexPath.row]
        
        let bikeNumberLeft = cell.viewWithTag(4) as! UILabel
        bikeNumberLeft.text = bikeNumber[indexPath.row]
        
        
        // Getting latitude and lontitude of station info  from
        // conform the delegation to the tableViewCell of the ViewMap Button
        cell.delegate = self  // 確認對cell的法定權力，如此 cell 才能委託自己執行權力
        
        // Saving lat and lng  and other info for selecting Cell
        cell.lat = latitudeArray[indexPath.row]
        cell.lng = longitudeArray[indexPath.row]
        cell.address = addressArray[indexPath.row]
        cell.addressSubtitle = addressSubtitleArray[indexPath.row]
        cell.bikeNumber = bikeNumber [indexPath.row]
       
        // Triggering the work of table view
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("mapView") as! MapViewController
        VC1.delegate1 = self
        self.navigationController!.pushViewController(VC1, animated: true)
    }
    
    /// delegat for JsonFromURL.swift
    func dataDidFinishFetching(cell: YouBikeManager, sender: AnyObject?){
        dispatch_async(dispatch_get_main_queue(),{
            // update some UI
            self.setStationVariables()
            self.tableView.reloadData()
            
        })
        
    }
    
    /// Following is all the work for getting map View ready
    // Perform the delegation to the tableViewCell of the ViewMap Button
    func cell(cell: UBTableViewCell, viewMap sender: AnyObject?){
        theLatitude = cell.lat
        theLongtitude = cell.lng
        theAddress = cell.address
        theAddressSubtitle = cell.addressSubtitle
        theBikeNumber = cell.bikeNumber
        showCell = false
        cell.showCell = false
        googleMap
        
    }
    
    // Perform the delegation to the tableViewCell of the set selected function
    func cellSelector(cell: UBTableViewCell, sender: AnyObject?){
        theLatitude = cell.lat
        theLongtitude = cell.lng
        theAddress = cell.address
        theAddressSubtitle = cell.addressSubtitle
        theBikeNumber = cell.bikeNumber
        showCell = true
        cell.showCell = true
        googleMap
    
    }
    
    /// Following are Perform the delegation to the MapViewController
    // Sending Saved Address info for selecting cell to MapView Controller
    func giveAddress(map:MapViewController)  -> String{
        googleMap.stAddress = theAddress
        return googleMap.stAddress
    }
    
    // Sending Saved Address Subtitle info for selecting cell to MapView Controller
    func giveAddressSubtitle(map:MapViewController)  -> String{
        googleMap.stAddressSubtitle = theAddressSubtitle
        return googleMap.stAddressSubtitle
    }
    
    // Sending Saved BikeNumber info for selecting cell to MapView Controller
    func giveBikeNumber(map:MapViewController)  -> String{
        googleMap.stBikeNumber = theBikeNumber
        return googleMap.stBikeNumber
    }
    
    
    // Sending Saved latitute info for selecting cell to MapView Controller
    func giveLat(map:MapViewController)  -> Double{
        googleMap.locLat = theLatitude
        return googleMap.locLat
    }
    // Sending Saved langitute info for selecting cell to MapView Controller
    func giveLng(map:MapViewController) -> Double {
        googleMap.locLng = theLongtitude
        return  googleMap.locLng
        
    }
    
    // Sending Saved showCell Bool for selecting cell to MapView Controller
    func giveCellBool(map:MapViewController) -> Bool {
        googleMap.showCell = showCell
        return  googleMap.showCell
        
    }
    
    
    // Before pushing, need to save TableViewController between segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapsegue" {
            let secondVC: MapViewController = segue.destinationViewController as! MapViewController
            secondVC.delegate1 = self // 確認對 mapView 的法定權力，如此 mapView 才能委託自己執行權力
            
        }
    }
    
}






/* Other suggesting fuctions --------------------------------

 
 // Override to support conditional editing of the table view.
 override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
 if editingStyle == .Delete {
 // Delete the row from the data source
 tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
 } else if editingStyle == .Insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


