//
//  UserDataUtil.swift
//  cat
//
//  Created by takatatomoyuki on 2015/03/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import Foundation

class UserDataUtil {
    
    class func setPointData(_ pt:Int){
        let ud = UserDefaults.standard
        ud.set(pt, forKey: "pt")
    }

    class func getPointData() -> Int{
        let ud = UserDefaults.standard
        let udId : AnyObject! = ud.object(forKey: "pt") as AnyObject!
        var score = 0
        if(udId != nil) {
            score = udId as! Int
        }
        return score
    }
}
