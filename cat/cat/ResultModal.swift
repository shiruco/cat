//
//  ResultModal.swift
//  cat
//
//  Created by takatatomoyuki on 2015/02/08.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

protocol ResultDelegate {
    func topTouched()
    func retryTouched()
    func tweetBtnTouched(_ pt:Int)
    func fbBtnTouched(_ pt:Int)
    func bestScoreUpdate()
}

class ResultModal: SKNode {
    
    var delegate: ResultDelegate! = nil
    
    var initY: CGFloat = 0.0
    var moveY: CGFloat = 0.0
    
    let modalHead = SKSpriteNode(imageNamed: "result_head.png")
    let modalFoot = SKSpriteNode(imageNamed: "result_foot.png")
    
    let tweetBtn = SKSpriteNode(imageNamed: "tweet_btn.png")
    let fbBtn = SKSpriteNode(imageNamed: "fb_btn.png")
    
    let topBtn = SKSpriteNode(imageNamed: "stop_btn.png")
    let retryBtn = SKSpriteNode(imageNamed: "retry_btn.png")
    
    let btnSound = SKAction.playSoundFileNamed("btn.mp3", waitForCompletion: false)
    let ptSound = SKAction.playSoundFileNamed("pt.mp3", waitForCompletion: false)
    let sumSound = SKAction.playSoundFileNamed("sum.mp3", waitForCompletion: false)
    
    var sumPoint = 0
    
    let rowHeight = 100
    var contentHeight = 0
    
    var resultData = Array<NSDictionary>()
    
    var rows = Array<SKSpriteNode>()

    override init() {
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        modalHead.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        modalFoot.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        modalHead.position = CGPoint(x: 0, y: 0)
        modalHead.color = UIColor.red
        
        modalFoot.position = CGPoint(x: 0, y: -modalHead.frame.size.height)
        
        self.addChild(modalHead)
        self.addChild(modalFoot)
    }
    
    func show(_ data:Array<NSDictionary>){
        resultData = data
        
        if(resultData.count > 0){
            let a1 = SKAction.moveTo(y: self.moveY, duration: 1.0)
            a1.timingMode = SKActionTimingMode.easeIn
            self.run(a1,completion: { () -> Void in
                self.showResult()
            })
        }
    }
    
    func hide(){
        let a1 = SKAction.moveTo(y: self.initY, duration: 1.0)
        a1.timingMode = SKActionTimingMode.easeIn
        self.run(a1,completion: { () -> Void in
            self.initRows()
            self.sumPoint = 0
        })
    }
    
    func initRows(){
        self.topBtn.removeFromParent()
        self.retryBtn.removeFromParent()
        
        self.rows.forEach {
            $0.removeFromParent()
        }
        
        modalFoot.position = CGPoint(x: 0, y: -modalHead.frame.size.height)
        
        contentHeight = 0
    }
    
    func showResult(){
        
        //calc summary
        resultData.forEach {
            var type: String
            var point: String
            type = $0["type"] as! String
            point = $0["point"] as! String
            if(type == "baby"){
                sumPoint -= NumberFormatter().number(from: point) as! Int
            }else{
                sumPoint += NumberFormatter().number(from: point) as! Int
            }
        }
        
        addRow()
    }
    
    func addRow(){
        
        var data:[String:String] = [:]
        
        if(resultData.count > 0){
            data = resultData[0] as! Dictionary<String, String>
        }else{
            self.showSum()
            return
        }
        
        let modalHaeNumRow = SKSpriteNode(imageNamed: "result_content.png")
        modalHaeNumRow.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        modalHaeNumRow.position = CGPoint(x: 0, y: -modalHead.frame.size.height - CGFloat(contentHeight))
        self.addChild(modalHaeNumRow)
        
        rows.append(modalHaeNumRow)
        
        contentHeight += 100
        
        let a1 = SKAction.resize(toHeight: CGFloat(rowHeight), duration: 0.3)
        //a1.timingMode = SKActionTimingMode.EaseOut
        modalHaeNumRow.run(a1)
        
        let a2 = SKAction.moveTo(y: -(modalHead.frame.size.height + modalHaeNumRow.frame.size.height) - CGFloat(contentHeight - 1), duration: 0.4)
        //a2.timingMode = SKActionTimingMode.EaseOut
        modalFoot.run(a2,completion: { () -> Void in
            var hae:SKSpriteNode!
            if(data["type"] == "baby"){
                hae = SKSpriteNode(imageNamed: "baby_1.png")
                hae.xScale = 0.8
                hae.yScale = 0.8
                hae.zPosition = 1
                hae.position = CGPoint(x:-210,y:-50)
                hae.isHidden = true
                modalHaeNumRow.addChild(hae)
            }else if(data["type"] == "boss"){
                hae = SKSpriteNode(imageNamed: "boss_1.png")
                hae.xScale = 0.8
                hae.yScale = 0.8
                hae.zPosition = 1
                hae.position = CGPoint(x:-210,y:-50)
                hae.isHidden = true
                modalHaeNumRow.addChild(hae)
            }else{
                hae = SKSpriteNode(imageNamed: "hae_1.png")
                hae.xScale = 0.8
                hae.yScale = 0.8
                hae.zPosition = 1
                hae.position = CGPoint(x:-210,y:-50)
                hae.isHidden = true
                modalHaeNumRow.addChild(hae)
            }
            
            let xl = SKLabelNode(fontNamed:"Verdana-Bold")
            xl.zPosition = 1
            xl.text = "x"
            xl.fontSize = 40
            xl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            xl.position = CGPoint(x:-145, y:-80)
            xl.isHidden = true
            modalHaeNumRow.addChild(xl)
            
            let numl = SKLabelNode(fontNamed:"Verdana-Bold")
            numl.zPosition = 1
            numl.text = data["num"]!
            numl.fontSize = 40
            numl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            numl.position = CGPoint(x:-90, y:-80)
            numl.isHidden = true
            modalHaeNumRow.addChild(numl)
            
            let ptl = SKLabelNode(fontNamed:"Verdana-Bold")
            ptl.zPosition = 1
            
            if(data["type"] != "baby"){
                ptl.text = data["point"]! + "pt"
            }else{
                ptl.text = "-" + data["point"]! + "pt"
            }
            
            ptl.fontSize = 40
            ptl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
            ptl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            ptl.position = CGPoint(x:240, y:-80)
            ptl.isHidden = true
            modalHaeNumRow.addChild(ptl)
            
            var points = [CGPoint(x: 0, y: 0),CGPoint(x: 485.0, y: 0.0)]
            let line = SKShapeNode(points: &points, count: points.count)
            line.zPosition = 1
            line.lineWidth = 2
            line.position = CGPoint(x:-240.0,y:-100.0)
            line.strokeColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            modalHaeNumRow.addChild(line)
            
            let dict1 = ["target":hae]
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ResultModal.showSprite(_:)), userInfo: dict1, repeats: false)
            
            let dict2 = ["target":xl]
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ResultModal.showLabel(_:)), userInfo: dict2, repeats: false)
            
            let dict3 = ["target":numl]
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ResultModal.showLabel(_:)), userInfo: dict3, repeats: false)
            
            let dict4 = ["target":ptl]
            _ = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(ResultModal.showLabel(_:)), userInfo: dict4, repeats: false)
            
            _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(ResultModal.addRowComplete(_:)), userInfo: nil, repeats: false)
        })
    }
    
    func showSprite(_ timer : Timer){
        let dict = timer.userInfo as! Dictionary<String, SKSpriteNode>
        dict["target"]!.isHidden = false
    }
    
    func showLabel(_ timer : Timer){
        let dict = timer.userInfo as! Dictionary<String, SKLabelNode>
        dict["target"]!.isHidden = false
    }
    
    func showBest(_ timer : Timer){
        run(sumSound)
        let container = timer.userInfo as! SKSpriteNode
        let bestScore = SKSpriteNode(imageNamed: "best.png")
        bestScore.position = CGPoint(x:70, y:-15)
        bestScore.zPosition = 1
        container.addChild(bestScore)
    }
    
    func addRowComplete(_ timer : Timer){
        resultData.remove(at: 0)
        addRow()
    }
    
    func addSumComplete(_ timer : Timer){
        showBtns()
    }
    
    func showSum(){
        
        //best score判定
        var isBestScore = false
        var bestPt = UserDataUtil.getPointData()
        
        if(bestPt <= 0){
            UserDataUtil.setPointData(self.sumPoint)
            bestPt = self.sumPoint
            isBestScore = true
        }else if(bestPt < self.sumPoint){
            UserDataUtil.setPointData(self.sumPoint)
            isBestScore = true
        }
        
        
        let modalHaeNumRow = SKSpriteNode(imageNamed: "result_content.png")
        modalHaeNumRow.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        modalHaeNumRow.position = CGPoint(x: 0, y: -modalHead.frame.size.height - CGFloat(contentHeight))
        self.addChild(modalHaeNumRow)
        rows.append(modalHaeNumRow)
        
        contentHeight += 60
        
        let a1 = SKAction.resize(toHeight: CGFloat(rowHeight), duration: 0.3)
        modalHaeNumRow.run(a1)
        
        let a2 = SKAction.moveTo(y: -(modalHead.frame.size.height + modalHaeNumRow.frame.size.height) - CGFloat(contentHeight + 20), duration: 0.3)
        modalFoot.run(a2,completion: { () -> Void in
            
            let sum = SKSpriteNode(imageNamed: "sum.png")
            sum.isHidden = true
            sum.position = CGPoint(x:0, y:-50)
            modalHaeNumRow.addChild(sum)
            
            let dict1 = ["target":sum]
            _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ResultModal.showSprite(_:)), userInfo: dict1, repeats: false)
            
            let sptl = SKLabelNode(fontNamed:"Verdana-Bold")
            sptl.zPosition = 1
            
            sptl.text = String(self.sumPoint) + "pt"
            sptl.fontSize = 40
            sptl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
            sptl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            sptl.position = CGPoint(x:240, y:-60)
            sptl.isHidden = true
            modalHaeNumRow.addChild(sptl)
            
            if(isBestScore){
                self.delegate!.bestScoreUpdate()
                _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ResultModal.showBest(_:)), userInfo: modalHaeNumRow, repeats: false)
            }
            
            let dict2 = ["target":sptl]
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(ResultModal.showLabel(_:)), userInfo: dict2, repeats: false)
            
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ResultModal.addSumComplete(_:)), userInfo: nil, repeats: false)
        })
    }
    
    func showBtns(){
        let modalHaeNumRow = SKSpriteNode(imageNamed: "result_content.png")
        modalHaeNumRow.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        modalHaeNumRow.position = CGPoint(x: 0, y: -modalHead.frame.size.height - CGFloat(contentHeight))
        self.addChild(modalHaeNumRow)
        rows.append(modalHaeNumRow)
        
        contentHeight += 80
        
        let a1 = SKAction.resize(toHeight: CGFloat(rowHeight), duration: 0.3)
        modalHaeNumRow.run(a1)
        
        let a2 = SKAction.moveTo(y: -(modalHead.frame.size.height + modalHaeNumRow.frame.size.height) - CGFloat(contentHeight - 1), duration: 0.4)
        
        modalFoot.run(a2,completion: { () -> Void in
            self.topBtn.zPosition = 1
            self.topBtn.name = "top_btn"
            self.topBtn.position = CGPoint(x:-110,y:-85)
            modalHaeNumRow.addChild(self.topBtn)
            
            self.retryBtn.zPosition = 1
            self.retryBtn.name = "retry_btn"
            self.retryBtn.position = CGPoint(x:110,y:-85)
            modalHaeNumRow.addChild(self.retryBtn)
            
            //share btns
            self.tweetBtn.zPosition = 1
            self.tweetBtn.name = "tweet_btn"
            self.tweetBtn.position = CGPoint(x:150,y:-45)
            self.modalHead.addChild(self.tweetBtn)
            
            self.fbBtn.zPosition = 1
            self.fbBtn.name = "fb_btn"
            self.fbBtn.position = CGPoint(x:220,y:-45)
            self.modalHead.addChild(self.fbBtn)

        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            //var t: UITouch = touch as UITouch
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            if(touchedNode.name == "top_btn"){
                self.delegate!.topTouched()
                self.tweetBtn.removeFromParent()
                self.fbBtn.removeFromParent()
                run(btnSound)
            }else if(touchedNode.name == "retry_btn"){
                self.delegate!.retryTouched()
                self.tweetBtn.removeFromParent()
                self.fbBtn.removeFromParent()
                run(btnSound)
            }else if(touchedNode.name == "tweet_btn"){
                self.delegate!.tweetBtnTouched(self.sumPoint)
                run(btnSound)
            }else if(touchedNode.name == "fb_btn"){
                self.delegate!.fbBtnTouched(self.sumPoint)
                run(btnSound)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
