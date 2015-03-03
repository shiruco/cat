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
}

class ResultModal: SKNode {
    
    var delegate: ResultDelegate! = nil
    
    var initY: CGFloat = 0.0
    var moveY: CGFloat = 0.0
    
    let modalHead = SKSpriteNode(imageNamed: "result_head.png")
    let modalFoot = SKSpriteNode(imageNamed: "result_foot.png")
    
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
        
        self.userInteractionEnabled = true
        
        modalHead.anchorPoint = CGPointMake(0.5, 1.0)
        modalFoot.anchorPoint = CGPointMake(0.5, 1.0)
        
        modalHead.position = CGPoint(x: 0, y: 0)
        modalHead.color = UIColor.redColor()
        
        modalFoot.position = CGPoint(x: 0, y: -modalHead.frame.size.height)
        
        self.addChild(modalHead)
        self.addChild(modalFoot)
    }
    
    func show(data:Array<NSDictionary>){
        resultData = data
        
        if(resultData.count > 0){
            let a1 = SKAction.moveToY(self.moveY, duration: 1.0)
            a1.timingMode = SKActionTimingMode.EaseIn
            self.runAction(a1,completion: { () -> Void in
                self.showResult()
            })
        }
    }
    
    func hide(){
        let a1 = SKAction.moveToY(self.initY, duration: 1.0)
        a1.timingMode = SKActionTimingMode.EaseIn
        self.runAction(a1,completion: { () -> Void in
            self.initRows()
            self.sumPoint = 0
        })
    }
    
    func initRows(){
        self.topBtn.removeFromParent()
        self.retryBtn.removeFromParent()
        
        for(var i=0; i < self.rows.count; i++){
            self.rows[i].removeFromParent()
        }
        
        modalFoot.position = CGPoint(x: 0, y: -modalHead.frame.size.height)
        
        contentHeight = 0
    }
    
    func showResult(){
        
        //calc summary
        for(var i=0; i < resultData.count; i++){
            let data = self.resultData[i] as Dictionary<String, String>
            
            if(data["type"] == "baby"){
                sumPoint -= (data["point"]!.toInt()!)
            }else{
                sumPoint += (data["point"]!.toInt()!)
            }
        }
        
        addRow()
    }
    
    func addRow(){
        
        var data:[String:String] = [:]
        
        if(resultData.count > 0){
            data = resultData[0] as Dictionary<String, String>
        }else{
            self.showSum()
            return
        }
        
        let modalHaeNumRow = SKSpriteNode(imageNamed: "result_content.png")
        modalHaeNumRow.anchorPoint = CGPointMake(0.5, 1.0)
        modalHaeNumRow.position = CGPoint(x: 0, y: -modalHead.frame.size.height - CGFloat(contentHeight))
        self.addChild(modalHaeNumRow)
        
        rows.append(modalHaeNumRow)
        
        contentHeight += 100
        
        let a1 = SKAction.resizeToHeight(CGFloat(rowHeight), duration: 0.3)
        //a1.timingMode = SKActionTimingMode.EaseOut
        modalHaeNumRow.runAction(a1)
        
        let a2 = SKAction.moveToY(-(modalHead.frame.size.height + modalHaeNumRow.frame.size.height) - CGFloat(contentHeight - 1), duration: 0.4)
        //a2.timingMode = SKActionTimingMode.EaseOut
        modalFoot.runAction(a2,completion: { () -> Void in
            //self.addChild(SKSpriteNode(imageNamed: "hae_1.png"))
            
            var hae:SKSpriteNode!
            if(data["type"] == "baby"){
                hae = SKSpriteNode(imageNamed: "baby_1.png")
                hae.xScale = 0.8
                hae.yScale = 0.8
                hae.zPosition = 1
                hae.position = CGPoint(x:-210,y:-50)
                hae.hidden = true
                modalHaeNumRow.addChild(hae)
            }else if(data["type"] == "boss"){
                hae = SKSpriteNode(imageNamed: "boss_1.png")
                hae.xScale = 0.8
                hae.yScale = 0.8
                hae.zPosition = 1
                hae.position = CGPoint(x:-210,y:-50)
                hae.hidden = true
                modalHaeNumRow.addChild(hae)
            }else{
                hae = SKSpriteNode(imageNamed: "hae_1.png")
                hae.xScale = 0.8
                hae.yScale = 0.8
                hae.zPosition = 1
                hae.position = CGPoint(x:-210,y:-50)
                hae.hidden = true
                modalHaeNumRow.addChild(hae)
            }
            
            let xl = SKLabelNode(fontNamed:"Verdana-Bold")
            xl.zPosition = 1
            xl.text = "x"
            xl.fontSize = 40
            xl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            xl.position = CGPoint(x:-145, y:-80)
            xl.hidden = true
            modalHaeNumRow.addChild(xl)
            
            let numl = SKLabelNode(fontNamed:"Verdana-Bold")
            numl.zPosition = 1
            numl.text = data["num"]!
            numl.fontSize = 40
            numl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            numl.position = CGPoint(x:-90, y:-80)
            numl.hidden = true
            modalHaeNumRow.addChild(numl)
            
            let ptl = SKLabelNode(fontNamed:"Verdana-Bold")
            ptl.zPosition = 1
            
            if(data["type"] != "baby"){
                ptl.text = data["point"]! + "pt"
            }else{
                ptl.text = "-" + data["point"]! + "pt"
            }
            
            ptl.fontSize = 40
            ptl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            ptl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            ptl.position = CGPoint(x:240, y:-80)
            ptl.hidden = true
            modalHaeNumRow.addChild(ptl)
            
            var points = [CGPointMake(0, 0),CGPointMake(485.0, 0.0)]
            let line = SKShapeNode(points: &points, count: UInt(points.count))
            line.zPosition = 1
            line.lineWidth = 2
            line.position = CGPoint(x:-240.0,y:-100.0)
            line.strokeColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            modalHaeNumRow.addChild(line)
            
            let dict1 = ["target":hae]
            var timer1 = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "showSprite:", userInfo: dict1, repeats: false)
            
            let dict2 = ["target":xl]
            var timer2 = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "showLabel:", userInfo: dict2, repeats: false)
            
            let dict3 = ["target":numl]
            var timer3 = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "showLabel:", userInfo: dict3, repeats: false)
            
            let dict4 = ["target":ptl]
            var timer4 = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: "showLabel:", userInfo: dict4, repeats: false)
            
            var timer5 = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "addRowComplete:", userInfo: nil, repeats: false)
        })
    }
    
    func showSprite(timer : NSTimer){
        let dict = timer.userInfo as Dictionary<String, SKSpriteNode>
        dict["target"]!.hidden = false
    }
    
    func showLabel(timer : NSTimer){
        let dict = timer.userInfo as Dictionary<String, SKLabelNode>
        dict["target"]!.hidden = false
    }
    
    func addRowComplete(timer : NSTimer){
        resultData.removeAtIndex(0)
        addRow()
    }
    
    func addSumComplete(timer : NSTimer){
        showBtns()
        self.runAction(self.ptSound)
    }

    
    func showSum(){
        let modalHaeNumRow = SKSpriteNode(imageNamed: "result_content.png")
        modalHaeNumRow.anchorPoint = CGPointMake(0.5, 1.0)
        modalHaeNumRow.position = CGPoint(x: 0, y: -modalHead.frame.size.height - CGFloat(contentHeight))
        self.addChild(modalHaeNumRow)
        rows.append(modalHaeNumRow)
        
        contentHeight += 60
        
        let a1 = SKAction.resizeToHeight(CGFloat(rowHeight), duration: 0.3)
        modalHaeNumRow.runAction(a1)
        
        let a2 = SKAction.moveToY(-(modalHead.frame.size.height + modalHaeNumRow.frame.size.height) - CGFloat(contentHeight + 20), duration: 0.3)
        modalFoot.runAction(a2,completion: { () -> Void in
            
            let sum = SKSpriteNode(imageNamed: "sum.png")
            sum.hidden = true
            sum.position = CGPoint(x:0, y:-50)
            modalHaeNumRow.addChild(sum)
            
            let dict1 = ["target":sum]
            var timer1 = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "showSprite:", userInfo: dict1, repeats: false)
            
            let sptl = SKLabelNode(fontNamed:"Verdana-Bold")
            sptl.zPosition = 1
            
            sptl.text = String(self.sumPoint) + "pt"
            sptl.fontSize = 40
            sptl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            sptl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            sptl.position = CGPoint(x:240, y:-60)
            sptl.hidden = true
            modalHaeNumRow.addChild(sptl)
            
            let dict2 = ["target":sptl]
            var timer2 = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "showLabel:", userInfo: dict2, repeats: false)
            
            var timer3 = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "addSumComplete:", userInfo: nil, repeats: false)
        })
    }
    
    func showBtns(){
        let modalHaeNumRow = SKSpriteNode(imageNamed: "result_content.png")
        modalHaeNumRow.anchorPoint = CGPointMake(0.5, 1.0)
        modalHaeNumRow.position = CGPoint(x: 0, y: -modalHead.frame.size.height - CGFloat(contentHeight))
        self.addChild(modalHaeNumRow)
        rows.append(modalHaeNumRow)
        
        contentHeight += 80
        
        let a1 = SKAction.resizeToHeight(CGFloat(rowHeight), duration: 0.3)
        modalHaeNumRow.runAction(a1)
        
        let a2 = SKAction.moveToY(-(modalHead.frame.size.height + modalHaeNumRow.frame.size.height) - CGFloat(contentHeight - 1), duration: 0.4)
        modalFoot.runAction(a2,completion: { () -> Void in
            self.topBtn.zPosition = 1
            self.topBtn.name = "top_btn"
            self.topBtn.position = CGPoint(x:-110,y:-85)
            modalHaeNumRow.addChild(self.topBtn)
            
            self.retryBtn.zPosition = 1
            self.retryBtn.name = "retry_btn"
            self.retryBtn.position = CGPoint(x:110,y:-85)
            modalHaeNumRow.addChild(self.retryBtn)
        })
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        //self.delegate!.haeTouched(self)
        
        for touch: AnyObject in touches {
            //var t: UITouch = touch as UITouch
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if(touchedNode.name == "top_btn"){
                self.delegate!.topTouched()
                runAction(btnSound)
            }else if(touchedNode.name == "retry_btn"){
                self.delegate!.retryTouched()
                runAction(btnSound)
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}
