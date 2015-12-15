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
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
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

class GameViewController: UIViewController, MainSceneDelegate,NADIconLoaderDelegate,  GADBannerViewDelegate, GADInterstitialDelegate {
    
    var mainScene:MainScene?
    
    var gameScene:GameScene?
    
    var howtoScene:HowtoScene?
    
    var interstitialView:GADInterstitial?
    
    var iconLoader: NADIconLoader!
    var iconView: NADIconView!
    var iconView2: NADIconView!

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
        
        
        //NADIconViewクラスの生成
        iconView = NADIconView(frame: CGRect(x: 0, y: 100, width: 75, height: 75))
        iconView.frame.origin = CGPointMake(0, 10)
        
        iconView2 = NADIconView(frame: CGRect(x: 0, y: 100, width: 75, height: 75))
        iconView2.frame.origin = CGPointMake(70, 10)
        
        //NADIconLoaderクラスの生成
        iconLoader = NADIconLoader()
        //loaderへ追加
        iconLoader.addIconView(iconView)
        iconLoader.addIconView(iconView2)
        //loaderへの設定
        iconLoader.setNendID(AD_NEND_API_KEY,spotID: AD_NEND_SPOT_ID)
        iconLoader.delegate = self
        iconLoader.isOutputLog = true
        //load開始
        iconLoader.load()
        
        if let scene = MainScene.unarchiveFromFile("MainScene") as? MainScene {
            
            mainScene = scene
            
            // Configure the view.
            let skView = self.view as! SKView
            
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
    
    func addNendAd(){
        //画面上へ追加
        self.view.addSubview(iconView)
        self.view.addSubview(iconView2)
    }
    
    func removeNendAd(){
        //画面上から削除
        iconView.removeFromSuperview()
        iconView2.removeFromSuperview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateGameCenter()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
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
            let skView = self.view as! SKView
            
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
    
    func howtoBtnTouched(){
        if let scene = HowtoScene.unarchiveFromFile("HowtoScene") as? HowtoScene {
            howtoScene = scene
            howtoScene?.controller = self
            
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            skView.backgroundColor = UIColor.whiteColor()
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            let t:SKTransition = SKTransition.flipVerticalWithDuration(0.7)
            skView.presentScene(scene, transition: t)
        }
    }
    
    func tweet(pt:Int){
        //投稿画面を作る
        let twitterPostView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
        
        let mg = NSLocalizedString("tweetMsg", comment: "").stringByReplacingOccurrencesOfString("$score", withString: String(pt) + "pt", options: [], range: nil)
        twitterPostView.setInitialText(mg)
        
        self.presentViewController(twitterPostView, animated: true, completion: nil)
    }
    
    func fbPost(pt:Int){
        //投稿画面を作る
        let fbPostView:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
        
        let mg = NSLocalizedString("fbMsg", comment: "").stringByReplacingOccurrencesOfString("$score", withString: String(pt) + "pt", options: [], range: nil)
        fbPostView.setInitialText(mg)
        
        self.presentViewController(fbPostView, animated: true, completion: nil)
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
            scene.scaleMode = .AspectFill
            
            scene.mainSceneDelegate = self
            
            let t:SKTransition = SKTransition.flipVerticalWithDuration(0.7)
            skView.presentScene(scene, transition: t)
        }
    }
    
    func showInterstitial(){
        if(getRandomNumber(Min:0,Max:10) % 2 == 1){
            var _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "_showInterstitial:", userInfo: nil, repeats: false)
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
        print("adViewDidReceiveAd:\(adView)")
    }
    func adView(adView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError){
        print("error:\(error)")
    }
    func adViewWillPresentScreen(adView: GADBannerView){
        print("adViewWillPresentScreen")
    }
    func adViewWillDismissScreen(adView: GADBannerView){
        print("adViewWillDismissScreen")
    }
    func adViewDidDismissScreen(adView: GADBannerView){
        print("adViewDidDismissScreen")
    }
    func adViewWillLeaveApplication(adView: GADBannerView){
        print("adViewWillLeaveApplication")
    }
    func interstitialDidReceiveAd(interstitial: GADInterstitial){
        print("interstitialDidReceiveAd:\(interstitial)")
        interstitialView!.presentFromRootViewController(self)
    }
}

extension GameViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func showLeaderboard() {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        //gameCenterViewController.leaderboardIdentifier = "brain.spead_match.score"
        self.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    private func updateGameCenter() {
        var localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {
            (viewController, error) -> Void in
            if ((viewController) != nil) {
                // ログイン確認処理：失敗-ログイン画面を表示
                self.presentViewController(viewController, animated: true, completion: nil)
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
    
    private func reportScores(value:Int, leaderboardid:String){
        let score:GKScore = GKScore();
        score.value = Int64(value);
        score.leaderboardIdentifier = leaderboardid;
        let scoreArr:[GKScore] = [score];
        GKScore.reportScores(scoreArr, withCompletionHandler:{(error:NSError?) -> Void in
            if( (error != nil)){
                print("Sucess to reposrt \(leaderboardid)")
            }else{
                print("Faild to reposrt \(leaderboardid)")
            }
        });
    }
}
