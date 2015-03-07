//
//  HowtoScene.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import SpriteKit

class HowtoScene: SKScene {
	
	var initialized:Bool = false
	let howto = SKSpriteNode(imageNamed: "howtoview.png")
	let back = SKSpriteNode(imageNamed: "back_btn.png")
	var controller:UIViewController?
	let btnSound = SKAction.playSoundFileNamed("btn.mp3", waitForCompletion: false)
	
	override func didMoveToView(view: SKView) {
		howto.xScale = 0.7
		howto.yScale = 0.7
		howto.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 100)
		self.addChild(howto)
		
		back.name = "back_btn"
		back.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 350)
		self.addChild(back)
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		/* Called when a touch begins */
		
		for touch: AnyObject in touches {
			//do something
			let location = touch.locationInNode(self)
			let touchedNode = self.nodeAtPoint(location)
			if(touchedNode.name == "back_btn"){
				if controller != nil {
					self.back.removeFromParent()
					self.howto.removeFromParent()
					runAction(btnSound)
					
					let c = controller as GameViewController
					c.backTouched()
				}
			}
		}
	}
}
