//
//  GameViewController.swift
//  cat
//
//  Created by takatatomoyuki on 2015/01/05.
//  Copyright (c) 2015年 com.maroton. All rights reserved.
//

import UIKit
import SpriteKit

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

class GameViewController: UIViewController, MainSceneDelegate, GADBannerViewDelegate {
    
    var mainScene:MainScene?
    
    var gameScene:GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bannerView:GADBannerView = GADBannerView()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-7252416243361625/9591345191"
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
        request.testDevices = [GAD_SIMULATOR_ID]
        
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
            skView.showsFPS = true
            skView.showsNodeCount = true
            
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
                    println("OKOK GAME CENTER")
//                    for game in gameKinds {
//                        let bestScore: Int = (self.user.bestScores[game.id] != nil) ? self.user.bestScores[game.id]! : 0
//                        if bestScore > 10 {
//                            self.reportScores(bestScore, leaderboardid: game.leaderboardId)
//                        }
//                    }
//                    if self.user.level > 3 {
//                        self.reportScores(self.user.level, leaderboardid: levelLeaderboardId)
//                    }
                }else{
                    println("NGNG GAME CENTER",error)
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
