//
//  GameScene.swift
//  Vogel
//
//  Created by raman maharjan on 12/28/16.
//  Copyright © 2016 raman maharjan. All rights reserved.
//

import SpriteKit
import GameplayKit
import Darwin
import AVFoundation

struct PhysicsCategory {
    static let bird1 : UInt32 = 0x1 << 1
    static let plane : UInt32 = 0x1 << 2
    static let plane2 : UInt32 = 0x1 << 3
    static let ship : UInt32 = 0x1 << 4
    static let cloud : UInt32 = 0x1 << 5
    static let shark : UInt32 = 0x1 << 6
    static let lightning : UInt32 = 0x1 << 7
    static let InjuredBird : UInt32 = 0x1 << 8
}

class GameScene: SKScene, SKPhysicsContactDelegate  {

    let sun = SKSpriteNode(imageNamed: "sun")
    var bird2 = SKSpriteNode(imageNamed: "bird2")
    var bird1 = SKSpriteNode(imageNamed: "bird1")
    // var bird1 = SKSpriteNode()
    var started = Bool()
    var gameOver = Bool()
    var birdHitCloud = Bool()
    var moveAndRemove = SKAction()
    var moveAndRemoveCloud = SKAction()
    var moveAndRemoveShip = SKAction()
    var jetpair = SKNode()
    var cloudNode = SKNode()
    var labelHiScore = UILabel()
    var labelScore = UILabel()
    var taptoStart = UILabel()
    var shipNode = SKNode()
    var finalScoreInt = Int()
    var scoreLabel = UILabel()
    var scoreInt = 0
    var replay = UIButton()
    var gameOverText = UILabel()
    var bird = SKSpriteNode()
    var exitButton = UIButton()
    var player: AVAudioPlayer?

    override func didMove(to view: SKView) {
        getItTogether()
    }

    func getItTogether(){
        // setup physics
        self.physicsWorld.gravity = CGVector( dx: 0.0, dy: -4.0 )
        self.physicsWorld.contactDelegate = self
        backgroundColor = UIColor.init(red: 153/255, green: 204/255, blue: 1, alpha: 1.0)
        //add waves{
        let wavea = SKSpriteNode(imageNamed: "wave2")
        let waveb = SKSpriteNode(imageNamed: "wave2")
        let wavec = SKSpriteNode(imageNamed: "wave2")
        let waved = SKSpriteNode(imageNamed: "wave2")
        let wavee = SKSpriteNode(imageNamed: "wave2")
        let waveSz = CGSize(width: wavea.size.width/3, height: wavea.size.height/3)
        wavea.scale(to: waveSz)
        wavea.position = CGPoint(x: (Int) (wavea.size.width/2)  , y: (Int)(wavea.size.height/5))
        addChild(wavea)
        waveb.scale(to: waveSz)
        waveb.position = CGPoint(x: (Int) (wavea.size.width/2) * 3  , y: (Int) (wavea.size.height/5))
        addChild(waveb)
        wavec.scale(to: waveSz)
        wavec.position = CGPoint(x: (Int) (wavea.size.width/2) * 5  , y: (Int) (wavea.size.height/5))
        addChild(wavec)
        waved.scale(to: waveSz)
        waved.position = CGPoint(x: (Int) (wavea.size.width/2) * 7  , y: (Int) (wavea.size.height/5))
        addChild(waved)
        wavee.scale(to: waveSz)
        wavee.position = CGPoint(x: (Int) (wavea.size.width/2) * 9  , y: (Int) (wavea.size.height/5))
        addChild(wavee)


        //add sun
        let sunSz = CGSize(width: 50 , height: 50)
        sun.scale(to: sunSz)
        sun.position = CGPoint(x: size.width - sun.size.width - 5, y: size.height - sun.size.height)
        sun.physicsBody?.velocity = CGVector(dx: -20, dy: -100)
        addChild(sun)
        //add HighScore
        labelHiScore = UILabel(frame: CGRect(x: self.size.width/2 - 100, y: self.size.height/5 - 10, width: 200, height: 30))
        // labelHiScore.center = CGPoint(x: self.size.width/2, y: self.size.height/5)
        labelHiScore.textAlignment = .center
        labelHiScore.textColor = UIColor.red
        labelHiScore.font = UIFont.init(name: "Georgia-Italic", size: 20)
        labelHiScore.text = "High Score: " + "0000"
        self.view?.addSubview(labelHiScore)

        //tap to start
        taptoStart = UILabel(frame: CGRect(x: self.size.width/2 - 250, y: self.size.height/2 - 50, width: 500, height: 100))
        // taptoStart.center = CGPoint(x: self.size.width/2, y: self.size.height/5)
        taptoStart.textAlignment = .center
        taptoStart.textColor = UIColor.yellow
        taptoStart.font = UIFont.init(name: "Georgia-Italic", size: 75)
        taptoStart.text = "Tap To Start"
        self.view?.addSubview(taptoStart)
        scoreLabel = UILabel(frame: CGRect(x: self.size.width - 100, y: self.size.height - self.size.height/10 , width: 100, height: 30))
        scoreLabel.textAlignment = .left
        scoreLabel.textColor = UIColor.red
        scoreLabel.font = UIFont.init(name: "Georgia-Italic", size: 20)


        //add Bird
        bird1 = SKSpriteNode(imageNamed: "bird1")
       // bird1 = bird
        let birdSz = CGSize(width: bird1.size.width/4, height: bird1.size.height/4)
        bird1.scale(to: birdSz)
        bird1.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        bird1.physicsBody = SKPhysicsBody(circleOfRadius: bird1.size.width/8)
        bird1.physicsBody?.isDynamic = true
        bird1.zPosition = 2
        bird1.physicsBody?.allowsRotation = false
        bird1.physicsBody?.affectedByGravity = false
        bird1.physicsBody?.categoryBitMask = PhysicsCategory.bird1
        bird1.physicsBody?.collisionBitMask = PhysicsCategory.plane | PhysicsCategory.cloud | PhysicsCategory.ship
        bird1.physicsBody?.contactTestBitMask = PhysicsCategory.plane | PhysicsCategory.cloud | PhysicsCategory.ship

        self.addChild(bird1)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       //  bird1 = SKSpriteNode(imageNamed: "bird2")
        //bird1.isHidden = true
 //       bird2 = SKSpriteNode(imageNamed: "bird2")
//        let birdSz = CGSize(width: bird1.size.width/4, height: bird1.size.height/4)
//        bird1.scale(to: birdSz)
//        bird1.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
//        bird1.physicsBody = SKPhysicsBody(circleOfRadius: bird1.size.width/8)
//        bird1.physicsBody?.isDynamic = true
//        bird1.zPosition = 2
//        bird1.physicsBody?.allowsRotation = false
//        bird1.physicsBody?.affectedByGravity = false
//        bird1.physicsBody?.categoryBitMask = PhysicsCategory.bird1
//        bird1.physicsBody?.collisionBitMask = PhysicsCategory.plane | PhysicsCategory.cloud | PhysicsCategory.ship
//        bird1.physicsBody?.contactTestBitMask = PhysicsCategory.plane | PhysicsCategory.cloud | PhysicsCategory.ship
   //     bird = bird2
        //self.addChild(bird1)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        bird1 = SKSpriteNode(imageNamed: "bird1")

//        let birdSz = CGSize(width: bird1.size.width/4, height: bird1.size.height/4)
//        bird1.scale(to: birdSz)
//        bird1.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
//        bird1.physicsBody = SKPhysicsBody(circleOfRadius: bird1.size.width/8)
//        bird1.physicsBody?.isDynamic = true
//        bird1.zPosition = 2
//        bird1.physicsBody?.allowsRotation = false
//        bird1.physicsBody?.affectedByGravity = false
//        bird1.physicsBody?.categoryBitMask = PhysicsCategory.bird1
//        bird1.physicsBody?.collisionBitMask = PhysicsCategory.plane | PhysicsCategory.cloud | PhysicsCategory.ship
//        bird1.physicsBody?.contactTestBitMask = PhysicsCategory.plane | PhysicsCategory.cloud | PhysicsCategory.ship
       // bird = bird1

        scoreLabel.text = "Score:  \(scoreInt)"
        self.view?.addSubview(scoreLabel)
        labelHiScore.removeFromSuperview()
        labelHiScore.textAlignment = .left
        labelHiScore = UILabel(frame: CGRect(x: self.size.width/14 , y: self.size.height - self.size.height/10 , width: 300, height: 30))
        labelHiScore.font = UIFont.init(name: "Georgia-Italic", size: 20)
        labelHiScore.textColor = UIColor.red
        labelHiScore.text = "High Score: " + "0000"
        self.view?.addSubview(labelHiScore)

        if started == false {
            started = true
            taptoStart.isHidden = true
            bird1.physicsBody?.affectedByGravity = true
            //creates a block
            let movingJet = SKAction.run({
                () in
                self.addjets()
                self.addCloud()
            })
            let delay = SKAction.wait(forDuration: 2)   //interval between jets
            let addJetDelay = SKAction.sequence ([movingJet, delay])
            let addJetForever = SKAction.repeatForever(addJetDelay)
            self.run(addJetForever)
            let movingShip = SKAction.run({
                () in
                self.addShip()
            })
            let delay2 = SKAction.wait(forDuration: 8)   //interval between jets
            let addShipDelay = SKAction.sequence ([movingShip, delay2])
            let addShipForever = SKAction.repeatForever(addShipDelay)
            self.run(addShipForever)
            let distance = CGFloat(self.frame.width  + jetpair.frame.width + 150 )
            let movePlane = SKAction.moveBy(x: -distance , y:0, duration: TimeInterval(0.005 * distance ))
            let moveCloud = SKAction.moveBy(x: distance , y:0, duration: TimeInterval(0.009 * distance ))
            let moveShip = SKAction.moveBy(x: distance , y:0, duration: TimeInterval(0.02 * distance ))
            let removePlane = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePlane, removePlane])
            moveAndRemoveCloud = SKAction.sequence([moveCloud, removePlane])
            moveAndRemoveShip = SKAction.sequence([moveShip, removePlane])
            bird1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2))
        }else{
            if gameOver == true {
                gameOverMethod()
            }else{
            bird1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 2))
            }
        }
        if started == true {
            if bird1.position.y < self.size.height/10 {
                gameOver = true
                addShark()
                gameOverMethod()
            }
            if birdHitCloud == true {
                gameOver = true
                addLightning()
                birdHitCloud = false

            }
        }
        if started == true && gameOver == false {
            scoreInt += 1
        }

    }

    func gameOverMethod() {
        self.removeAllChildren()
        self.removeAllActions()
        replay.isHidden = true
        let s1: AVAudioPlayer = playSound()
        s1.numberOfLoops = 1

        s1.play()
        backgroundColor = UIColor.init(red: 153/255, green: 204/255, blue: 1, alpha: 1.0)
//        gameOverText.removeFromSuperview()
//        gameOverText = UILabel(frame: CGRect(x: self.size.width/2 - 200, y: self.size.height/2 - 50, width: 400, height: 30))
//        gameOverText.textAlignment = .center
//        gameOverText.textColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 255/255)
//        gameOverText.font = UIFont.init(name: "Georgia-Italic", size: 30)
//        gameOverText.text = "Game Over"
//        self.view?.addSubview(gameOverText)
        labelHiScore.removeFromSuperview()
        labelHiScore.textAlignment = .center
        labelHiScore = UILabel(frame: CGRect(x: self.size.width/2 - 150, y: self.size.height/10 , width: 300, height: 30))
        labelHiScore.font = UIFont.init(name: "Georgia-Italic", size: 25)
        labelHiScore.textColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 255/255)
        labelHiScore.text = "High Score: " + "0000"
        self.view?.addSubview(labelHiScore)
        scoreLabel.removeFromSuperview()
        scoreLabel = UILabel(frame: CGRect(x: self.size.width/2 - 50, y: self.size.height/5 , width: 100, height: 30))
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = UIColor.init(red: 1, green: 1, blue: 0, alpha: 255/255)
        scoreLabel.font = UIFont.init(name: "Georgia-Italic", size: 20)
        scoreLabel.text = "Score:  \(scoreInt)"
        self.view?.addSubview(scoreLabel)

        let InjuredBird = SKSpriteNode(imageNamed: "InjuredBird")
        let InjuredBirdSz = CGSize(width: InjuredBird.size.width, height: InjuredBird.size.height)
        InjuredBird.scale(to: InjuredBirdSz)
        InjuredBird.position = CGPoint(x: self.size.width/2, y: self.size.height/3)
        InjuredBird.physicsBody?.isDynamic = false
        InjuredBird.zPosition = 2
        InjuredBird.physicsBody?.allowsRotation = false
        InjuredBird.physicsBody?.affectedByGravity = false
        self.addChild(InjuredBird)
        //add Replay button
        replay = UIButton(frame: CGRect(x: self.size.width/7 , y: self.size.height/2 + self.size.height/14 , width: 200, height: 50))
        replay.setTitleColor( UIColor.blue, for: .normal)
        replay.titleLabel?.font = UIFont.init(name: "Georgia-Italic", size: 25)
        replay.setTitle("Replay", for: .normal)
        replay.addTarget(self, action: #selector(GameScene.restartMethod), for: .touchUpInside)
        self.view?.addSubview(replay)

        //add Exit button
        exitButton.removeFromSuperview()
         exitButton = UIButton(frame: CGRect(x: self.size.width/2 + self.size.width/6, y: self.size.height/2 + self.size.height/14 , width: 200, height: 50))
        exitButton.setTitleColor( UIColor.blue, for: .normal)
        exitButton.titleLabel?.font = UIFont.init(name: "Georgia-Italic", size: 25)
        exitButton.setTitle("Exit", for: .normal)
        exitButton.addTarget(self, action: #selector(GameScene.exit), for: .touchUpInside)
        self.view?.addSubview(exitButton)
    }

    func exit()
    {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }

    func restartMethod(){
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
        exitButton.isEnabled = true
        exitButton.removeFromSuperview()
       // gameOverText.isEnabled = false
       // gameOverText.removeFromSuperview()
        scoreLabel.removeFromSuperview()
        replay.removeFromSuperview()
        labelHiScore.removeFromSuperview()
        gameOver = false
        started = false
        scoreInt = 0
        getItTogether()

    }


    func addjets(){
        jetpair = SKNode()
        let plane = SKSpriteNode(imageNamed: "plane")
        let planeSz = CGSize(width: plane.size.width/4 , height: plane.size.height/4)
        plane.scale(to: planeSz)
        let randomPosition2 = CGFloat(arc4random_uniform(250))
        plane.position = CGPoint(x: self.size.width + 10 + plane.size.width/2 , y: 100 + randomPosition2 )
        plane.physicsBody = SKPhysicsBody(rectangleOf: planeSz)
        plane.physicsBody = SKPhysicsBody(circleOfRadius: plane.size.height / 8.0)
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.categoryBitMask = PhysicsCategory.plane
        plane.physicsBody?.isDynamic = true
        plane.physicsBody?.collisionBitMask = PhysicsCategory.bird1
        plane.physicsBody?.contactTestBitMask = PhysicsCategory.bird1
        plane.zPosition = -1
        jetpair.addChild(plane)

        jetpair.run(moveAndRemove)
        self.addChild(jetpair)

    }

    func addCloud(){
        cloudNode = SKNode()
        let cloud = SKSpriteNode(imageNamed: "Cloud")
        let cloudSz = CGSize(width: cloud.size.width/4 , height: cloud.size.height/4)
        cloud.scale(to: cloudSz)
        let randomPosition2 = CGFloat(arc4random_uniform(UInt32((Float)(self.size.height/6))))
        cloud.position = CGPoint(x:cloud.size.width/2 - 25 , y: self.size.height  - randomPosition2 )
        cloud.physicsBody = SKPhysicsBody(rectangleOf: cloudSz)
        cloud.physicsBody?.affectedByGravity = false
        cloud.physicsBody?.isDynamic = true
        cloud.physicsBody?.categoryBitMask = PhysicsCategory.cloud
        cloud.physicsBody?.collisionBitMask = PhysicsCategory.bird1
        cloud.physicsBody?.contactTestBitMask = PhysicsCategory.bird1
        cloud.zPosition = 1
        cloudNode.addChild(cloud)
        cloudNode.run(moveAndRemoveCloud)
        self.addChild(cloudNode)
    }
    func addShip(){
        shipNode = SKNode()
        let ship = SKSpriteNode(imageNamed: "ship")
        let shipSz = CGSize(width: ship.size.width/2 , height: ship.size.height/4)
        ship.scale(to: shipSz)
        let randomPosition2 = CGFloat(arc4random_uniform(8))
        ship.position = CGPoint(x:ship.size.width/2 - 50 , y: 70 + randomPosition2 )
        ship.physicsBody = SKPhysicsBody(rectangleOf: shipSz)
        ship.physicsBody?.affectedByGravity = false
        ship.physicsBody?.categoryBitMask = PhysicsCategory.ship
        ship.physicsBody?.isDynamic = true
        ship.physicsBody?.collisionBitMask = PhysicsCategory.bird1
        ship.physicsBody?.contactTestBitMask = PhysicsCategory.bird1
        ship.zPosition = -1
        shipNode.addChild(ship)
        shipNode.run(moveAndRemoveShip)
        self.addChild(shipNode)
    }
    func addShark() {
        let shark = SKSpriteNode(imageNamed: "shark")
        let sharkSz = CGSize(width: shark.size.width/5 , height: shark.size.height/5)
        shark.scale(to: sharkSz)
        shark.position = CGPoint(x: bird1.position.x , y: bird1.position.y )
        shark.physicsBody = SKPhysicsBody(rectangleOf: sharkSz)
        shark.physicsBody = SKPhysicsBody(circleOfRadius: shark.size.height / 10)
        shark.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        shark.physicsBody?.affectedByGravity = false
        shark.physicsBody?.isDynamic = true
        shark.zPosition = -1
        self.addChild(shark)
    }

    func addLightning() {
        let lightning = SKSpriteNode(imageNamed: "lightning")
        let lightningSz = CGSize(width: lightning.size.width/5 , height: lightning.size.height/5)
        lightning.scale(to: lightningSz)
        lightning.position = CGPoint(x: bird1.position.x , y: bird1.position.y )
        lightning.physicsBody = SKPhysicsBody(rectangleOf: lightningSz)
        lightning.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        lightning.physicsBody?.affectedByGravity = false
        lightning.physicsBody?.isDynamic = true
        lightning.zPosition = -1
        self.addChild(lightning)
    }

    func didBegin(_ contact: SKPhysicsContact) {

        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        if firstBody.categoryBitMask == PhysicsCategory.bird1 && secondBody.categoryBitMask == PhysicsCategory.plane ||
            firstBody.categoryBitMask == PhysicsCategory.plane && secondBody.categoryBitMask == PhysicsCategory.bird1{
            gameOver = true
        }
        if firstBody.categoryBitMask == PhysicsCategory.bird1 && secondBody.categoryBitMask == PhysicsCategory.cloud ||
            firstBody.categoryBitMask == PhysicsCategory.cloud && secondBody.categoryBitMask == PhysicsCategory.bird1{
            birdHitCloud = true
        }
    }


    func playSound() -> AVAudioPlayer {
        guard let sound = NSDataAsset(name: "latinHorn") else {
            print("sound asset not found")
            return player!
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)

           // player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        return player!
    }

//    func HighScore() {
//        let scoreDictionary = "scorea"
//        let highScore = [scoreDictionary]
//        let fileManager = FileManager.defaultManager()
//        let documentsURL = fileManager.URLsForDirectory(NSSearchPath.Directory.DocumentDirectory, inDomains:NS))
//
//    }

}

//class HighScoreManager {
//
//
//        var documentsURL: NSURL?
//        var fileURL:NSURL?
//
//        func setFileURL(file: String) {
//            documentsURL = FileManager.defaultManager().URLsForDirectory(.documentDirectory, inDomains: .UserDomainMask)[0] as NSURL?
//            fileURL = documentsURL!.appendingPathComponent(file) as NSURL?
//
//        }
//
//        func write(file: String, mDict: [String:String]) {
//            setFileURL(file)
//            let data : NSData = NSKeyedArchiver.archivedDataWithRootObject(mDict)
//            if let fileAssigend = fileURL {
//                data.writeToURL(fileAssigend, atomically: true)
//            }
//        }
//
//        func read(file: String, mDict: inout [String:String]) {
//            setFileURL(file)
//
//            var data:NSData?
//            if let url = fileURL {
//                data =  NSData(contentsOfURL: url as URL)
//                if let result = data {
//                    mDict = NSKeyedUnarchiver.unarchiveObjectWithData(result) as! [String:String]
//                }
//            }
//
//        }
//
//        // Below with NSObject
//        func write(file: String, mDict: NSObject) {
//            setFileURL(file)
//            let data : NSData = NSKeyedArchiver.archivedData(withRootObject: mDict)
//            if let fileAssigend = fileURL {
//                data.write(to: fileAssigend as URL, atomically: true)
//            }
//        }
//
//        func read(file: String, mDict: inout NSObject) {
//            setFileURL(file: file)
//
//            var data:NSData?
//            if let url = fileURL {
//                data =  NSData(contentsOf: url as URL)
//                if let result = data {
//                    mDict = NSKeyedUnarchiver.unarchiveObject(with: result as Data) as! NSObject
//                }
//            }
//            
//        }
//        
//    }






// background red
class GameScene2: SKScene{
    override func didMove(to view: SKView) {
        //red background
          backgroundColor = UIColor.init(red: 1, green: 0, blue: 0.0, alpha: 1.0)
        }

}
class GameScene3: SKScene{
    override func didMove(to view: UIView) {
        //red background
        backgroundColor = UIColor.init(red: 1, green: 0, blue: 0.0, alpha: 1.0)
    }

}
