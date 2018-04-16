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
    class func unarchiveFromFile(_ file : NSString) -> SKNode? {
        if let path = Bundle.main.path(forResource: file as String, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .mappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKNode
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, MainSceneDelegate {
    
    var mainScene:MainScene?
    
    var gameScene:GameScene?
    
    var howtoScene:HowtoScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = MainScene.unarchiveFromFile("MainScene") as? MainScene {
            
            mainScene = scene
            
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            scene.scaleMode = .aspectFill
            
            scene.mainSceneDelegate = self
            
            skView.presentScene(scene)
        }
    }
    
    func bestScoreUpdate(){
        self.reportScores(UserDataUtil.getPointData(), leaderboardid:LEADER_BORD_ID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateGameCenter()
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func startBtnTouched(){
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            gameScene = scene
            
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            skView.backgroundColor = UIColor.white
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            scene.scaleMode = .aspectFill
            
            scene.skView = skView
            scene.controller = self
            
            let t:SKTransition = SKTransition.flipVertical(withDuration: 0.7)
            
            skView.presentScene(scene, transition: t)
        }
    }
    
    func howtoBtnTouched(){
        if let scene = HowtoScene.unarchiveFromFile("HowtoScene") as? HowtoScene {
            howtoScene = scene
            howtoScene?.controller = self
            
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            skView.backgroundColor = UIColor.white
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            let t:SKTransition = SKTransition.flipVertical(withDuration: 0.7)
            skView.presentScene(scene, transition: t)
        }
    }
    
    func tweet(_ pt:Int){
        //投稿画面を作る
        let twitterPostView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        
        let mg = NSLocalizedString("tweetMsg", comment: "").replacingOccurrences(of: "$score", with: String(pt) + "pt", options: [], range: nil)
        twitterPostView.setInitialText(mg)
        
        self.present(twitterPostView, animated: true, completion: nil)
    }
    
    func fbPost(_ pt:Int){
        //投稿画面を作る
        let fbPostView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        
        let mg = NSLocalizedString("fbMsg", comment: "").replacingOccurrences(of: "$score", with: String(pt) + "pt", options: [], range: nil)
        fbPostView.setInitialText(mg)
        
        self.present(fbPostView, animated: true, completion: nil)
    }
    
    func rankingBtnTouched(){
        showLeaderboard()
    }
    
    func backTouched(){
        if let scene = MainScene.unarchiveFromFile("MainScene") as? MainScene {
            mainScene = scene
            
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            //scene.scaleMode = .AspectFill
            scene.scaleMode = .aspectFill
            
            scene.mainSceneDelegate = self
            
            let t:SKTransition = SKTransition.flipVertical(withDuration: 0.7)
            skView.presentScene(scene, transition: t)
        }
    }
    
    func getRandomNumber(Min _Min : Int, Max _Max : Int)->Int {
        return Int(arc4random_uniform(UInt32(_Max))) + _Min
    }
}

extension GameViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func showLeaderboard() {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = GKGameCenterViewControllerState.leaderboards
        //gameCenterViewController.leaderboardIdentifier = "brain.spead_match.score"
        self.present(gameCenterViewController, animated: true, completion: nil)
    }
    
    fileprivate func updateGameCenter() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (viewController, error) -> Void in
            if ((viewController) != nil) {
                // ログイン確認処理：失敗-ログイン画面を表示
                self.present(viewController!, animated: true, completion: nil)
            }else{
                if (error == nil){
                    print("SUCCESS LOGIN GAME CENTER")
                    self.reportScores(UserDataUtil.getPointData(), leaderboardid:LEADER_BORD_ID)
                }else{
                    print("FAIL TO LOGIN GAME CENTER",error)
                    // ログイン認証失敗 なにもしない
                }
            }
        }
    }
    
    fileprivate func reportScores(_ value:Int, leaderboardid:String){
        let score:GKScore = GKScore();
        score.value = Int64(value);
        score.leaderboardIdentifier = leaderboardid;
        let scoreArr:[GKScore] = [score];
        GKScore.report(scoreArr, withCompletionHandler:{(error:Error?) -> Void in
            if( (error != nil)){
                print("Sucess to reposrt \(leaderboardid)")
            }else{
                print("Faild to reposrt \(leaderboardid)")
            }
        });
    }
}
