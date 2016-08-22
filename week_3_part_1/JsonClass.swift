//
//  JsonOb.swift
//  week_3_part_1
//
//  Created by Lin Yi-Cheng on 2016/4/25.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import Foundation


class Station {
    var address = [String]()
    var addressSubtitle = [String]()
    var bikeNumber = [String]()
    var image = [String]()
    var latitude = [Double]()
    var longitude = [Double]()
    
}




class Json {
//    var address = [String]()
//    var addressSubtitle = [String]()
//    var bikeNumber = [String]()
//    var image = [String]()
//    var latitude = [Double]()
//    var longitude = [Double]()
    
    
    // convert Json file into Json object
    
    func nsdataToJSON() -> AnyObject? {
    
        let url = NSBundle.mainBundle().URLForResource("youbike", withExtension: "json") // call the Json data
        let data = NSData(contentsOfURL: url!)
        let dataObject =  try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) // serializing Json data
       
        // convert Json data into Json object
        if let dataOB = dataObject as? [String: AnyObject] {
            let result = dataOB["result"] as? [String: AnyObject]
            let results = result!["results"] as? [AnyObject]
            
            
        // abstract data
            
        let StationOb = [Station]()
            
            
            
            getAddress(results!)
            getAddressSubtitle(results!)
            getBikeNumber(results!)
            getImage(results!)
            getLat(results!)
            getLng(results!)
            
            return results
            
        }
        else {return nil}
        
    }
    
    func getAddress(results: [AnyObject]) -> [AnyClass] {
        
        for eachCellData in results {
            let dist = eachCellData["sarea"] as! String
            let exit = eachCellData["sna"] as! String
            address.append(String(dist + " / " + exit))
            
        }
        //        print (address)
        
        return address
    }
    
//    
//    func getAddress(results: [AnyObject]) -> [String] {
//        
//        for eachCellData in results {
//            let dist = eachCellData["sarea"] as! String
//            let exit = eachCellData["sna"] as! String
//            address.append(String(dist + " / " + exit))
//            
//        }
//        //        print (address)
//        
//        return address
//    }
//    
//    func getAddressSubtitle(results: [AnyObject]) -> [String] {
//        
//        for eachCellData in results {
//            let subtitle = eachCellData["ar"] as! String
//            addressSubtitle.append(String(subtitle))
//            
//        }
//        
//        return addressSubtitle
//    }
//    
//    func getBikeNumber(results: [AnyObject]) -> [String] {
//        
//        for eachCellData in results {
//            let bikeNum = eachCellData["sbi"] as! String
//            bikeNumber.append(String(bikeNum))
//            
//        }
//        
//        return bikeNumber
//    }
//    
//    func getLat(results: [AnyObject]) -> [Double] {
//        
//        for eachCellData in results {
//            let eachLat = eachCellData["lat"] as! String
//            latitude.append(Double(eachLat)!)
//            
//        }
//        return latitude
//    }
//    
//    func getLng(results: [AnyObject]) -> [Double] {
//        
//        for eachCellData in results {
//            let eachLng = eachCellData["lng"] as! String
//            longitude.append(Double(eachLng)!)
//            
//        }
//        return longitude
//    }
//    
//    func getImage(results: [AnyObject]) -> [String] {
//        
//        for _ in results {
//            image.append("iconMarker")
//            
//        }
//        //        print (addressSubtitle)
//        
//        return image
//    }
//    
}




