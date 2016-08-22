//
//  NavigationControllerViewController.swift
//  week_3_part_1
//
//  Created by Lin Yi-Cheng on 2016/4/26.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.ybkCharcoalGreyColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.ybkPaleGoldColor()]
        
        

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
