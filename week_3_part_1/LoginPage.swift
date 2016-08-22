//
//  LoginPage.swift
//  MyYouBike
//
//  Created by Lin Yi-Cheng on 2016/5/11.
//  Copyright © 2016年 Lin Yi-Cheng. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit

class LoginPage: UIViewController, FBSDKLoginButtonDelegate {
    
    
    
    @IBOutlet weak var bikeLogo: UIImageView!
    
    
    @IBOutlet weak var YouBikeLabel: UILabel!
    
    
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile","email"]
        return button
        
    }()
    
    var userDefault = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarHidden = true
        
        setYouBikeLabel()
        setBikeLogo()
        view.addSubview(loginButton)
        setFBLoginButton()
        loginButton.delegate = self
        if let token = FBSDKAccessToken.currentAccessToken(){
            fetchProfile()
        }

        
        
        test()
        
        // Do any additional setup after loading the view.
    }
    
    func test(){
                print (userDefault.objectForKey("email"))
                    print (userDefault.objectForKey("link"))
                    print (userDefault.objectForKey("picture"))
    }
    
    func setFBLoginButton(){
        
        // Setting the apperance of login Button
        loginButton.setTitle("Log in with Facebook", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        _ = view.frame.size.width
        
        //        loginButton.frame = CGRect(y: 302.0, width: 240.0, height: 64.0)

        loginButton.center.x = view.center.x
        loginButton.center.y = 334.0
        loginButton.frame.size.height = 64
        loginButton.frame.size.width = 240
        loginButton.layer.cornerRadius = 10
        
    }
    
    func setBikeLogo(){
        bikeLogo.backgroundColor = UIColor.ybkPaleTwoColor()
        bikeLogo.layer.borderWidth = 1
        bikeLogo.layer.borderColor = UIColor.ybkCharcoalGreyColor().CGColor
    }
    
    func setYouBikeLabel(){
        YouBikeLabel.font = UIFont.ybkTextStyleFont()
        YouBikeLabel.font = YouBikeLabel.font.fontWithSize(60)
        YouBikeLabel.textColor = UIColor.ybkCharcoalGreyColor()
        
    }
    
    func fetchProfile(){
//        print("fetch profile")
        let parameters = ["fields" : "link, email, first_name, last_name, picture.type(large)"]
        
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler{(completion, result, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            if let email = result["email"] as? String {
                self.userDefault.setObject(email, forKey: "email")
                self.userDefault.synchronize()
//                print(email)
            }
            
            if let link  = result["link"] as? String {
                self.userDefault.setObject(link, forKey: "link")
                self.userDefault.synchronize()
//                print(link)
            }
            
            
            if let picture = result["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                 self.userDefault.setObject(picture, forKey: "picture")
                self.userDefault.synchronize()
//                print(picture)
            }
        }
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("completed login")

        fetchProfile()
        
        if error != nil {
            print(error.localizedDescription)
        }
            
        else if result.isCancelled {
            print("You must login before using this App")
        }
            
        else {
            print("login complete")
            let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("TabBar") as! TabBar
            self.presentViewController(tabBarController, animated: false, completion: nil)
            
//            self.performSegueWithIdentifier("ToUBTableViewCrler", sender: self)
        }
        
    }

    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ToUBTableViewCrler" {
//            let destinationController = segue.destinationViewController as! UBTableViewController
//        }
//    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
