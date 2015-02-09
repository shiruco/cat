//
//  GameScene.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, HaeDelegate, RetryDelegate {
    
    var score = 0
    let remainTime = 30
    var currentRemainTime = 30
    var currentScore = 0
    
    //layers
    var contentLayer:SKNode? = nil
    var bgLayer:SKNode? = nil
    var haeLayer:SKNode? = nil
    var uiLayer:SKNode? = nil
    
    let bg = SKSpriteNode(imageNamed: "room.png")
    let uiContainer = SKNode()
    let scoreLabel = SKLabelNode(fontNamed:"Verdana-Bold")
    let timeBg = SKSpriteNode(imageNamed: "remain.png")
    let ptBg = SKSpriteNode(imageNamed: "pt_bg.png")
    let timeLabel = SKLabelNode(fontNamed:"Verdana-Bold")
    let gameoverLabel = SKLabelNode(fontNamed:"Verdana-Bold")
    let retryLabel = RetryBtn()
    let sound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    let deviceWidth = UIScreen.mainScreen().nativeBounds.width
    
    var resultModal:ResultModal? = nil
    
    var gameTimer:NSTimer? = nil
    var createTimer:NSTimer? = nil
    
    override func didMoveToView(view: SKView) {
        
        //layer
        contentLayer = childNodeWithName("contentLayer")
        bgLayer = contentLayer!.childNodeWithName("bgLayer")
        haeLayer = bgLayer!.childNodeWithName("haeLayer")
        uiLayer = haeLayer!.childNodeWithName("uiLayer")
        
        //bg 350
        bg.position = CGPoint(x:CGRectGetMidX(self.frame) - 200, y:CGRectGetHeight(self.frame) - 650)
        bgLayer!.addChild(bg)
        
        //UI
        uiContainer.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetHeight(self.frame) - 370)
        uiContainer.hidden = true
        uiLayer!.addChild(uiContainer)
        
        //score
        ptBg.position = CGPoint(x:150,y:0)
        uiContainer.addChild(ptBg)
        
        scoreLabel.text = "0"
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        scoreLabel.position = CGPoint(x:80, y:-20)
        ptBg.addChild(scoreLabel)
        
        //time
        timeBg.position = CGPoint(x:0, y:0)
        timeBg.zPosition = 1
        uiContainer.addChild(timeBg)
        
        timeLabel.text = String(remainTime)
        timeLabel.fontSize = 50
        timeLabel.zPosition = 2
        timeLabel.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
        timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        timeLabel.position = CGPoint(x:0, y:-20)
        timeBg.addChild(timeLabel)
        
        //gameover
        gameoverLabel.text = "TIME OVER"
        gameoverLabel.fontSize = 90
        gameoverLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        //self.addChild(gameoverLabel)
        
        //retry
        retryLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 100)
        retryLabel.delegate = self
        retryLabel.zPosition = 1
        
        //resultModal
        resultModal = ResultModal()
        resultModal!.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 400)
        uiLayer!.addChild(resultModal!)
        
        resultModal?.showResult()
        
        //self.start()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            //do something

        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        for node : AnyObject in haeLayer!.children{
            
            if (node as SKNode).name == nil  {
                //println("name is nil")
            }
            else{
                if(node.name == "hae"){
                    //Nodes.append(Node as SKNode)
                    var hae = node as Hae
                    if(!hae.isDead){
                        hae.update()
                    }

                }
                
            }
            
        }
    }
    
    func start() {
        
        let contentDownAction = SKAction.moveToY(300, duration: 0.7)
        contentDownAction.timingMode = SKActionTimingMode.EaseInEaseOut
        contentLayer?.runAction(contentDownAction,completion: { () -> Void in
            
            self.uiContainer.hidden = false
            
            //タイマー
            self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimerTrigger:", userInfo: nil, repeats: true)
            
            self.createTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "createHae:", userInfo: nil, repeats: true)
            
        })
        
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
        var _y = getRandomNumber(Min:0,Max:400)
        
        hae.range = CGFloat(getRandomNumber(Min:1,Max:12))
        hae.xs = CGFloat(getRandomNumber(Min:2,Max:10))
        
        if(_y % 2 == 1){
            hae.dir = 0
            _x = (Int(self.frame.width) - Int(deviceWidth))/2 - 200
        }else{
            hae.dir = 1
            hae.xScale = -1
            _x = (Int(self.frame.width) - Int(deviceWidth))/2 + Int(deviceWidth) + 200
        }
        
        hae.position = CGPoint(x:_x,y:_y)
        hae.delegate = self
        haeLayer!.addChild(hae)
    }
    
    func onTimerTrigger(timer : NSTimer){
        
        //time
        currentRemainTime -= 1
        if(currentRemainTime < 0){
            currentRemainTime = remainTime
            timeLabel.text = "0"
            
            uiContainer.hidden = true
            
            let contentDownAction = SKAction.moveToY(0, duration: 0.7)
            contentDownAction.timingMode = SKActionTimingMode.EaseInEaseOut
            contentLayer?.runAction(contentDownAction,completion: { () -> Void in
                //self.uiLayer!.addChild(self.resultModal!)
            })
            
            uiLayer!.addChild(gameoverLabel)
            uiLayer!.addChild(retryLabel)
            
            gameTimer!.invalidate()
            createTimer!.invalidate()
            
            for node : AnyObject in haeLayer!.children{
                
                if((node as SKNode).name != nil && node.name == "hae"){
                    //Nodes.append(Node as SKNode)
                    var _node = node as Hae
                    _node.disableTouch()
                    
                }
                
            }
            
        }else{
            self.timeLabel.text = String(currentRemainTime)
        }
        
    }
    
    func haeTouched(hae:Hae){
        
        score = Int(100 * hae.xs / 2)
        currentScore += score
        
        let pointLabel = SKLabelNode(fontNamed:"Verdana-Bold")
        pointLabel.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
        pointLabel.text = "+" + String(score)
        pointLabel.fontSize = 40
        pointLabel.position = CGPoint(x:hae.position.x, y:hae.position.y)
        
        let a1 = SKAction.fadeAlphaTo(0, duration: 1)
        let a2 = SKAction.moveToY(hae.position.y + 100, duration: 1)
        let ag = SKAction.group([a1, a2])
        pointLabel.runAction(ag, completion: { () -> Void in
            pointLabel.removeFromParent()
        })
        
        haeLayer!.addChild(pointLabel)
        
        scoreLabel.text = String(currentScore)
        runAction(sound)
        
        let a3 = SKAction.fadeAlphaTo(0, duration: 0.5)
        hae.runAction(a3)
    }
    
    func retryTouched(){
        for node : AnyObject in haeLayer!.children{
            
            if((node as SKNode).name != nil && node.name == "hae"){
                //Nodes.append(Node as SKNode)
                var _node = node as Hae
                _node.removeFromParent()
                
            }
            
        }
        
        gameoverLabel.removeFromParent()
        retryLabel.removeFromParent()
        
        score = 0
        currentScore = 0
        scoreLabel.text = "0"
        timeLabel.text = String(remainTime)
        
        self.start()
    }
}
