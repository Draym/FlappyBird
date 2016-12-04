//
//  ScoreManager.swift
//  FlappyBird
//
//  Created by Admin on 03/12/2016.
//  Copyright © 2016 Fullstack.io. All rights reserved.
//

import Foundation
import UIKit

class ScoreManager {
    static let instance = ScoreManager()

    var scores = [ScoreMO]()
    
    private func initialise() {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            if FileManager().fileExists(atPath:ScoreMO.StoreURL.path) {
                if let fetchedList = appDelegate.fetchContext() {
                    scores += fetchedList }
            }
        }
    }
    
    func addScore(mode: String, score: Int) {
        if score > 0 {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let scoreMo = appDelegate.addToContext(mode: mode, score: score)
                scores.append(scoreMo);
            }
        }
    }
    
    func removeScore(index: Int) {
        let score = scores[index]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            appDelegate.deleteFromContext(score: score)
            scores.remove(at: index)
        }
        //tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func getScores() -> [ScoreMO] {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            if FileManager().fileExists(atPath:ScoreMO.StoreURL.path) {
                if let fetchedList = appDelegate.fetchContext() {
                    scores = fetchedList }
            }
        }
        return getOrderScores();
    }
    
    func getOrderScores() -> [ScoreMO] {
        return scores.sorted(by: { $0.score > $1.score })
    }
    
    private init() {
        initialise();
    }
    
    func getBestScore(mode: String) -> Int {
        
        var value = 0;
        for item in scores {
            if (item.mode == mode && Int(item.score) > value) {
                value = Int(item.score)
            }
        }
        return value;
    }
    
    /*
    private func archive() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: Score.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save the score list ...")
        }
    }
    
    private func loadList() -> [Score]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Score.ArchiveURL.path) as? [Score]
    }
    
    func getScores() -> [Score]? {
        return loadList()
    }
    
    func saveScore(mode: String, score: Int) {
        if (score > 0) {
            scores.append(Score(mode: mode, score: score)!)
            archive()
        }
    }
    
    
    private init() {
        print("init")
        if let savedList = loadList() {
            scores += savedList
        }
    }
    */
    
}
