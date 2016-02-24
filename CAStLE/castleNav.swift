//
//  castleNav.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/19/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import Cartography

class castleNav: UINavigationController {
    let grey = UIColor(red:175/255, green: 189/255, blue: 209/255, alpha: 1)
    let blueGrey = UIColor(red:77/255, green: 89/255, blue: 105/255, alpha: 1)
    var progressConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = grey
        let bar = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.width, height: 20))
        bar.backgroundColor = blueGrey
//        self.navigationBar.addSubview(bar)
        
        var name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "CAStLE"
        self.view.addSubview(name)
        
        constrain(name, self.view) { (nam, this) -> () in
            nam.centerX == this.centerX
            nam.top == this.top + 30
        }
        
        var progress = UIView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.35)
        self.view.addSubview(progress)
        
        constrain(progress, self.view) { (prog, view) -> () in
            prog.left == view.left
            prog.height == 64
            prog.top == view.top
            progressConstant = prog.width == 0
        }
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.progressConstant.constant = 100
            self.view.layoutSubviews()
        }
        
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
