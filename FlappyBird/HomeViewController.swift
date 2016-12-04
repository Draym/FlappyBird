//
//  HomeViewController.swift
//  FlappyBird
//
//  Created by Admin on 02/12/2016.
//  Copyright © 2016 Fullstack.io. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        birdView.animationImages = [UIImage(named: "bird-1")!, UIImage(named: "bird-2")!, UIImage(named: "bird-3")!, UIImage(named: "bird-4")!];
        birdView.animationDuration = 0.5;
        birdView.startAnimating()
        modeView.selectedSegmentIndex = DifficultyMode.instance.getIndexCurrentMode()
    }

    @IBOutlet weak var modeView: UISegmentedControl!
    @IBOutlet weak var birdView: UIImageView!
    @IBOutlet weak var navbarView: UINavigationItem!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func difficultyChanged(_ sender: UISegmentedControl) {
        changeViewMode(mode: sender.selectedSegmentIndex);
    }
    func changeViewMode(mode : Int) {
        if (mode == 0) {
            DifficultyMode.instance.changeCurrentMode(id: "normal")
        } else if (mode == 1) {
            DifficultyMode.instance.changeCurrentMode(id: "fast")
        } else {
            DifficultyMode.instance.changeCurrentMode(id: "insane")
        }
    };
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
