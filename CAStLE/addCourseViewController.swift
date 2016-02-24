//
//  addCourseViewController.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/20/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import Parse
import Cartography

class addCourseViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var ONE: UILabel!
    @IBOutlet var intro: UILabel!
    @IBOutlet var Scan: UIButton!
    @IBOutlet var Upload: UIButton!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var entryLabel: FloatLabelTextField!
    var dismissKeyboard: UITapGestureRecognizer!
    
    var possibleClasses: [PFObject]!
    @IBOutlet var dropDown: UITableView!
    @IBOutlet var dropDownHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "uploadedPDF", name: "PDFUploaded", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "dismissTwo", name: "dismissOne", object: nil)
        

        entryLabel.delegate = self
        entryLabel.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        dismissKeyboard = UITapGestureRecognizer(target: self, action: "dismissKb:")
        self.view.addGestureRecognizer(dismissKeyboard)
        
        ONE.alpha = 0.0
        intro.alpha = 1.0
        Scan.alpha = 0.0
        Upload.alpha = 0.0
        
//        dropDown.delegate = self
//        dropDown.dataSource = self
        dropDown.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dropDown.alpha = 0.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKb(sender: UITapGestureRecognizer){
        entryLabel.resignFirstResponder()
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.characters.count == 0{
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.Scan.alpha = 0.0
                self.Upload.alpha = 0.0
                self.ONE.alpha = 0.0
                self.dropDown.alpha = 0.0
                self.intro.alpha = 1.0
                self.dropDownHeight.constant = 0
                }, completion: { (done) -> Void in
            })
        }
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print(textField.text)
    }
    
    func textFieldChanged(textfield: UITextField){
        if textfield.text?.characters.count > 0 {
            let query = PFQuery(className: "Syllabus")
            query.whereKey("courseNum", containsString: textfield.text?.stringByReplacingOccurrencesOfString("-", withString: ""))
            query.findObjectsInBackgroundWithBlock { (objectArray, error) -> Void in
                
                self.possibleClasses = objectArray
                
                if objectArray?.count > 0 {
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.dropDown.alpha = 1.0
                        self.intro.alpha = 0.0
                        self.Scan.alpha = 0.0
                        self.Upload.alpha = 0.0
                        self.ONE.alpha = 0.0
                        self.dropDownHeight.constant = 80
                        }, completion: { (done) -> Void in
                    })
                } else {
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.Scan.alpha = 1.0
                        self.Upload.alpha = 1.0
                        self.ONE.alpha = 1.0
                        self.intro.alpha = 0.0
                        self.dropDown.alpha = 0.0
                        self.dropDownHeight.constant = 0
                        }, completion: { (done) -> Void in
                    })
                }
            }
        } else if textfield.text?.characters.count == 0 {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.Scan.alpha = 0.0
                self.Upload.alpha = 0.0
                self.ONE.alpha = 0.0
                self.dropDown.alpha = 0.0
                self.intro.alpha = 1.0
                self.dropDownHeight.constant = 0
                }, completion: { (done) -> Void in
            })
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.Scan.alpha = 1.0
                self.Upload.alpha = 1.0
                self.ONE.alpha = 1.0
                self.intro.alpha = 0.0
                self.dropDown.alpha = 0.0
                self.dropDownHeight.constant = 0
                }, completion: { (done) -> Void in
            })
        }
        self.dropDown.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if possibleClasses != nil && possibleClasses.count > 0{
            cell.textLabel?.text = possibleClasses[indexPath.row]["courseName"] as? String
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected row!")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let courseViewController = storyboard.instantiateViewControllerWithIdentifier("classPage") as! classPageViewController
        courseViewController.course = possibleClasses[indexPath.row]
        courseViewController.shouldNotShowAdd = false
        print(courseViewController.course)
        
        self.presentViewController(courseViewController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissTwo(){
        print("dismissing")
        NSNotificationCenter.defaultCenter().postNotificationName("refreshTable", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func launchScanner(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scanner = storyboard.instantiateViewControllerWithIdentifier("camaera") as! scannerViewController
        
        self.presentViewController(scanner, animated: true, completion: nil);
    }
    
    @IBAction func launchInternet(sender: AnyObject) {
        SweetAlert().showAlert("README", subTitle: "Open the syllabus you want to add, in NYU Classes, then tap on the PDF and once you see \"open in...\" at the top, press that, and select \"copy to CAStLE\"!", style: AlertStyle.Warning , buttonTitle: "Okay") { (isOtherButton) -> Void in
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://newclasses.nyu.edu")!)
        }
    }
    
    func uploadedPDF(){
        SweetAlert().showAlert("Hey Hey!", subTitle: "Your PDF is uploaded and processing!", style: AlertStyle.None, buttonTitle: "Okay") { (isOtherButton) -> Void in
            //do something
            networking().addClassToUser(userCourser.sharedInstance.classesUnconfirmed.first, courseNum: self.entryLabel.text, completionClosure: { (success) -> () in
                if success {
                    self.dismiss()
                }
            })
            
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
