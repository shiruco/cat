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
        bannerView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height-50)
        bannerView.frame.size = CGSize(width: self.view.frame.size.width,height: 50)
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.frame = CGRect(
            x: (self.view.bounds.size.width - bannerView.bounds.size.width) / 2,
            y: self.view.bounds.size.height - bannerView.bounds.size.height,
            width: bannerView.bounds.size.width,
            height: bannerView.bounds.size.height
        )
        
        self.view.addSubview(bannerView)
        
        //test
        let request:GADRequest = GADRequest()
        //request.testDevices = [GAD_SIMULATOR_ID]
        
        bannerView.load(request)
        
        
        //NADIconViewクラスの生成
        iconView = NADIconView(frame: CGRect(x: 0, y: 100, width: 75, height: 75))
        iconView.frame.origin = CGPoint(x: 0, y: 10)
        
        iconView2 = NADIconView(frame: CGRect(x: 0, y: 100, width: 75, height: 75))
        iconView2.frame.origin = CGPoint(x: 70, y: 10)
        
        //NADIconLoaderクラスの生成
        iconLoader = NADIconLoader()
        //loaderへ追加
        iconLoader.add(iconView)
        iconLoader.add(iconView2)
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
            scene.scaleMode = .aspectFill
            
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
    
    func showInterstitial(){
        if(getRandomNumber(Min:0,Max:10) % 2 == 1){
            var _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController._showInterstitial(_:)), userInfo: nil, repeats: false)
        }
    }
    func _showInterstitial(_ timer : Timer){
        interstitialView = GADInterstitial()
        interstitialView!.adUnitID = AD_POPUP_ID
        interstitialView!.delegate = self
        interstitialView!.load(GADRequest())
        
    }
    func getRandomNumber(Min _Min : Int, Max _Max : Int)->Int {
        return Int(arc4random_uniform(UInt32(_Max))) + _Min
    }
    func adViewDidReceiveAd(_ adView: GADBannerView){
        print("adViewDidReceiveAd:\(adView)")
    }
    func adView(_ adView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError){
        print("error:\(error)")
    }
    func adViewWillPresentScreen(_ adView: GADBannerView){
        print("adViewWillPresentScreen")
    }
    func adViewWillDismissScreen(_ adView: GADBannerView){
        print("adViewWillDismissScreen")
    }
    func adViewDidDismissScreen(_ adView: GADBannerView){
        print("adViewDidDismissScreen")
    }
    func adViewWillLeaveApplication(_ adView: GADBannerView){
        print("adViewWillLeaveApplication")
    }
    func interstitialDidReceiveAd(_ interstitial: GADInterstitial){
        print("interstitialDidReceiveAd:\(interstitial)")
        interstitialView!.present(fromRootViewController: self)
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
