//
//  RetryBtn.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/14.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

protocol RetryDelegate {
    func retryTouched()
}

class RetryBtn: SKLabelNode {
    
    var delegate: RetryDelegate! = nil
    
    override init() {
        
        super.init()
        
        //retry
        self.text = "RETRY?"
        self.name = "retry"
        self.fontName = "Verdana-Bold"
        self.fontSize = 70
        //self.frame.size = CGRectMake(0, 0, 200, 200)
        //self.hidden = true
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        self.delegate!.retryTouched()
    }

}