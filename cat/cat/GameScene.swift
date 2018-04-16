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
    let deviceWidth = UIScreen.main.nativeBounds.width
    
    let is_iPhoneX: Bool = {
        guard #available(iOS 11.0, *),
            UIDevice().userInterfaceIdiom == .phone else {
                return false
        }
        let nativeSize = UIScreen.main.nativeBounds.size
        let (w, h) = (nativeSize.width, nativeSize.height)
        let (d1, d2): (CGFloat, CGFloat) = (1125.0, 2436.0)
        return (w == d1 && h == d2) || (w == d2 && h == d1)
    }()
    
    var resultModal:ResultModal? = nil
    
    var gameTimer:Timer? = nil
    var createTimer:Timer? = nil
    var createBabyTimer:Timer? = nil
    var createKingTimer:Timer? = nil
    
    //result data
    var resultHaeNum = 0
    var resultHaeNumPoint = 0
    
    var resultBabyHaeNum = 0
    var resultBabyHaeNumPoint = 0
    
    var resultBossHaeNum = 0
    var resultBossHaeNumPoint = 0
    
    override func didMove(to view: SKView) {
        
        //layer
        contentLayer = childNode(withName: "contentLayer")
        bgLayer = contentLayer!.childNode(withName: "bgLayer")
        haeLayer = bgLayer!.childNode(withName: "haeLayer")
        uiLayer = haeLayer!.childNode(withName: "uiLayer")
        
        //bg 350
        bg.position = CGPoint(x:self.frame.midX - 200, y:self.frame.height - 650)
        bgLayer!.addChild(bg)
        
        //UI
        if (is_iPhoneX) {
            uiContainer.position = CGPoint(x:self.frame.midX - 20, y:self.frame.height - 400)
        } else {
            uiContainer.position = CGPoint(x:self.frame.midX, y:self.frame.height - 370)
        }
        uiContainer.isHidden = true
        uiLayer!.addChild(uiContainer)
        
        //score
        ptBg.position = CGPoint(x:150,y:0)
        uiContainer.addChild(ptBg)
        
        scoreLabel.text = "0"
        scoreLabel.fontSize = 40
        scoreLabel.zPosition = 10
        scoreLabel.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
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
        timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        timeLabel.position = CGPoint(x:0, y:-20)
        timeBg.addChild(timeLabel)
        
        //resultModal
        resultModal = ResultModal()
        resultModal!.initY = self.frame.midY + 1000
        resultModal!.moveY = self.frame.midY + 400
        resultModal!.position = CGPoint(x:self.frame.midX, y:resultModal!.initY)
        resultModal!.zPosition = 100
        resultModal!.delegate = self
        uiLayer!.addChild(resultModal!)
        
        self.start()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for _: AnyObject in touches {
            //do something

        }
    }
   
    override func update(_ currentTime: TimeInterval) {
        
        for node : AnyObject in haeLayer!.children{
            
            if (node as! SKNode).name == nil  {
                //println("name is nil")
            }
            else{
                if(node.name == "hae"){
                    //Nodes.append(Node as SKNode)
                    let hae = node as! Hae
                    if(!hae.isDead){
                        hae.update()
                    }
                }
                
                if(node.name == "hae_baby"){
                    //Nodes.append(Node as SKNode)
                    let baby = node as! HaeBaby
                    if(!baby.isDead){
                        baby.update()
                    }
                }
                
                if(node.name == "hae_king"){
                    //Nodes.append(Node as SKNode)
                    let king = node as! HaeKing
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
        
        let contentDownAction = SKAction.moveTo(y: 300, duration: 0.7)
        contentDownAction.timingMode = SKActionTimingMode.easeInEaseOut
        contentLayer?.run(contentDownAction,completion: { () -> Void in
            
            self.uiContainer.isHidden = false
            
            //タイマー
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.onTimerTrigger(_:)), userInfo: nil, repeats: true)
            
            self.createTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(GameScene.createHae(_:)), userInfo: nil, repeats: true)
            
            self.createBabyTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GameScene.createHaeBaby(_:)), userInfo: nil, repeats: true)
            
            self.createKingTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(GameScene.createHaeKing(_:)), userInfo: nil, repeats: true)
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
    
    func createHae(_ timer : Timer){
        //create hae normal
        let hae = Hae()
        hae.name = "hae"
        
        _ = 0 //0:left 1:right
        var _x = 0
        let _y = getRandomNumber(Min:0,Max:400)
        
        hae.range = CGFloat(getRandomNumber(Min:1,Max:12))
        hae.xs = CGFloat(getRandomNumber(Min:2,Max:10))
        
        if(_y > 300){
            run(flySound)
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
    
    func createHaeBaby(_ timer : Timer){
        //create hae baby
        let baby = HaeBaby()
        baby.name = "hae_baby"
        
        _ = 0 //0:left 1:right
        var _x = 0
        let _y = getRandomNumber(Min:0,Max:400)
        
        baby.range = CGFloat(getRandomNumber(Min:1,Max:6))
        baby.xs = CGFloat(getRandomNumber(Min:2,Max:4))
        
        if(_y > 300){
            run(flySound)
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
    
    func createHaeKing(_ timer : Timer){
        
        let king = HaeKing()
        king.name = "hae_king"
        
        _ = 0 //0:left 1:right
        var _x = 0
        let _y = self.getRandomNumber(Min:0,Max:400)
        
        king.range = CGFloat(self.getRandomNumber(Min:2,Max:4))
        king.xs = CGFloat(self.getRandomNumber(Min:14,Max:16))
        
        self.run(self.flySound)
        
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
    
    func onTimerTrigger(_ timer : Timer){
        
        //time
        currentRemainTime -= 1
        if(currentRemainTime < 0){
            
            currentRemainTime = remainTime
            timeLabel.text = "0"
            
            uiContainer.isHidden = true
            
            let contentDownAction = SKAction.moveTo(y: 0, duration: 0.7)
            contentDownAction.timingMode = SKActionTimingMode.easeInEaseOut
            contentLayer?.run(contentDownAction,completion: { () -> Void in
                //self.uiLayer!.addChild(self.resultModal!)
            })
            
            //get result data
            let data = getResultData()
            
            resultModal!.show(data as Array<NSDictionary>)
            
            gameTimer!.invalidate()
            createTimer!.invalidate()
            createBabyTimer!.invalidate()
            createKingTimer!.invalidate()
            
            for node : AnyObject in haeLayer!.children{
                
                if((node as! SKNode).name != nil && node.name == "hae"){
                    let _node = node as! Hae
                    _node.disableTouch()
                }
                if((node as! SKNode).name != nil && node.name == "hae_baby"){
                    let _node = node as! HaeBaby
                    _node.disableTouch()
                }
                if((node as! SKNode).name != nil && node.name == "hae_king"){
                    let _node = node as! HaeKing
                    _node.disableTouch()
                }
                
            }
            
        }else{
            self.timeLabel.text = String(currentRemainTime)
        }
        
    }
    
    func haeTouched(_ hae:Hae){
        
        let score = Int(100 * hae.xs / 2)
        currentScore += score
        
        resultHaeNum += 1
        resultHaeNumPoint += score
        
        let pointLabel = SKLabelNode(fontNamed:"Verdana-Bold")
        pointLabel.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
        pointLabel.text = "+" + String(score)
        pointLabel.fontSize = 40
        pointLabel.position = CGPoint(x:hae.position.x, y:hae.position.y)
        
        let a1 = SKAction.fadeAlpha(to: 0, duration: 1)
        let a2 = SKAction.moveTo(y: hae.position.y + 100, duration: 1)
        let ag = SKAction.group([a1, a2])
        pointLabel.run(ag, completion: { () -> Void in
            pointLabel.removeFromParent()
        })
        
        haeLayer!.addChild(pointLabel)
        
        scoreLabel.text = String(currentScore)
        run(sound)
        
        let a3 = SKAction.fadeAlpha(to: 0, duration: 0.5)
        hae.run(a3)
    }
    
    func haeBabyTouched(_ hae: HaeBaby) {
        let score = Int(100 * hae.xs / 2) * 5
        resultBabyHaeNumPoint += score
        resultBabyHaeNum += 1
        
        run(sound)
        
        let a3 = SKAction.fadeAlpha(to: 0, duration: 0.5)
        hae.run(a3)
    }
    
    func haeKingTouched(_ hae: HaeKing) {
        
        let score = Int(100 * hae.xs / 2) * 5
        currentScore += score
        
        resultBossHaeNum += 1
        resultBossHaeNumPoint += score
        
        let pointLabel = SKLabelNode(fontNamed:"Verdana-Bold")
        pointLabel.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
        pointLabel.text = "+" + String(score)
        pointLabel.fontSize = 40
        pointLabel.position = CGPoint(x:hae.position.x, y:hae.position.y)
        
        let a1 = SKAction.fadeAlpha(to: 0, duration: 1)
        let a2 = SKAction.moveTo(y: hae.position.y + 100, duration: 1)
        let ag = SKAction.group([a1, a2])
        pointLabel.run(ag, completion: { () -> Void in
            pointLabel.removeFromParent()
        })
        
        haeLayer!.addChild(pointLabel)
        
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>")
        print(currentScore)
        
        scoreLabel.text = String(currentScore)
        run(sound)
        
        let a3 = SKAction.fadeAlpha(to: 0, duration: 0.5)
        hae.run(a3)
    }
    
    func topTouched() {
        if controller != nil {
            let c = controller as! GameViewController
            let t:SKTransition = SKTransition.flipVertical(withDuration: 0.7)
            skView!.presentScene(c.mainScene!, transition: t)
        }
    }
    
    func bestScoreUpdate(){
        if controller != nil {
            let c = controller as! GameViewController
            c.bestScoreUpdate()
        }
    }
    
    func tweetBtnTouched(_ pt:Int){
        if controller != nil {
            let c = controller as! GameViewController
            c.tweet(pt)
        }
    }
    
    func fbBtnTouched(_ pt:Int){
        if controller != nil {
            let c = controller as! GameViewController
            c.fbPost(pt)
        }
    }
    
    func retryTouched(){
        for node : AnyObject in haeLayer!.children{
            
            if((node as! SKNode).name != nil && node.name == "hae"){
                let _node = node as! Hae
                _node.removeFromParent()
                
            }
            if((node as! SKNode).name != nil && node.name == "hae_baby"){
                let _node = node as! HaeBaby
                _node.removeFromParent()
                
            }
            if((node as! SKNode).name != nil && node.name == "hae_king"){
                let _node = node as! HaeKing
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
