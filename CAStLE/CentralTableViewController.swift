//
//  CentralTableViewController.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/19/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import Cartography
import Parse

class CentralTableViewController: UITableViewController {

    var timer: NSTimer!
    
    private let colors = [
        UIColor(red: 233/255, green: 203/255, blue: 198/255, alpha: 1), //Red
        UIColor(red: 38/255, green: 188/255, blue: 192/255, alpha: 1), //Aqua
        UIColor(red: 110/255, green: 165/255, blue: 101/255, alpha: 1), //Green
        UIColor(red: 235/255, green: 154/255, blue: 171/255, alpha: 1), //Pink
        UIColor(red: 87/255, green: 141/255, blue: 155/255, alpha: 1) //Blue
    ]
    let addButton: UIButton = UIButton(type: UIButtonType.Custom)
    
    var classes:[PFObject]! = userCourser.sharedInstance.classes
    
//    override func viewWillAppear(animated: Bool) {
//        self.classes = userCourser.sharedInstance.classes
//        self.tableView.reloadData()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadClasses", name: "refreshTable", object: nil)
        
        self.tableView.registerClass(centralProgressTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
//        networking().getClassesForCurrentUser { (classes) -> () in
//            self.classes = classes
//            self.tableView.reloadData()
//        }
        
        let footer: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
        footer.addSubview(addButton)
        
        addButton.backgroundColor = UIColor.orangeColor()
        addButton.setTitle("Add A Class", forState: UIControlState.Normal)
        addButton.layer.cornerRadius = 10
        addButton.clipsToBounds = true
        addButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false;
        addButton.addTarget(self, action: "addClass", forControlEvents: .TouchUpInside)
        
        constrain(addButton, footer) {button, view in
            button.center == view.center
            button.height == view.height - 14
            button.width == view.width - 60
        }
        self.tableView.tableFooterView = footer
        
//        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("setRandomBackgroundColor"), userInfo: nil, repeats: true)
//        self.setRandomBackgroundColor()
        
        self.view.backgroundColor = UIColor(red: 45.0/255.0, green: 62.0/255.0, blue: 79.0/255.0, alpha: 1.0)
        
        refresh()
    }
    
    func addClass(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let scanner = storyboard.instantiateViewControllerWithIdentifier("enterClass") as! addCourseViewController
        
        self.presentViewController(scanner, animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = centralProgressTableViewCell(style: .Default, reuseIdentifier: "Cell")
        
        let dataObject = classes[indexPath.row] 
        
        // Configure the cell...
        UIView.setAnimationsEnabled(true)
        UIView.animateWithDuration(0.8) { () -> Void in
            cell.progconst.constant = CGFloat((indexPath.row+1)*20)
//            cell.setNeedsLayout()
            cell.layoutSubviews()
        }
        
        
        cell.name.text = dataObject["courseName"] as! String
        cell.number.text = dataObject["courseNum"] as! String
        
        cell.backgroundColor = colors[indexPath.row % colors.count]
        cell.progress.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.33)

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // do some cool shit
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let courseViewController = storyboard.instantiateViewControllerWithIdentifier("coursePage") as! course
//        courseViewController.course = classes[indexPath.row]
//        courseViewController.shouldNotShowAdd = true
//        print(courseViewController.course)
        
        self.presentViewController(courseViewController, animated: true, completion: nil)

        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ((self.view.frame.size.width/16)*9)-60
    }

    func reloadClasses(){
        print("reloading table")
        
//        networking().getClassesForCurrentUser { (classes) -> () in
//            print("networking...")
//            self.classes = classes
//            self.tableView.reloadData()
//        }
        
        refresh()
    }
    
    func refresh(){
        self.classes = [PFObject]()
        networking().getClassesForCurrentUser { (classes) -> () in
            self.classes = classes
            self.tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
