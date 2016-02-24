//
//  AppDelegate.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/19/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import Parse
import Bolts
import FBSDKCoreKit
import ParseFacebookUtilsV4
import GSMessages
import QuickLook

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, QLPreviewControllerDataSource {

    var window: UIWindow?
    var pdfURL: NSURL!


//    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//        
//    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        print("بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ")
        
        if (launchOptions?[UIApplicationLaunchOptionsURLKey] != nil) {
            let PDF = launchOptions![UIApplicationLaunchOptionsURLKey]
            print(PDF)
        }
        

        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("xhMWTGxOpUDpFssFGW45IxT6W5mg7BLkw8Es5iaj",
            clientKey: "uBBQt9UMlT2kMtO6P4uFlCLK36hL9H7WYmbujvIM")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        GSMessage.errorBackgroundColor = UIColor.redColor()
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let verify = NSString(string: url.lastPathComponent!)
        let idx = verify.length - 3
        if verify.substringFromIndex(idx) == "pdf"{
            let preview = testpdfViewController()
            preview.url = url
            pdfURL = url
            
            let data = NSData(contentsOfURL: pdfURL)
            
            let syllabus = PFObject(className: "Syllabus")
            let syllabusFile = PFFile(name: url.lastPathComponent, data: data!)
            syllabus.setObject(syllabusFile!, forKey: "syllabusPDF")
            syllabus["students"] = []
            
            syllabus.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if succeeded{
                    print("yay")
                    
                    let notif: NSNotificationCenter! = NSNotificationCenter.defaultCenter()
                    notif.postNotificationName("PDFUploaded", object: nil)
                    
                } else {
                    syllabus.saveEventually()
                }
            })
            
            userCourser.sharedInstance.classesUnconfirmed.append(syllabus)
//            let nav = self.window?.rootViewController?.presentedViewController as! UINavigationController
//            let qlpreview = QLPreviewController()
//            qlpreview.dataSource = self
//            nav.pushViewController(qlpreview, animated: true)
            return true
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(controller: QLPreviewController, previewItemAtIndex index: Int) -> QLPreviewItem {
        return pdfURL
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

