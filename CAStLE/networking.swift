//
//  networking.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/21/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import Parse
import Alamofire

class networking: NSObject {

    static let sharedInstance = networking()
//    private override init(){}
    
    func getClassesForUser(user: PFUser!, completionClosure:(classes: [PFObject]!)->()){
        
    }
    
    func getClassesForCurrentUser(completionClosure:(classes: [PFObject]!)->()){
        let userCourses = userCourser.sharedInstance.user.objectForKey("course") as? [String]
//        print(userCourses)
        
        for index in userCourses!{
            let query = PFQuery(className: "Syllabus")
            query.whereKey("courseNum", containsString: index)
            print("TEST!")
            query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                print(results)
                if results!.count > 0{
                    userCourser.sharedInstance.classes.append(results!.first!)
                }
                
                print(userCourser.sharedInstance.classes)
                
                if userCourser.sharedInstance.classes.count == userCourses?.count{
                    
                    completionClosure(classes: userCourser.sharedInstance.classes)
                }
                
            })
            

        }
    }
    
    func addClassToUser(course: PFObject!, courseNum: String!, completionClosure:(success: Bool)->()){
        var userCourses = userCourser.sharedInstance.user.objectForKey("course") as? [String]
        userCourses?.append(courseNum)
        userCourser.sharedInstance.user.setObject(userCourses!, forKey: "course")
        print(userCourser.sharedInstance.user["course"])
        print(userCourses)
        
        var courseStudents = course["students"] as! [String]
        courseStudents.append(userCourser.sharedInstance.user.objectId!)
        course.setValue(courseStudents, forKey: "students")
        
        userCourser.sharedInstance.user.saveInBackgroundWithBlock { (success, error) -> Void in
            if !success {
                userCourser.sharedInstance.user.saveEventually()
            }
        }
        
        course.saveInBackgroundWithBlock { (success, error) -> Void in
            if !success{
                course.saveEventually()
            } else {
                completionClosure(success: true)
            }
        }
    }
    
    func getDataFromCourse(courseObjID: String!, competionClosure:(success: Bool)->()){
        let URL = ""
        Alamofire.request(.GET, URL)
            .responseJSON { response in
                if let JSON = response.result.value {
                        print(JSON)
                    if JSON.valueForKey("status") as? String == "success"{
                        competionClosure(success: true)
                    } else {
                        competionClosure(success: false)
                    }
                }
        }
    }
}
