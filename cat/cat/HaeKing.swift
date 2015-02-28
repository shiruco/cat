//
//  HaeKing.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/10.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

protocol HaeKingDelegate {
    func haeKingTouched(hae:HaeKing)
}

class HaeKing: SKNode {
    
    var defeatTapNum = 30
    
    var dir:Int = 0 //0:left 1:right
    
    var angle:CGFloat = 0.0
    
    //振れ幅
    var range:CGFloat = 5.0
    
    //スピード
    var s:CGFloat = 0.1
    
    //x軸方向へのスピード
    var xs:CGFloat = 2.0
    
    var isDead:Bool = false
    
    var isLocked:Bool = false
    
    var delegate: HaeKingDelegate! = nil
    
    let sp:SKSpriteNode! = nil
    let spHit:SKSpriteNode! = nil
    let hitArea:SKSpriteNode! = nil
    
    override init() {
        super.init()
        
        self.userInteractionEnabled = true
        
        let atlas = SKTextureAtlas(named: "hae")
        let hae1 = atlas.textureNamed("boss_1.png")
        let hae2 = atlas.textureNamed("boss_2.png")
        
        sp = SKSpriteNode(texture: hae1)
        sp.name = "sp"
        let haneAction = SKAction.animateWithTextures([hae1,hae2], timePerFrame: 0.01)
        let flyAction = SKAction.repeatActionForever(haneAction)
        sp.runAction(flyAction)
        self.addChild(sp)
        
        spHit = SKSpriteNode(imageNamed: "boss_hit.png")
        spHit.name = "spHit"
        
        hitArea = SKSpriteNode(color: UIColor(red:0,green:0,blue:0,alpha:0), size: CGSize(width: 500, height: 496))
        sp.addChild(hitArea)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if(self.isDead){
            return
        }
        
        self.delegate!.haeKingTouched(self)
        
        for touch: AnyObject in touches {
            
            if(self.childNodeWithName("sp") != nil){
                sp.removeFromParent()
            }
            if(self.childNodeWithName("spHit") == nil){
                self.addChild(spHit)
            }
            
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        if(self.isDead){
            return
        }
        
        super.touchesEnded(touches, withEvent: event)
        
        for touch: AnyObject in touches {
            if(self.childNodeWithName("sp") == nil){
                self.addChild(sp)
            }
            if(self.childNodeWithName("spHit") != nil){
                spHit.removeFromParent()
            }
        }
    }
    
    func defeated(){
        isDead = true
        if(self.childNodeWithName("sp") != nil){
            sp.removeFromParent()
        }
        if(self.childNodeWithName("spHit") != nil){
            spHit.removeFromParent()
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