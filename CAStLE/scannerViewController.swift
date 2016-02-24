//
//  scannerViewController.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/20/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import FastttCamera

class scannerViewController: UIViewController, FastttCameraDelegate {

    var camera: FastttCamera = FastttCamera()
    let tapView: UIView = UIView()
    var snapper: UILongPressGestureRecognizer?
    let circle = UIView()

    var toProcess: UIImage!
    
    
    @IBOutlet var snapButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        // Do any additional setup after loading the view.
        
        camera.delegate = self
        camera.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        self.addChildViewController(camera)
        self.view.addSubview(camera.view)

        tapView.bounds = self.view.bounds
        tapView.center = self.view.center
        camera.view.addSubview(tapView)
        
        snapper = UILongPressGestureRecognizer(target: self, action: "capture:")
        snapper?.minimumPressDuration = 1.8
        tapView.addGestureRecognizer(snapper!)
        
        let dismisser: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "dismiss")
        dismisser.direction = UISwipeGestureRecognizerDirection.Down
        dismisser.numberOfTouchesRequired = 1
        tapView.addGestureRecognizer(dismisser)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        
        circle.backgroundColor = UIColor.whiteColor()
        circle.alpha = 0
        circle.clipsToBounds = true
        circle.layer.cornerRadius = 250/2
        circle.frame = CGRectMake(0, 0, 250, 250);
        circle.transform = CGAffineTransformMakeScale(0.1, 0.1)
        let thing = touch?.preciseLocationInView(camera.view)
        
        camera.view.addSubview(circle)
        circle.center = thing!
        UIView.setAnimationsEnabled(true)
        UIView.animateWithDuration(1.8) { () -> Void in
            self.circle.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.circle.center = thing!
            self.circle.alpha = 0.65
        }
        
    }
    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        circle.removeFromSuperview()
//    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.circle.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }) { (done) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.circle.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    self.circle.alpha = 0
                    }) { (done) -> Void in
                        self.circle.removeFromSuperview()

                }
        }
    }
    
    
    func capture(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended{
            print("attempting picture")
            camera.takePicture()
        }
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Camera Delegate
    
    func cameraController(cameraController: FastttCameraInterface!, didFinishCapturingImage capturedImage: FastttCapturedImage!) {
        print("got image to process")
        let text = imageProcessing().performImageRecognition(capturedImage.fullImage)
        print(text)
        
        var alert = UIAlertView(title: "Result", message: text, delegate: nil, cancelButtonTitle: "okay", otherButtonTitles: "")
        alert.show()
    }
    
    func cameraController(cameraController: FastttCameraInterface!, didFinishCapturingImageData rawJPEGData: NSData!) {
        
    }
    
    func cameraController(cameraController: FastttCameraInterface!, didFinishNormalizingCapturedImage capturedImage: FastttCapturedImage!) {
        
    }
    
    func cameraController(cameraController: FastttCameraInterface!, didFinishScalingCapturedImage capturedImage: FastttCapturedImage!) {
        
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
