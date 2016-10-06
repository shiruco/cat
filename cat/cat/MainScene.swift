//
//  MainScene.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

protocol MainSceneDelegate {
    func startBtnTouched()
    func rankingBtnTouched()
    func howtoBtnTouched()
}

class MainScene: SKScene {
    
    var initialized:Bool = false
    
    var mainSceneDelegate:MainSceneDelegate?
    
    let verLabel = SKLabelNode(fontNamed:"Verdana")
    let btnSound = SKAction.playSoundFileNamed("btn.mp3", waitForCompletion: false)
    
    let title = SKSpriteNode(imageNamed: "title_main.png")
    
    //btn
    let startBtn = SKSpriteNode(imageNamed: "start_btn.png")
    let howtoBtn = SKSpriteNode(imageNamed: "howto_btn.png")
    let rankingBtn = SKSpriteNode(imageNamed: "ranking_btn.png")
    
    let deviceWidth = UIScreen.main.nativeBounds.width
    
    //layers
    var bgLayer:SKNode? = nil
    var haeLayer:SKNode? = nil
    
    let bg = SKSpriteNode(imageNamed: "room.png")
    let bgInitialPosX:CGFloat = 750.0
    
    var createTimer:Timer? = nil
    var createBabyTimer:Timer? = nil
    
    override func didMove(to view: SKView) {
        
        //layer
        bgLayer = self.childNode(withName: "bgLayer")
        haeLayer = bgLayer!.childNode(withName: "haeLayer")
        
        //bg 350
        bg.position = CGPoint(x:bgInitialPosX, y:self.frame.height - 350)
        
        if(!initialized){
            
            bgLayer!.addChild(bg)
            
            bgLayer!.addChild(title)
            title.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 400)
            title.zPosition = 1
            
            bgLayer!.addChild(verLabel)
            verLabel.text = "ver." + APP_VER
            verLabel.fontColor = UIColor.black
            verLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 300)
            verLabel.zPosition = 1
            
            startBtn.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
            startBtn.name = "startbtn"
            startBtn.zPosition = 100
            haeLayer!.addChild(startBtn)
            
            howtoBtn.position = CGPoint(x:self.frame.midX - 120, y:self.frame.midY - 150)
            howtoBtn.name = "howtobtn"
            howtoBtn.zPosition = 100
            haeLayer!.addChild(howtoBtn)
            
            rankingBtn.position = CGPoint(x:self.frame.midX + 120, y:self.frame.midY - 150)
            rankingBtn.name = "rankingbtn"
            rankingBtn.zPosition = 100
            haeLayer!.addChild(rankingBtn)
            
            initialized = true
        }
        
        self.createTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(MainScene.createHae(_:)), userInfo: nil, repeats: true)
        
        self.createBabyTimer = Timer.scheduledTimer(timeInterval: 20.5, target: self, selector: #selector(MainScene.createHaeBaby(_:)), userInfo: nil, repeats: true)
        
    }
    
    func createHae(_ timer : Timer){
        //create hae normal
        let hae = Hae()
        hae.name = "hae"
        hae.disableTouch()
        _ = 0 //0:left 1:right
        var _x = 0
        let _y = 350
        
        hae.range = CGFloat(4)
        hae.xs = CGFloat(4)
        
        hae.dir = 0
        _x = (Int(self.frame.width) - Int(deviceWidth))/2 - 200
        
        hae.position = CGPoint(x:_x,y:_y)
        haeLayer!.addChild(hae)
    }
    
    func createHaeBaby(_ timer : Timer){
        //create hae baby
        let baby = HaeBaby()
        baby.name = "hae_baby"
        baby.disableTouch()
        _ = 0 //0:left 1:right
        var _x = 0
        let _y = 350
        
        baby.range = CGFloat(4)
        baby.xs = CGFloat(4)
        
        baby.dir = 0
        _x = (Int(self.frame.width) - Int(deviceWidth))/2 - 200
        
        baby.position = CGPoint(x:_x,y:_y)
        haeLayer!.addChild(baby)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            //do something
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            print(touchedNode)
            if(touchedNode.name == "startbtn"){
                self.createTimer!.invalidate()
                self.createBabyTimer!.invalidate()
                self.mainSceneDelegate!.startBtnTouched()
                run(btnSound)
            }else if(touchedNode.name == "howtobtn"){
                self.mainSceneDelegate!.howtoBtnTouched()
                run(btnSound)
            }else if(touchedNode.name == "rankingbtn"){
                self.mainSceneDelegate!.rankingBtnTouched()
                run(btnSound)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(bg.position.x < 350){
            return
        }
        bg.position.x -= 0.1
        
        for node : AnyObject in haeLayer!.children{
            
            if (node as! SKNode).name == nil  {
                //println("name is nil")
            }
            else{
                if(node.name == "hae"){
                    let hae = node as! Hae
                    if(!hae.isDead){
                        hae.update()
                    }
                }
                
                if(node.name == "hae_baby"){
                    let baby = node as! HaeBaby
                    if(!baby.isDead){
                        baby.update()
                    }
                }
                
            }
            
        }

    }
}
