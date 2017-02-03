//
//  ChangeSongViewController.swift
//  Musify
//
//  Created by CS3714 on 12/7/16.
//  Copyright © 2016 Nicholas Hu. All rights reserved.
//

import UIKit

class ChangeSongViewController: UIViewController {

    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var ratingSegmentedControl: UISegmentedControl!
    
    var dataObjectPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songNameLabel.text = dataObjectPassed[1]
        artistLabel.text = dataObjectPassed[2]
        genreLabel.text = dataObjectPassed[3]
        
        let toDoPrioritySegment = dataObjectPassed[0]
        switch toDoPrioritySegment {
        case "0 stars":
            ratingSegmentedControl.selectedSegmentIndex = 0
        case "1 stars":
            ratingSegmentedControl.selectedSegmentIndex = 1
        case "2 stars":
            ratingSegmentedControl.selectedSegmentIndex = 2
        case "3 stars":
            ratingSegmentedControl.selectedSegmentIndex = 3
        default:
            print("Invalid Priority")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
