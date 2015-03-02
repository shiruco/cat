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
    let btnSound = SKAction.playSoundFileNamed("btn.mp3", waitForCompletion: false)
    
    let title = SKSpriteNode(imageNamed: "title_main.png")
    
    //layers
    var bgLayer:SKNode? = nil
    var haeLayer:SKNode? = nil
    
    let bg = SKSpriteNode(imageNamed: "room.png")
    let bgInitialPosX:CGFloat = 800.0
    
    override func didMoveToView(view: SKView) {
        
        //layer
        bgLayer = self.childNodeWithName("bgLayer")
        haeLayer = bgLayer!.childNodeWithName("haeLayer")
        
        //bg 350
        bg.position = CGPoint(x:bgInitialPosX, y:CGRectGetHeight(self.frame) - 350)
        
        if(!initialized){
            
            bgLayer!.addChild(bg)
            
            bgLayer!.addChild(title)
            title.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 300)
            title.zPosition = 1
            
            testLabel.text = "start"
            testLabel.fontSize = 40
            testLabel.name = "testbtn"
            testLabel.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            testLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
            haeLayer!.addChild(testLabel)
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
              self.mainSceneDelegate!.startBtnTouched()
              runAction(btnSound)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if(bg.position.x < 350){
            return
        }
        bg.position.x -= 0.1
    }
}
