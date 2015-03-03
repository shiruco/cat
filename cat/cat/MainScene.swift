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
}

class MainScene: SKScene {
    
    var initialized:Bool = false
    
    var mainSceneDelegate:MainSceneDelegate?
    
    let testLabel = SKLabelNode(fontNamed:"Verdana-Bold")
    let btnSound = SKAction.playSoundFileNamed("btn.mp3", waitForCompletion: false)
    
    let title = SKSpriteNode(imageNamed: "title_main.png")
	
	//btn
	let startBtn = SKSpriteNode(imageNamed: "start_btn.png")
	let howtoBtn = SKSpriteNode(imageNamed: "howto_btn.png")
	let rankingBtn = SKSpriteNode(imageNamed: "ranking_btn.png")
	
	let deviceWidth = UIScreen.mainScreen().nativeBounds.width
    
    //layers
    var bgLayer:SKNode? = nil
    var haeLayer:SKNode? = nil
    
    let bg = SKSpriteNode(imageNamed: "room.png")
    let bgInitialPosX:CGFloat = 800.0
	
	var createTimer:NSTimer? = nil
	var createBabyTimer:NSTimer? = nil
	
    override func didMoveToView(view: SKView) {
        
        //layer
        bgLayer = self.childNodeWithName("bgLayer")
        haeLayer = bgLayer!.childNodeWithName("haeLayer")
        
        //bg 350
        bg.position = CGPoint(x:bgInitialPosX, y:CGRectGetHeight(self.frame) - 350)
        
        if(!initialized){
            
            bgLayer!.addChild(bg)
            
            bgLayer!.addChild(title)
            title.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 400)
            title.zPosition = 1
			
			startBtn.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
			startBtn.name = "startbtn"
			startBtn.zPosition = 100
            haeLayer!.addChild(startBtn)
			
			howtoBtn.position = CGPoint(x:CGRectGetMidX(self.frame) - 120, y:CGRectGetMidY(self.frame) - 150)
			howtoBtn.name = "howtobtn"
			howtoBtn.zPosition = 100
			haeLayer!.addChild(howtoBtn)
			
			rankingBtn.position = CGPoint(x:CGRectGetMidX(self.frame) + 120, y:CGRectGetMidY(self.frame) - 150)
			rankingBtn.name = "rankingbtn"
			rankingBtn.zPosition = 100
			haeLayer!.addChild(rankingBtn)
			
            initialized = true
        }
		
		self.createTimer = NSTimer.scheduledTimerWithTimeInterval(20, target: self, selector: "createHae:", userInfo: nil, repeats: true)
		
		self.createBabyTimer = NSTimer.scheduledTimerWithTimeInterval(20.5, target: self, selector: "createHaeBaby:", userInfo: nil, repeats: true)
		
    }
	
	func createHae(timer : NSTimer){
		//create hae normal
		let hae = Hae()
		hae.name = "hae"
		hae.disableTouch()
		var _dir = 0 //0:left 1:right
		var _x = 0
		var _y = 350
		
		hae.range = CGFloat(4)
		hae.xs = CGFloat(4)
		
		hae.dir = 0
		_x = (Int(self.frame.width) - Int(deviceWidth))/2 - 200
		
		hae.position = CGPoint(x:_x,y:_y)
		haeLayer!.addChild(hae)
	}
	
	func createHaeBaby(timer : NSTimer){
		//create hae baby
		let baby = HaeBaby()
		baby.name = "hae_baby"
		baby.disableTouch()
		var _dir = 0 //0:left 1:right
		var _x = 0
		var _y = 350
		
		baby.range = CGFloat(4)
		baby.xs = CGFloat(4)
		
		baby.dir = 0
		_x = (Int(self.frame.width) - Int(deviceWidth))/2 - 200
		
		baby.position = CGPoint(x:_x,y:_y)
		haeLayer!.addChild(baby)
	}
	
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
		
        for touch: AnyObject in touches {
            //do something
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            println(touchedNode)
            if(touchedNode.name == "startbtn"){
			  self.createTimer!.invalidate()
			  self.createBabyTimer!.invalidate()
              self.mainSceneDelegate!.startBtnTouched()
              runAction(btnSound)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if(bg.position.x < 350){
            return
        }
        bg.position.x -= 0.1
		
		for node : AnyObject in haeLayer!.children{
			
			if (node as SKNode).name == nil  {
				//println("name is nil")
			}
			else{
				if(node.name == "hae"){
					var hae = node as Hae
					if(!hae.isDead){
						hae.update()
					}
				}
				
				if(node.name == "hae_baby"){
					var baby = node as HaeBaby
					if(!baby.isDead){
						baby.update()
					}
				}
				
			}
			
		}

    }
}
