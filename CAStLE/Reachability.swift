//
//  Reachability.swift
//  Bite Me
//
//  Created by Rafi Rizwan on 1/8/16.
//  Copyright © 2016 BiteCode, LLC. All rights reserved.
//

//  MARK: Note
//  This is common boilerplate code. Nothing fancy. 
//  Really understanding it just requires a whole lot 
//  of familiarity with Cocoa documentation and SystemConfiguration

import Foundation
import SystemConfiguration

class Reachability: NSObject {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
