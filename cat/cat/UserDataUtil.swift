//
//  UserDataUtil.swift
//  cat
//
//  Created by takatatomoyuki on 2015/03/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import Foundation

class UserDataUtil {
    
    class func setPointData(pt:Int){
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(pt, forKey: "pt")
    }

    class func getPointData() -> Int{
        let ud = NSUserDefaults.standardUserDefaults()
        let udId : AnyObject! = ud.objectForKey("pt")
        var score = 0
        if(udId != nil) {
            score = udId as! Int
        }
        return score
    }
}