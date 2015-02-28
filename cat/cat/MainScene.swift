//
//  MainScene.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

protocol MainSceneDelegate {
    func startBtnTouched()
}

class MainScene: SKScene {
    
    var initialized:Bool = false
    
    var mainSceneDelegate:MainSceneDelegate?
    
    let testLabel = SKLabelNode(fontNamed:"Verdana-Bold")
    
    override func didMoveToView(view: SKView) {
        if(!initialized){
            testLabel.text = "start"
            testLabel.fontSize = 40
            testLabel.name = "testbtn"
            testLabel.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            testLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            self.addChild(testLabel)
            initialized = true
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            //do something
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            println(touchedNode)
            if(touchedNode.name == "testbtn"){
              println(self.mainSceneDelegate)
              self.mainSceneDelegate!.startBtnTouched()
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
        
    }
}
