//
//  HaeBaby.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/10.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

protocol HaeBabyDelegate {
    func haeBabyTouched(_ hae:HaeBaby)
}

class HaeBaby: SKNode {
    
    var dir:Int = 0 //0:left 1:right
    
    var angle:CGFloat = 0.0
    
    //振れ幅
    var range:CGFloat = 5.0
    
    //スピード
    var s:CGFloat = 0.1
    
    //x軸方向へのスピード
    var xs:CGFloat = 2.0
    
    var isDead:Bool = false
    
    var delegate: HaeBabyDelegate! = nil
    
    var sp:SKSpriteNode! = nil
    var spHit:SKSpriteNode! = nil
    var hitArea:SKSpriteNode! = nil
    
    override init() {
        super.init()
        
        self.isUserInteractionEnabled = true
        
        let atlas = SKTextureAtlas(named: "hae")
        let hae1 = atlas.textureNamed("baby_1.png")
        let hae2 = atlas.textureNamed("baby_2.png")
        
        sp = SKSpriteNode(texture: hae1)
        let haneAction = SKAction.animate(with: [hae1,hae2], timePerFrame: 0.01)
        let flyAction = SKAction.repeatForever(haneAction)
        sp.run(flyAction)
        self.addChild(sp)
        
        spHit = SKSpriteNode(imageNamed: "baby_hit.png")
        
        hitArea = SKSpriteNode(color: UIColor(red:0,green:0,blue:0,alpha:0), size: CGSize(width: 80, height: 87))
        sp.addChild(hitArea)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(self.isDead){
            return
        }
        
        self.delegate!.haeBabyTouched(self)
        
        for _: AnyObject in touches {
            sp.removeFromParent()
            //self.removeFromParent()
            self.addChild(spHit)
            self.isDead = true
        }
    }
    
    func update(){
        var _x:CGFloat!
        
        if(dir == 0){
            _x = self.position.x + xs
        }else{
            _x = self.position.x - xs
        }
        
        
        let _y = self.position.y + (sin(angle) * range)
        self.position = CGPoint(x:_x,y:_y)
        angle += s;
    }
    
    func disableTouch(){
        self.isUserInteractionEnabled = false
    }
    
    func enableTouch(){
        self.isUserInteractionEnabled = true
    }
}
