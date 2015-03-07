//
//  GameViewController.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import UIKit
import SpriteKit
import Social

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKNode
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, MainSceneDelegate, GADBannerViewDelegate, GADInterstitialDelegate {
    
    var mainScene:MainScene?
    
    var gameScene:GameScene?
	
	var interstitialView:GADInterstitial?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bannerView:GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = AD_BANNER_ID
        bannerView.frame.origin = CGPointMake(0, self.view.frame.size.height-50)
        bannerView.frame.size = CGSizeMake(self.view.frame.size.width,50)
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.frame = CGRectMake(
            (self.view.bounds.size.width - bannerView.bounds.size.width) / 2,
            self.view.bounds.size.height - bannerView.bounds.size.height,
            bannerView.bounds.size.width,
            bannerView.bounds.size.height
        )
        
        self.view.addSubview(bannerView)
		
		//test
		var request:GADRequest = GADRequest()
		//request.testDevices = [GAD_SIMULATOR_ID]
		
		bannerView.loadRequest(request)
		

        if let scene = MainScene.unarchiveFromFile("MainScene") as? MainScene {
            
            mainScene = scene
            
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            scene.scaleMode = .AspectFill
            
            scene.mainSceneDelegate = self
            
            skView.presentScene(scene)
        }
    }
	
	func bestScoreUpdate(){
		self.reportScores(UserDataUtil.getPointData(), leaderboardid:LEADER_BORD_ID)
	}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateGameCenter()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func startBtnTouched(){
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            gameScene = scene
            
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            skView.backgroundColor = UIColor.whiteColor()
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            scene.scaleMode = .AspectFill
            
            scene.skView = skView
            scene.controller = self
            
            let t:SKTransition = SKTransition.flipVerticalWithDuration(0.7)
            
            skView.presentScene(scene, transition: t)
        }
    }
	
	func tweet(pt:Int){
		//投稿画面を作る
		let twitterPostView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
		
		var mg = TWEET_MSG.stringByReplacingOccurrencesOfString("$score", withString: String(pt) + "pt", options: nil, range: nil)
		twitterPostView.setInitialText(mg)
		
		self.presentViewController(twitterPostView, animated: true, completion: nil)
	}
	
	func fbPost(pt:Int){
		//投稿画面を作る
		let fbPostView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
		
		var mg = FB_MSG.stringByReplacingOccurrencesOfString("$score", withString: String(pt) + "pt", options: nil, range: nil)
		fbPostView.setInitialText(mg)
		
		self.presentViewController(fbPostView, animated: true, completion: nil)
	}
	
	func rankingBtnTouched(){
		showLeaderboard()
	}
	func showInterstitial(){
		if(getRandomNumber(Min:0,Max:10) % 2 == 1){
			var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "_showInterstitial:", userInfo: nil, repeats: false)
		}
	}
	func _showInterstitial(timer : NSTimer){
		interstitialView = GADInterstitial()
		interstitialView!.adUnitID = AD_POPUP_ID
		interstitialView!.delegate = self
		interstitialView!.loadRequest(GADRequest())
		
	}
	func getRandomNumber(Min _Min : Int, Max _Max : Int)->Int {
		return Int(arc4random_uniform(UInt32(_Max))) + _Min
	}
    func adViewDidReceiveAd(adView: GADBannerView){
        println("adViewDidReceiveAd:\(adView)")
    }
    func adView(adView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError){
        println("error:\(error)")
    }
    func adViewWillPresentScreen(adView: GADBannerView){
        println("adViewWillPresentScreen")
    }
    func adViewWillDismissScreen(adView: GADBannerView){
        println("adViewWillDismissScreen")
    }
    func adViewDidDismissScreen(adView: GADBannerView){
        println("adViewDidDismissScreen")
    }
    func adViewWillLeaveApplication(adView: GADBannerView){
        println("adViewWillLeaveApplication")
    }
	func interstitialDidReceiveAd(interstitial: GADInterstitial){
		println("interstitialDidReceiveAd:\(interstitial)")
		interstitialView!.presentFromRootViewController(self)
	}
}

extension GameViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func showLeaderboard() {
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        //gameCenterViewController.leaderboardIdentifier = "brain.spead_match.score"
        self.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    private func updateGameCenter() {
        var localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (viewController, error) -> Void in
            if ((viewController) != nil) { // ログイン確認処理：失敗-ログイン画面を表示
                self.presentViewController(viewController, animated: true, completion: nil)
            }else{
                if (error == nil){
                    println("SUCCESS LOGIN GAME CENTER")
                    self.reportScores(UserDataUtil.getPointData(), leaderboardid:LEADER_BORD_ID)
                }else{
                    println("FAIL TO LOGIN GAME CENTER",error)
                    // ログイン認証失敗 なにもしない
                }
            }
        }
    }
    
    private func reportScores(value:Int, leaderboardid:String){
        var score:GKScore = GKScore();
        score.value = Int64(value);
        score.leaderboardIdentifier = leaderboardid;
        var scoreArr:[GKScore] = [score];
        GKScore.reportScores(scoreArr, withCompletionHandler:{(error:NSError!) -> Void in
            if( (error != nil)){
                println("Sucess to reposrt \(leaderboardid)")
            }else{
                println("Faild to reposrt \(leaderboardid)")
            }
        });
    }
}
