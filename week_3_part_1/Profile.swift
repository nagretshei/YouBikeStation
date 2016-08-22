//
//  Profile.swift
//  MyYouBike
//
//  Created by Lin Yi-Cheng on 2016/5/10.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit
import SafariServices

class Profile: UIViewController, SFSafariViewControllerDelegate {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var cardBase: UIView!
    
  
    @IBOutlet weak var FBPage: UIButton!

    
    @IBOutlet weak var FBPageWhite: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.ybkDarkSandColor()
        setCardBase()
        setNameLabel()
        setFBProfileButton()

        
        
        // Do any additional setup after loading the view.
    }
    
    func setFBProfileButton(){
        // Set property
        FBPage.backgroundColor = UIColor.ybkDenimBlueColor()
        FBPage.layer.cornerRadius = 10
        FBPage.clipsToBounds = true
        FBPage.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        FBPage.titleLabel!.font = UIFont.ybkTextStyle1Font()
        FBPage.titleLabel!.font = UIFont.ybkTextStyle1Font()?.fontWithSize(20)
        FBPageWhite.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
        FBPageWhite.userInteractionEnabled = false
        
    }
    
    @IBAction func FBPage(sender: UIButton) {
        
        let url = NSUserDefaults.standardUserDefaults().objectForKey("link") as! String
        let FBUrl = NSURL(string: url)
        print (FBUrl)
        
        let vc = SFSafariViewController(URL: FBUrl!)
        vc.delegate = self
            
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setCardBase(){
        cardBase.backgroundColor = UIColor.ybkPaleColor()
        
        cardBase.layer.shadowColor = UIColor.blackColor().CGColor
        cardBase.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardBase.layer.shadowOpacity = 0.25
        
        cardBase.layer.shadowRadius = 20
//        cardBase.layer.shadowPath = UIBezierPath(rect: cardBase.bounds).CGPath
//        cardBase.layer.shouldRasterize = true

    }
    
    func setNameLabel(){
        nameLabel.textColor = UIColor.ybkCharcoalGreyColor()
        nameLabel.font = UIFont.ybkTextStyle1Font()
        nameLabel.font = UIFont.ybkTextStyle1Font()?.fontWithSize(50)
        
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
