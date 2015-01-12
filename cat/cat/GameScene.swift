//
//  GameScene.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, HaeDelegate {
    
    var score = 0
    let remainTime = 30
    var currentRemainTime = 30
    let scoreLabel = SKLabelNode(fontNamed:"Verdana-Bold")
    let timeLabel = SKLabelNode(fontNamed:"Verdana-Bold")
    let gameoverLabel = SKLabelNode(fontNamed:"Verdana-Bold")
    let retryLabel = SKLabelNode(fontNamed:"Verdana-Bold")
    let sound = SKAction.playSoundFileNamed("coin.mp3", waitForCompletion: false)
    let deviceWidth = UIScreen.mainScreen().nativeBounds.width
    
    var gameTimer:NSTimer? = nil
    var createTimer:NSTimer? = nil
    
    override func didMoveToView(view: SKView) {
        
        //time
        timeLabel.text = String(remainTime)
        timeLabel.fontSize = 50
        timeLabel.position = CGPoint(x:CGRectGetMidX(self.frame) - 200, y:CGRectGetHeight(self.frame) - 70)
        self.addChild(timeLabel)
        
        //score
        scoreLabel.text = "0"
        scoreLabel.fontSize = 50
        scoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetHeight(self.frame) - 70)
        self.addChild(scoreLabel)
        
        //gameover
        gameoverLabel.text = "GAME OVER"
        gameoverLabel.fontSize = 90
        gameoverLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        gameoverLabel.hidden = true
        self.addChild(gameoverLabel)
        
        //retry
        retryLabel.text = "RETRY?"
        retryLabel.fontSize = 70
        retryLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 100)
        retryLabel.hidden = true
        self.addChild(retryLabel)
        
        //タイマー
        gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimerTrigger:", userInfo: nil, repeats: true)
        
        createTimer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: "createHae:", userInfo: nil, repeats: true)
        
        
        println(UIScreen.mainScreen().nativeBounds.width)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        //println(self.childNodeWithName("hae"))
        
        for node : AnyObject in self.children{
            
            if (node as SKNode).name == nil  {
                //println("name is nil")
            }
            else{
                if(node.name == "hae"){
                    //Nodes.append(Node as SKNode)
                    var _node = node as Hae
                    _node.update()

                }
                
            }
            
        }
    }
    
    func getRandomNumber(Min _Min : Int, Max _Max : Int)->Int {
        return Int(arc4random_uniform(UInt32(_Max))) + _Min
    }
    
    func createHae(timer : NSTimer){
        //createhae
        let hae = Hae()
        hae.name = "hae"
        
        var _dir = 0 //0:left 1:right
        var _x = 0
        var _y = getRandomNumber(Min:240,Max:700)
        
        hae.range = CGFloat(getRandomNumber(Min:1,Max:12))
        hae.xs = CGFloat(getRandomNumber(Min:2,Max:15))
        
        if(_y % 2 == 1){
            hae.dir = 0
            _x = (Int(self.frame.width) - Int(deviceWidth))/2 - 200
        }else{
            hae.dir = 1
            _x = (Int(self.frame.width) - Int(deviceWidth))/2 + Int(deviceWidth) + 200
            println(_x)
        }
        
        hae.position = CGPoint(x:_x,y:_y)
        hae.delegate = self
        self.addChild(hae)
    }
    
    func onTimerTrigger(timer : NSTimer){
        
        //time
        currentRemainTime -= 1
        if(currentRemainTime < 0){
            currentRemainTime = 60
            timeLabel.text = "0"
            gameoverLabel.hidden = false
            retryLabel.hidden = false
            
            gameTimer!.invalidate()
            createTimer!.invalidate()
            
            for node : AnyObject in self.children{
                
                if((node as SKNode).name != nil && node.name == "hae"){
                    //Nodes.append(Node as SKNode)
                    var _node = node as Hae
                    _node.disableTouch()
                    
                }
                
            }
            
        }else{
            timeLabel.text = String(currentRemainTime)
        }
        
    }
    
    func haeTouched(hae:Hae){
        score += 100
        scoreLabel.text = String(score)
        runAction(sound)
    }
}
