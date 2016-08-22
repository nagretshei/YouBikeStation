//
//  week_4.swift
//  week_3_part_1
//
//  Created by Lin Yi-Cheng on 2016/5/2.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import Foundation
import Alamofire
import JWT
import CoreData

protocol StationJsonDataDelegate {
    func dataDidFinishFetching(cell: YouBikeManager, sender: AnyObject?)
}

// class Station {} or stuct Station
class Station: NSManagedObject {
    @NSManaged var address: String
    @NSManaged var addressSubtitle: String
    @NSManaged var addressEn: String
    @NSManaged var addressSubtitleEn: String
    @NSManaged var bikeNumber: String
    @NSManaged var locationLat: Double
    @NSManaged var locationLng: Double
    @NSManaged var id: String
}


extension YouBikeManager {
    func getFollowingPageData(){
        if pagingURL != nextURL {
            pagingURL = nextURL
            self.sendAGetRequestToServer()
            
        } else if nextURL == pagingURL {
            print("equal")
            //next = false
        }
        
    }
    
}

class YouBikeManager {
    static let instance = YouBikeManager()
    
    // set var Stations for CoreData
    var station: Station!
    var stations: [Station] = []
    //var CStationsInfo = [AnyObject]()
    
    // Set individaul info of the Station data
    var address = [String]()
    var addressSubtitle = [String]()
    var bikeNumber = [String]()
    var image = [String]()
    var latitude = [Double]()
    var longitude = [Double]()
    let id: String
    var jsonUrlFirstPart = "http://52.34.47.148/v2/stations?paging="
    var pagingURL = "febe5ekd32dkl923jkdlde"
    var nextURL = String()
    var next = true
    
    var JsonDelegate: StationJsonDataDelegate? = nil //宣告法定代理人之權力
    
    init(){
        
        self.id = NSUUID().UUIDString
    }
    
    //// Set JWT Code
    func SetJWTCode() -> String {
        //The payload of a token should contain your "name" and 5 mininutes expiration time.
        //Encrypt it using "HS256" with the secret key "appworks".
        
        let code = JWT.encode(.HS256("appworks")) { builder in
            builder.issuer = "Zoe"
            builder.expiration = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: 5, toDate: NSDate(), options: [])
            
        }
        return code
    }
    
    
    func cleanUpCoreData() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let request = NSFetchRequest(entityName: "Station")
            do {
                let results = try managedObjectContext.executeFetchRequest(request) as! [Station]
                for result in results {
                    managedObjectContext.deleteObject(result)
                }
                do {
                    try managedObjectContext.save()
                }catch{
                    fatalError("Failure to save context: \(error)")
                }
            }catch{
                fatalError("Failed to fetch data: \(error)")
            }
        }
    }
    
    func sendAGetRequestToServer(){
        //print(4)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // request Json file from internet
            let code = self.SetJWTCode()
            //print (code) "http://139.162.32.152:3000/stations"
           // print(code) "http://139.162.32.152:3000/stations?paging=febe5ekd32dkl923jkdlde"
            var url = (self.jsonUrlFirstPart + self.pagingURL)
            print(url)
            
            Alamofire.request(.GET,url,headers: ["Authorization": "Bearer \(code)"])
                
                .validate()
                .responseJSON {response in
                    switch response.result {
                    case .Success:
                        //print("Validation Successful")
                        if let dictionary = response.result.value{
                            print("get JSON data online sucessfull")
                            self.getStationFromJson(dictionary)
                            
                            //self.self.getFollowingPageData()

                        } else{
                            print("get data from CoreData")
                            //self.getDataFromCoreData()
                            self.getStationInfoFromCoreData()
                            
                        }
                        
                    case .Failure(let error):
                        print("get data from CoreData offline")
                                            }
            }
        }  //end of dispatch
    } // end of func getJSonFromInternet()
    
    //request "post" Json file from internet
    func sendAPostRequestToServer(params : Dictionary<String, Double>){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // request Json file from internet
            //forHTTPHeaderField: "Content-Type")
            let code = self.SetJWTCode()
            //print (code)
            Alamofire.request(.POST, "http://139.162.32.152:3000/check_in", parameters: params, encoding: .JSON, headers: ["Authorization": "Bearer \(code)"])
                .validate()
                .responseJSON {response in
                    switch response.result {
                    case .Success:
                        print("Validation Successful for posting")
                        self.self.getFollowingPageData()
                        //print(response.response)
                        
                    case .Failure(let error):
                        print(error)
                    }// end of switch
                    
            }// end of responseJSON closure
            
            
        }  //end of dispatch
    } // end of func getJSonFromInternet()
    
    
    
    func getStationFromJson(object: AnyObject) -> AnyObject? {
        // removing the outside and middle side of info in JSon
        if let dataOB = object as? AnyObject {
            let results = dataOB["data"] as! [AnyObject]
            if dataOB["paging"] != nil {
                let paging = dataOB["paging"] as! [String: String]
                if paging["next"] != nil {
                    nextURL = paging["next"]!
                } else if paging["next"] == nil {
                    next = true
                }
            }
            
            // abstracting individual info from Json we need
            getInfo(results)
            //addDataIntoCoreData()
            return results
        }
        else {return nil}
        
    } // end of fuct getStationFromJson()
    
    // Following are fuctions for getting indivual station data
    func getInfo(results: [AnyObject]) {
        cleanUpCoreData()
        for eachCellData in results {
            if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                station = NSEntityDescription.insertNewObjectForEntityForName("Station", inManagedObjectContext: managedObjectContext) as! Station
                
                let dist = eachCellData["sareaen"] as! String
                let exit = eachCellData["snaen"] as! String
                address.append(String(dist + " / " + exit))
                station.address = String(dist + " / " + exit)
                
                let subtitle = eachCellData["aren"] as! String
                addressSubtitle.append(String(subtitle))
                station.addressSubtitle = String(subtitle)
                
                image.append("iconMarker")
                
                let bikeNum = eachCellData["sbi"] as! String
                bikeNumber.append(String(bikeNum))
                station.bikeNumber = bikeNum
                
                let eachLat = eachCellData["lat"] as! String
                latitude.append(Double(eachLat)!)
                station.locationLat = Double(eachLat)!
                
                let eachLng = eachCellData["lng"] as! String
                longitude.append(Double(eachLng)!)
                station.locationLng = Double(eachLng)!
                
                // support languages
                let userLanguage = NSLocale.preferredLanguages()[0]
                if userLanguage.containsString("zh"){
                    let dist = eachCellData["sarea"] as! String
                    let exit = eachCellData["sna"] as! String
                    address.append(String(dist + " / " + exit))
                    station.addressEn = String(dist + " / " + exit)
                    let subtitle = eachCellData["ar"] as! String
                    addressSubtitle.append(String(subtitle))
                    station.addressSubtitleEn = String(subtitle)
                }
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                    return
                }
                
            }
            
        }
        // 執行 dispatch
        self.JsonDelegate!.dataDidFinishFetching(self, sender: self)

    }
    
    func getStationInfoFromCoreData() {
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let fetchRequest = NSFetchRequest(entityName: "Station")
            do {
                stations = try
                    managedObjectContext.executeFetchRequest(fetchRequest) as! [Station]
                for eachCellData in stations {
                    
                    address.append(eachCellData.address)
                    addressSubtitle.append(eachCellData.addressSubtitle)
                    image.append("iconMarker")
                    bikeNumber.append(eachCellData.bikeNumber)
                    latitude.append(eachCellData.locationLat)
                    longitude.append(eachCellData.locationLng)
                    
                    // support languages
                    let userLanguage = NSLocale.preferredLanguages()[0]
                    if userLanguage.containsString("zh"){
                        address.append(eachCellData.addressEn)
                        addressSubtitle.append(eachCellData.addressSubtitleEn)
                    }
                }

            } catch {
                print("cannot get data from CoreData")
            }
            
        }
        self.JsonDelegate!.dataDidFinishFetching(self, sender: self)
    }
    //    func cleanUpStations() {station = []} // 清除記憶體之用
    
} //end of class JsonOb



//-----
//    func sendAGetRequestToServer(){
//        print(4)
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            // do some task
//
//            // request Json file from internet
//            //            let tableView = UBTableViewController()
//            let request = NSMutableURLRequest(URL: NSURL(string: "http://139.162.32.152:3000/youbikes")!)
//            let session = NSURLSession.sharedSession()
//            let task = session.dataTaskWithRequest(request){ (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//                if error != nil {
//                    print(error!.description)
//
//                    return
//                }
//                else {
//                    if let httpResponse = response as? NSHTTPURLResponse {
//                        if httpResponse.statusCode == 200 {
//                            do {
//                                let dataObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
//                                if let dictionary = dataObject as? [String: AnyObject]  {
//                                    self.getStationFromJson(dictionary)
//
//                                }
//                            }
//                            catch {
//                                // Handle Error
//                                print(error)
//                            }
//                        } // end of if statusCode == 200
//                    } // end of if let httpResponse
//                } // end of else
//
//            } // end of tack closure
//
//            task.resume()
//        } // end of dispatch
//
//    } // end of func getJSonFromInternet()


//___________________________



//    typealias CompletionHandler = () -> Void
//
//    func sendAGetRequestToServerWithCompletion(completion: (CompletionHandler?) -> Void) {
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//            // do some task
//
//            // request Json file from internet
//            Alamofire.request(.GET, "http://139.162.32.152:3000/youbikes", parameters: ["foo": "bar"])
//                .response { (request, response, data, error) in
//
//                    if let dictionary = data {
////                        self.getStationFromJson(dictionary)
//                        print (dictionary)
//
//                        //                                    // 執行 dispatch
//                        //                                    dispatch_async(dispatch_get_main_queue()) {
//                        //
//                        //                                        completion()
//                        //
//                        //                                    }
//                        print(request)
//                        print(response)
//                        print(error)
//                    }
//
//            }
//        }
//    }



// request Json file from internet
//            let tableView = UBTableViewController()


//
//    // request "post" Json file from internet
//    func sendAPostRequestToServer(params : Dictionary<String, Double>){
//        let request = NSMutableURLRequest(URL: NSURL(string: "http://139.162.32.152:3000/check_in")!)
//        let session = NSURLSession.sharedSession()
//        request.HTTPMethod = "POST"
//
//        do {
//            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
//        } catch {
//            //handle error. Probably return or mark function as throws
//            print(error)
//            return
//        }
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
//
//            // handle error
//
//            guard error == nil  else { return }
//                print("Response: \(response)")
//                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                print("Body: \(strData)")
//
//            let dataObject: NSDictionary?
//            do {
//                dataObject = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
//
//            } catch {
//                print("Error could not parse JSON")
//                    // return or throw?
//                return
//            }
//
//            // The JSONObjectWithData constructor didn't return an error. But, we should still
//            // check and make sure that json has a value using optional binding.
//            if let parseJSON = dataObject {
//                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
//                let success = parseJSON["success"] as? Int
//                print("Succes: \(success)")
//            }
//            else {
//                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
//                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                print("Error could not parse JSON: \(jsonStr)")
//            }
//
//        })
//
//        task.resume()
//    } // end of func getJSonFromInternet()

//    func getDataFromCoreData(){
//        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
//            let fetchRequest = NSFetchRequest(entityName: "Station")
//            do {
//                stations = try
//                    managedObjectContext.executeFetchRequest(fetchRequest) as! [Station]
//
////                print(" ====================== ")
////                print(stations.count)
////                for station in stations {
////                    print(station.address)
////                    print(" ====================== ")
////                }
//            } catch {
//                print("cannot get data from CoreData")
//            }
//
//        }
//    }
//
//init(){
//    
//    self.id = NSUUID().UUIDString
//    
//    
//    //print(self.id)
//    //        let JsonQueue: dispatch_queue_t = dispatch_queue_create("load Json in background", nil)
//    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
//    //            // do some task
//    //            self.sendAGetRequestToServer()
//    //        })
//    //        print(1)
//}

