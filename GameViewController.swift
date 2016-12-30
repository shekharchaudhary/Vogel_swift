//
//  GameViewController.swift
//  Vogel
//
//  Created by Shekhar Chaudhary on 12/28/16.
//  Copyright © 2016 Shekhar Chaudhary. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
   @IBOutlet weak var vogel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var highscore: UILabel!
    
    @IBOutlet var backgroundColor: SKView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func flybutton(_ sender: UIButton) {
        //remove all scene from
        vogel.removeFromSuperview()
        highscore.removeFromSuperview()
        backgroundColor.removeFromSuperview()
        sender.removeFromSuperview()
        print("hello")
        
        
      }
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        
    }
    
    }
