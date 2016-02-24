//
//  LoginViewController.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/19/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import TKSubmitTransition
import ParseFacebookUtilsV4
import Whisper
import GSMessages

let pink = UIColor(red:175/255, green: 189/255, blue: 209/255, alpha: 1)

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        var btn: TKTransitionSubmitButton!
        btn = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 64, height: 44))
        btn.center = self.view.center
        btn.setTitle("Log In With Facebook", forState: .Normal)
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        btn.addTarget(self, action: "login:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        
        if Reachability.isConnectedToNetwork() == true {
            userNetworking().loginInBackground(self) { (user) -> () in
                userCourser.sharedInstance.user = user
                var murmur = Murmur(title: "Looks like you're logged in")
                murmur.backgroundColor = pink
                murmur.titleColor = UIColor.whiteColor()
                Whistle(murmur)
                btn.animate(1, completion: { () -> () in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = storyboard.instantiateViewControllerWithIdentifier("centralNav")
                    mainViewController.transitioningDelegate = self
                    self.presentViewController(mainViewController, animated: true, completion: nil)
                })
            }
        } else {
            print("No Internet")
            self.showMessage("You don't have a data connection! 😱", type: .Error, options: [.Animation(.Slide),
                .AnimationDuration(0.3),
                .AutoHide(false),
                .AutoHideDelay(3.0),
                .Height(44.0),
                .HideOnTap(true),
                .Position(.Top),
                .TextAlignment(.Center),
                .TextColor(UIColor.whiteColor()),
                .TextNumberOfLines(1),
                .TextPadding(30.0)])
        }
        
//        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("setRandomBackgroundColor"), userInfo: nil, repeats: true)
//        dispatch_async(dispatch_get_global_queue(2, 0)) { 
//            self.setRandomBackgroundColor()
//        }
    }
    
    func setRandomBackgroundColor() {
        let colors = [
            UIColor(red: 233/255, green: 203/255, blue: 198/255, alpha: 1), //Red
            UIColor(red: 38/255, green: 188/255, blue: 192/255, alpha: 1), //Aqua
            UIColor(red: 110/255, green: 165/255, blue: 101/255, alpha: 1), //Green
            UIColor(red: 235/255, green: 154/255, blue: 171/255, alpha: 1), //Pink
            UIColor(red: 87/255, green: 141/255, blue: 155/255, alpha: 1) //Blue
        ]
        
        let randomColor = Int(arc4random_uniform(UInt32 (colors.count)))
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.view.backgroundColor = colors[randomColor]
            }, completion: nil)
    }
    
    
    @IBAction func login(button: TKTransitionSubmitButton){
        userNetworking().login(self){ (user) -> () in
            userCourser.sharedInstance.user = user
            button.animate(1, completion: { () -> () in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewControllerWithIdentifier("centralNav")
                mainViewController.transitioningDelegate = self
                self.presentViewController(mainViewController, animated: true, completion: nil)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func noInternet(){
        SweetAlert().showAlert("You don't have a data connection")
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
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
