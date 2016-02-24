//
//  userNetworking.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/19/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

class userNetworking: NSObject {
    
    
    //MARK: login in background
    func loginInBackground(sender: UIViewController?, completionClosure:(user: PFUser?)->()){
        if FBSDKAccessToken.currentAccessToken() != nil{
            PFFacebookUtils.logInInBackgroundWithAccessToken(FBSDKAccessToken.currentAccessToken(), block: {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    print("User logged in through Facebook!")
                    completionClosure(user: user!)
                } else {
                    print("Uh oh. There was an error logging in.")
                    completionClosure(user: nil)
                }
            })
        }
    }
    
    //MARK: login function via facebook
    func login(sender: UIViewController,completionClosure: (user: PFUser) -> ()){
        if FBSDKAccessToken.currentAccessToken() != nil {
            loginInBackground(sender, completionClosure: { (user) -> () in
                completionClosure(user: user!)
            })
        }
        FBSDKLoginManager().logInWithReadPermissions(["public_profile", "email", "user_about_me"], fromViewController: sender) { (result: FBSDKLoginManagerLoginResult!, error) -> Void in
            let accessToken: FBSDKAccessToken = FBSDKAccessToken.currentAccessToken()
            PFFacebookUtils.logInInBackgroundWithAccessToken(accessToken, block: {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    if user!.isNew{
                        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "name, id, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                            user!["courses"] = []
                            user!["name"] = result["name"]!
                            user!["fbid"] = result["id"]!
                            user!.email = result.email
                            print(result)
                            user!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                                print("saved")
                            })
                        })
                    }
                    print("User logged in through Facebook!")
                    completionClosure(user: user!)
                } else {
                    print("Uh oh. There was an error logging in.")
                }
            })
        }
    }
    
    //MARK: logout function
    
}
