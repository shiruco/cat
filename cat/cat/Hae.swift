//
//  Hae.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/10.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

protocol HaeDelegate {
    func haeTouched(hae:Hae)
}

class Hae: SKNode {
    
    var dir:Int = 0 //0:left 1:right
    
    var angle:CGFloat = 0.0
    
    //振れ幅
    var range:CGFloat = 5.0
    
    //スピード
    var s:CGFloat = 0.1
    
    //x軸方向へのスピード
    var xs:CGFloat = 2.0
    
    var delegate: HaeDelegate! = nil
    
    //let sp = SKSpriteNode(texture: nil, color: UIColor.redColor(), size: CGSize(width:100,height:100))
    let sp = SKSpriteNode(imageNamed: "hae_1.png")

    override init() {
        
        super.init()
        
        self.userInteractionEnabled = true
        
        self.addChild(sp)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        println(self)
        self.delegate!.haeTouched(self)
        
        for touch: AnyObject in touches {
            sp.removeFromParent()
            self.removeFromParent()
        }
    }

    func update(){
        var _x:CGFloat!
        
        if(dir == 0){
            _x = self.position.x + xs
        }else{
            _x = self.position.x - xs
        }
        
        
        var _y = self.position.y + (sin(angle) * range)
        self.position = CGPoint(x:_x,y:_y)
        angle += s;
    }
    
    func disableTouch(){
        self.userInteractionEnabled = false
    }

    func enableTouch(){
        self.userInteractionEnabled = true
    }
}