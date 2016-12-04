//
//  DiffultyMode.swift
//  FlappyBird
//
//  Created by Admin on 03/12/2016.
//  Copyright © 2016 Fullstack.io. All rights reserved.
//

import Foundation

class DifficultyMode  {
    static let instance = DifficultyMode()
    
    let modes = ["normal": ["gravity": "-4,0", "impulsion": "25", "speedHero": "1", "interPipe": "2"],
                "fast": ["gravity": "-5,0", "impulsion": "30", "speedHero": "2", "interPipe": "1.8"],
                "insane": ["gravity": "-6,0", "impulsion": "35", "speedHero": "5", "interPipe": "1.2"]
    ] as [String : [String: String]]
    
    var currentMode:String = "normal"
    
    func changeCurrentMode(id:String) {
        
        for item in modes {
            if item.key == id {
                currentMode = id;
            }
        }
    }
    
    func getIndexCurrentMode() -> Int {
        if currentMode == "normal" {
            return 0
        } else {
            return (currentMode == "fast" ? 1 : 2)
        }
    }
    
    func getCurrent() -> String {
        return currentMode;
    }

    func getGravity() -> Float {
        return (modes[currentMode]!["gravity"]! as NSString).floatValue;
    }
    func getImpulsion() -> Float {
        return (modes[currentMode]!["impulsion"]! as NSString).floatValue;
    }
    func getSpeedHero() -> Float {
        return (modes[currentMode]!["speedHero"]! as NSString).floatValue;
    }
    func getInterPipe() -> Float {
        return (modes[currentMode]!["interPipe"]! as NSString).floatValue;
    }
}
