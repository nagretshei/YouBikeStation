//
//  BlankViewController.swift
//  MyYouBike
//
//  Created by Lin Yi-Cheng on 2016/5/18.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit

class BlankViewController: UIViewController {
    
//    lazy var UBTableViewCrl: UBTableViewController =  {
//        let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UBTableViewController") as! UBTableViewController
//        
//        return controller
//        }()
    let station = YouBikeManager()
//    lazy var test = { YouBikeManager.sendAGetRequestToServer
//        
//    }()
    let UBTableViewCrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UBTableViewController") as! UBTableViewController
    
    let StationGrid = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GridViewCollection") as! UICollectionViewController
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //station.sendAGetRequestToServer()
        //station.getStationInfoFromCoreData()

        addSubTableViewController(UBTableViewCrl)


    }
    
    
    func addSubTableViewController(controller: UBTableViewController) {
        //controller.view.removeFromSuperview()
        let controllerView = controller.view
        self.addChildViewController(controller)
        self.view.addSubview(controllerView)
        self.didMoveToParentViewController(controller)
    }
    func addSubCollectionViewController(controller: UICollectionViewController) {
        //controller.view.removeFromSuperview()
        //YouBikeManager.instance.sendAGetRequestToServer()
        //print("test")
        //print(YouBikeManager.instance.address)
        let controllerView = controller.view
        self.addChildViewController(controller)
        self.view.addSubview(controllerView)
        self.didMoveToParentViewController(controller)
    }
    
    

    @IBAction func switchToListAndGrid(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
            case 0: //tableview
            addSubTableViewController(UBTableViewCrl)
            
            default: //grid view
            addSubCollectionViewController(StationGrid)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
