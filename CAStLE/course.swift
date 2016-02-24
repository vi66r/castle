//
//  course.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/21/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import GRKBarGraphView
import RingGraph

class course: UIViewController {
//    @IBOutlet var ring: RingGraphView!
    @IBOutlet var done: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let singleGraphMeter = [RingMeter(title: "Points", value: 85, maxValue: 100, colors: [AppleRed1, AppleRed2])]
        
        let screenBounds = UIScreen.mainScreen().bounds
        let frame = CGRectMake(screenBounds.width/2 - 150, screenBounds.height/2 - 150, 300, 300)
        
        if let graph = RingGraph(meters: singleGraphMeter) {
            let ringG = RingGraphView(frame: frame, graph: graph, preset: .MetersDescription)
            ringG.backgroundColor = UIColor.clearColor()
            self.view.addSubview(ringG)
            
            ringG.animateGraph()
        }
        
        
        
    }
    
    @IBAction func adios(){
        self.dismissViewControllerAnimated(true, completion: nil)
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
