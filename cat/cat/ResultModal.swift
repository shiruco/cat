//
//  ResultModal.swift
//  cat
//
//  Created by takatatomoyuki on 2015/02/08.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

class ResultModal: SKNode {
    
    let modalHead = SKSpriteNode(imageNamed: "result_head.png")
    let modalHaeNumRow = SKSpriteNode(imageNamed: "result_content.png")
    let modalBabyNumRow = SKSpriteNode(imageNamed: "result_content.png")
    let modalBossNumRow = SKSpriteNode(imageNamed: "result_content.png")
    let modalFoot = SKSpriteNode(imageNamed: "result_foot.png")

    override init() {
        
        super.init()
        
        self.userInteractionEnabled = true
        
        modalHead.anchorPoint = CGPointMake(0.5, 1.0)
        modalHaeNumRow.anchorPoint = CGPointMake(0.5, 1.0)
        modalBabyNumRow.anchorPoint = CGPointMake(0.5, 1.0)
        modalBossNumRow.anchorPoint = CGPointMake(0.5, 1.0)
        modalFoot.anchorPoint = CGPointMake(0.5, 1.0)
        
        modalHead.position = CGPoint(x: 0, y: 0)
        modalHead.color = UIColor.redColor()
        
        modalHaeNumRow.position = CGPoint(x: 0, y: -modalHead.frame.size.height)
        
        modalFoot.position = CGPoint(x: 0, y: -(modalHead.frame.size.height + modalHaeNumRow.frame.size.height))
        
        self.addChild(modalHead)
        self.addChild(modalHaeNumRow)
        self.addChild(modalFoot)
    }
    
    func showResult(){
        let a1 = SKAction.resizeToHeight(100, duration: 0.3)
        a1.timingMode = SKActionTimingMode.EaseIn
        modalHaeNumRow.runAction(a1)
        
        let a2 = SKAction.moveToY(-(modalHead.frame.size.height + modalHaeNumRow.frame.size.height) - 99, duration: 0.3)
        a2.timingMode = SKActionTimingMode.EaseIn
        modalFoot.runAction(a2,completion: { () -> Void in
            self.addChild(SKSpriteNode(imageNamed: "hae_1.png"))
            
            let hae = SKSpriteNode(imageNamed: "hae_1.png")
            hae.xScale = 0.8
            hae.yScale = 0.8
            hae.zPosition = 1
            hae.position = CGPoint(x:-210,y:-50)
            self.modalHaeNumRow.addChild(hae)
            
            let xl = SKLabelNode(fontNamed:"Verdana-Bold")
            xl.zPosition = 1
            xl.text = "x"
            xl.fontSize = 40
            xl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            xl.position = CGPoint(x:-155, y:-80)
            self.modalHaeNumRow.addChild(xl)
            
            let numl = SKLabelNode(fontNamed:"Verdana-Bold")
            numl.zPosition = 1
            numl.text = "100"
            numl.fontSize = 40
            numl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            numl.position = CGPoint(x:-90, y:-80)
            self.modalHaeNumRow.addChild(numl)
            
            let ptl = SKLabelNode(fontNamed:"Verdana-Bold")
            ptl.zPosition = 1
            ptl.text = "200000pt"
            ptl.fontSize = 40
            ptl.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
            ptl.fontColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            ptl.position = CGPoint(x:240, y:-80)
            self.modalHaeNumRow.addChild(ptl)
            
            var points = [CGPointMake(0, 0),CGPointMake(485.0, 0.0)]
            let line = SKShapeNode(points: &points, count: UInt(points.count))
            line.zPosition = 1
            line.lineWidth = 2
            line.position = CGPoint(x:-240.0,y:-100.0)
            line.strokeColor = SKColor(red: 0.19, green: 0.40, blue: 0.00, alpha: 1)
            self.modalHaeNumRow.addChild(line)
            
        })

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



}
