//
//  JsonOb.swift
//  week_3_part_1
//
//  Created by Lin Yi-Cheng on 2016/4/25.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import Foundation

class JsonOb {
    
    // Set individaul info of the Station data
    var address = [String]()
    var addressSubtitle = [String]()
    var bikeNumber = [String]()
    var image = [String]()
    var latitude = [Double]()
    var longitude = [Double]()
    
    func getStationFromJson() -> AnyObject? {
        //converting Json file to Json object, converting Nsdata to Json object
        let url = NSBundle.mainBundle().URLForResource("youbike", withExtension: "json") // call Json file
        let data = NSData(contentsOfURL: url!)
        let dataObject =  try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) // serializing Json file to 0 and 1 (NSdata)
        
        // removing the outside and middle side of info in JSon
        if let dataOB = dataObject as? [String: AnyObject] {
            let result = dataOB["result"] as? [String: AnyObject]
            let results = result!["results"] as? [AnyObject]
            
        // abstracting individual info from Json we need
            getInfo(results!)
            return results
        }
        else {return nil}
        
    } // end of fuct getStationFromJson()
    

   // Following are fuctions for getting indivual station data
    func getInfo(results: [AnyObject]) {
        
        for eachCellData in results {
            image.append("iconMarker")
            
            let dist = eachCellData["sarea"] as! String
            let exit = eachCellData["sna"] as! String
            address.append(String(dist + " / " + exit))
            
            let subtitle = eachCellData["ar"] as! String
            addressSubtitle.append(String(subtitle))
            
            let bikeNum = eachCellData["sbi"] as! String
            bikeNumber.append(String(bikeNum))
            
            let eachLat = eachCellData["lat"] as! String
            latitude.append(Double(eachLat)!)
            
            let eachLng = eachCellData["lng"] as! String
            longitude.append(Double(eachLng)!)
        }
    }
    
} // end of class JsonOb 


        
        
