//
//  testpdfViewController.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/20/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit

class testpdfViewController: UIViewController, UIDocumentInteractionControllerDelegate {

    var url: NSURL!
    var docController: UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (url != nil){
            docController = UIDocumentInteractionController(URL: url)
            docController.delegate = self
            docController.UTI = "com.adobe.pdf"
//            docController.presentOpenInMenuFromRect(CGRect.zero, inView: <#T##UIView#>, animated: <#T##Bool#>)
            
            
        }
        
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerViewForPreview(controller: UIDocumentInteractionController) -> UIView? {
        return self.view
    }
    
    func documentInteractionControllerRectForPreview(controller: UIDocumentInteractionController) -> CGRect {
        return self.view.frame
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
