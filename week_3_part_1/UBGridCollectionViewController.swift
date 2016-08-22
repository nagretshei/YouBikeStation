//
//  UBGridCollectionViewController.swift
//  MyYouBike
//
//  Created by Lin Yi-Cheng on 2016/5/19.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit



class UBGridCollectionViewController: UICollectionViewController
{
    
    private let reuseIdentifier = "gridCell"

    let youbikeManager = YouBikeManager.instance
    
    
    //Super easy to forget! MUST ADD THIS ONE
 
    @IBOutlet var UBCollectionView: UICollectionView!


    //let googleMap = MapViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collectionVIew ========================")
        //let bikeNumberArray = YouBikeManager.instance.bikeNumber
        //print(YouBikeManager.instance.bikeNumber)
        //print(bikeNumberArray)
        print("***** count")
        print(self.youbikeManager.bikeNumber.count)
        return youbikeManager.bikeNumber.count
//        return YouBikeManager.instance.bikeNumber.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UBCollectionViewCell
  
    
        // Configure the cell
        //cell.imageView?.image = self.imageArray[indexPath.row]
        cell.bikeNum?.text = youbikeManager.bikeNumber[indexPath.row]
        cell.addressLabel?.text = youbikeManager.address[indexPath.row]
    
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        self.collectionView?.toRefresh {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                self.collectionView?.doneRefresh()
            });
        }
        self.collectionView?.toLoadMore {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                self.youbikeManager.getFollowingPageData()
                self.collectionView?.reloadData()
                self.collectionView?.doneRefresh()
                
            });
        }
    }

//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier("showImage", sender: self)
//    }
//    
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showImage"{
//            
//            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
//            let indexPath = indexPaths[0] as NSIndexPath
//            
//            let vc = segue.destinationViewController as! UBGridCollectionViewController
//            vc.title = self.bikeNumber[indexPath.row]
//            
//        }
//    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
