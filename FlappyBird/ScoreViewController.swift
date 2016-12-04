//
//  ScoreViewController.swift
//  FlappyBird
//
//  Created by Admin on 03/12/2016.
//  Copyright © 2016 Fullstack.io. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var scoreTableView: UITableView!
    
    var scores:[ScoreMO]? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scoreTableView.delegate = self
        scoreTableView.dataSource = self
        scoreTableView.layer.cornerRadius = 4.0
        self.scores = ScoreManager.instance.getScores();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //#warning Incomplete implementation, return the number of rows
        if (scores == nil) {
            scoreTableView.isHidden = true;
            return 0
        }
        scoreTableView.isHidden = false;
        return scores!.count;
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListScoreTableViewCell
        if (scores == nil) {
            return cell
        }
        let score = scores![indexPath.row]
        
        // Configure the cell...
        cell.scoreLabel.text = String(score.score)
        cell.difficultyLabel.text = score.mode
        return cell
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                        forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            scores?.remove(at: indexPath.row)
            ScoreManager.instance.removeScore(index: indexPath.row)
            scoreTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
