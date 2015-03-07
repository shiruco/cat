//
//  GameScene.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, HaeDelegate, HaeBabyDelegate, HaeKingDelegate, ResultDelegate {
    
    let remainTime = 30
    var currentRemainTime = 30
    var currentScore = 0
    
    var skView:SKView?
    var controller:UIViewController?
    
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
    let sound = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    let flySound = SKAction.playSoundFileNamed("fly.mp3", waitForCompletion: false)
    let deviceWidth = UIScreen.mainScreen().nativeBounds.width
    
    var resultModal:ResultModal? = nil
    
    var gameTimer:NSTimer? = nil
    var createTimer:NSTimer? = nil
    var createBabyTimer:NSTimer? = nil
    var createKingTimer:NSTimer? = nil
    
    //result data
    var resultHaeNum = 0
    var resultHaeNumPoint = 0
    
    var resultBabyHaeNum = 0
    var resultBabyHaeNumPoint = 0
    
    var resultBossHaeNum = 0
    var resultBossHaeNumPoint = 0
    
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
        
        //resultModal
        resultModal = ResultModal()
        resultModal!.initY = CGRectGetMidY(self.frame) + 1000
        resultModal!.moveY = CGRectGetMidY(self.frame) + 400
        resultModal!.position = CGPoint(x:CGRectGetMidX(self.frame), y:resultModal!.initY)
        resultModal!.zPosition = 100
        resultModal!.delegate = self
        uiLayer!.addChild(resultModal!)
        
        self.start()
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
                
                if(node.name == "hae_baby"){
                    //Nodes.append(Node as SKNode)
                    var baby = node as HaeBaby
                    if(!baby.isDead){
                        baby.update()
                    }
                }
                
                if(node.name == "hae_king"){
                    //Nodes.append(Node as SKNode)
                    var king = node as HaeKing
                    if(!king.isDead){
                        king.update()
                    }
                }
                
            }
            
        }
    }
    
    func start() {
        
        resultHaeNum = 0
        resultHaeNumPoint = 0
        resultBabyHaeNum = 0
        resultBabyHaeNumPoint = 0
        resultBossHaeNum = 0
        resultBossHaeNumPoint = 0
        
        let contentDownAction = SKAction.moveToY(300, duration: 0.7)
        contentDownAction.timingMode = SKActionTimingMode.EaseInEaseOut
        contentLayer?.runAction(contentDownAction,completion: { () -> Void in
            
            self.uiContainer.hidden = false
            
            //タイマー
            self.gameTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimerTrigger:", userInfo: nil, repeats: true)
            
            self.createTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "createHae:", userInfo: nil, repeats: true)
            
            self.createBabyTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "createHaeBaby:", userInfo: nil, repeats: true)
            
            self.createKingTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "createHaeKing:", userInfo: nil, repeats: true)
        })
    }
    
    func getResultData() -> Array<Dictionary<String,String>> {
        
        //resultdata 
        var arr:Array = Array<Dictionary<String,String>>()
        
        //hae
        var d = [String:String]()
        d["type"] = "normal"
        d["num"] = String(resultHaeNum)
        d["point"] = String(resultHaeNumPoint)
        arr.append(d)
        
        //if hit baby
        if(resultBabyHaeNumPoint > 0){
            d = [String:String]()
            d["type"] = "baby"
            d["num"] = String(resultBabyHaeNum)
            d["point"] = String(resultBabyHaeNumPoint)
            arr.append(d)
        }
        
        //if defeat king
        if(resultBossHaeNumPoint > 0){
            d = [String:String]()
            d["type"] = "boss"
            d["num"] = String(resultBossHaeNum)
            d["point"] = String(resultBossHaeNumPoint)
            arr.append(d)
        }
        
        return arr
    }
    
    func getRandomNumber(Min _Min : Int, Max _Max : Int)->Int {
        return Int(arc4random_uniform(UInt32(_Max))) + _Min
    }
    
    func createHae(timer : NSTimer){
        //create hae normal
        let hae = Hae()
        hae.name = "hae"
        
        var _dir = 0 //0:left 1:right
        var _x = 0
        var _y = getRandomNumber(Min:0,Max:400)
        
        hae.range = CGFloat(getRandomNumber(Min:1,Max:12))
        hae.xs = CGFloat(getRandomNumber(Min:2,Max:10))
        
        if(_y > 300){
            runAction(flySound)
        }
        
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
    
    func createHaeBaby(timer : NSTimer){
        //create hae baby
        let baby = HaeBaby()
        baby.name = "hae_baby"
        
        var _dir = 0 //0:left 1:right
        var _x = 0
        var _y = getRandomNumber(Min:0,Max:400)
        
        baby.range = CGFloat(getRandomNumber(Min:1,Max:6))
        baby.xs = CGFloat(getRandomNumber(Min:2,Max:4))
        
        if(_y > 300){
            runAction(flySound)
        }
        
        if(_y % 2 == 1){
            baby.dir = 0
            _x = (Int(self.frame.width) - Int(deviceWidth))/2 - 200
        }else{
            baby.dir = 1
            baby.xScale = -1
            _x = (Int(self.frame.width) - Int(deviceWidth))/2 + Int(deviceWidth) + 200
        }
        
        baby.position = CGPoint(x:_x,y:_y)
        baby.delegate = self
        haeLayer!.addChild(baby)
    }
    
    func createHaeKing(timer : NSTimer){
        
        let king = HaeKing()
        king.name = "hae_king"
        
        var _dir = 0 //0:left 1:right
        var _x = 0
        var _y = self.getRandomNumber(Min:0,Max:400)
        
        king.range = CGFloat(self.getRandomNumber(Min:2,Max:4))
        king.xs = CGFloat(self.getRandomNumber(Min:14,Max:16))
        
        self.runAction(self.flySound)
        
        if(_y % 2 == 1){
            king.dir = 0
            _x = (Int(self.frame.width) - Int(deviceWidth))/2 - 200
        }else{
            king.dir = 1
            king.xScale = -1
            _x = (Int(self.frame.width) - Int(deviceWidth))/2 + Int(deviceWidth) + 200
        }
        
        king.position = CGPoint(x:_x,y:_y)
        king.delegate = self
        king.zPosition = 50
        self.haeLayer!.addChild(king)
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
            
            //get result data
            let data = getResultData()
            
            resultModal!.show(data)
            
            gameTimer!.invalidate()
            createTimer!.invalidate()
            createBabyTimer!.invalidate()
            createKingTimer!.invalidate()
            
            for node : AnyObject in haeLayer!.children{
                
                if((node as SKNode).name != nil && node.name == "hae"){
                    var _node = node as Hae
                    _node.disableTouch()
                }
                if((node as SKNode).name != nil && node.name == "hae_baby"){
                    var _node = node as HaeBaby
                    _node.disableTouch()
                }
                if((node as SKNode).name != nil && node.name == "hae_king"){
                    var _node = node as HaeKing
                    _node.disableTouch()
                }
                
            }
            
        }else{
            self.timeLabel.text = String(currentRemainTime)
        }
        
    }
    
    func haeTouched(hae:Hae){
        
        var score = Int(100 * hae.xs / 2)
        currentScore += score
        
        resultHaeNum++
        resultHaeNumPoint += score
        
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
    
    func haeBabyTouched(hae: HaeBaby) {
        var score = Int(100 * hae.xs / 2) * 5
        resultBabyHaeNumPoint += score
        resultBabyHaeNum++
        
        runAction(sound)
        
        let a3 = SKAction.fadeAlphaTo(0, duration: 0.5)
        hae.runAction(a3)
    }
    
    func haeKingTouched(hae: HaeKing) {
        
        var score = Int(100 * hae.xs / 2) * 5
        currentScore += score
        
        resultBossHaeNum++
        resultBossHaeNumPoint += score
        
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
    
    func topTouched() {
        if controller != nil {
            let c = controller as GameViewController
            let t:SKTransition = SKTransition.flipVerticalWithDuration(0.7)
            skView!.presentScene(c.mainScene, transition: t)
			c.showInterstitial()
        }
    }
	
	func bestScoreUpdate(){
		if controller != nil {
			let c = controller as GameViewController
			c.bestScoreUpdate()
		}
	}
	
	func tweetBtnTouched(pt:Int){
		if controller != nil {
			let c = controller as GameViewController
			c.tweet(pt)
		}
	}
	
	func fbBtnTouched(pt:Int){
		if controller != nil {
			let c = controller as GameViewController
			c.fbPost(pt)
		}
	}
    
    func retryTouched(){
        for node : AnyObject in haeLayer!.children{
            
            if((node as SKNode).name != nil && node.name == "hae"){
                var _node = node as Hae
                _node.removeFromParent()
                
            }
            if((node as SKNode).name != nil && node.name == "hae_baby"){
                var _node = node as HaeBaby
                _node.removeFromParent()
                
            }
            if((node as SKNode).name != nil && node.name == "hae_king"){
                var _node = node as HaeKing
                _node.removeFromParent()
                
            }
        }
        
        resultModal!.hide()
        
        currentScore = 0
        scoreLabel.text = "0"
        timeLabel.text = String(remainTime)
        
        self.start()
    }
}
