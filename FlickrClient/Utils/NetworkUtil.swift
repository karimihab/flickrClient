//
//  NetworkUtil.swift
//  FlickrClient
//
//  Created by Karim Ihab on 21/09/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation

//This class is responsible for all network related tasks
//now it's just a simple isOnline or isOffline but we can use to fire notification to the all app about network status, build function with closures, ..etc
class NetworkUtil {
    
    static let reachabilityInstance = Reachability()
    
    class func isOnline() -> Bool {
        return reachabilityInstance!.isReachable
    }
    
    class func isOffline() -> Bool {
        return !reachabilityInstance!.isReachable
    }
}
