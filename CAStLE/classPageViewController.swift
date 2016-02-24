//
//  classPageViewController.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/21/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import Parse
import QuickLook

class classPageViewController: UIViewController {

    var course: PFObject!
    var syllabusPDF: NSData!
    var syllabusFile: NSURL!
    
    var shouldNotShowAdd = true
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let syllabus: PFFile! = course["syllabusPDF"] as! PFFile
        syllabusFile = NSURL(string: syllabus.url!)
        webView.loadRequest(NSURLRequest(URL: syllabusFile))
        
        if shouldNotShowAdd{
            addButton.hidden = true
        }
        
//        do{
//            syllabusPDF = try syllabus.getData()
//        } catch let error {
//            
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    @IBAction func addClass(){
        networking().addClassToUser(course, courseNum: course.valueForKey("courseNum") as! String) { (success) -> () in
            if success{
                NSNotificationCenter.defaultCenter().postNotificationName("dismissOne", object: nil)
//                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)                
//                self.dismissViewControllerAnimated(true, completion: { () -> Void in
//                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
//                })
            }
        }
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
