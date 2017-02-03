//
//  MyFavoritesTableViewController.swift
//  Musify
//
//  Created by CS3714 on 12/8/16.
//  Copyright © 2016 Nicholas Hu. All rights reserved.
//

import UIKit

class MyFavoritesTableViewController: UITableViewController {

    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var myFavoritesTableView: UITableView!
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    // Grab the information from AppDelegate
    var genreNames = [String]()
    var dict_MusicGenres: NSMutableDictionary = NSMutableDictionary()
    
    // Hold the dictionaries based on favorites so that its organized
    var threeStars: NSMutableDictionary = NSMutableDictionary()
    var twoStars: NSMutableDictionary = NSMutableDictionary()
    var oneStars: NSMutableDictionary = NSMutableDictionary()
    
    
    // Make sure to update Table View everytime
    override func viewDidAppear(_ animated: Bool) {
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        
        // Set up an Add button in the navigation bar
        //        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MyMoviesTableViewController.addMovie(_:)))
        //        self.navigationItem.rightBarButtonItem = addButton
        
        dict_MusicGenres = applicationDelegate.dict_MusicGenres
        
        genreNames = applicationDelegate.dict_MusicGenres.allKeys as! [String]
        genreNames.sort { $0 < $1 }
        
        // Indexes for each dictionary
        var a = 1
        var b = 1
        var c = 1
        
        // Loop through all the music in the plist to check for number of Stars
        for i in 0..<genreNames.count {
            // Grab the name of the genre and acquire the dictionary of that genre
            let genre = genreNames[i]
            let genreSongs = dict_MusicGenres[genre] as! NSMutableDictionary
            // Key the dictionary so that we can loop through the songs in that dictionary
            let songsDataArray = genreSongs.allKeys as! [String]
            
            for j in 0..<songsDataArray.count {
                // Check each song and see how many stars it has and store it in the respective dictionary
                let index = String(j + 1)
                let songData = genreSongs[index] as! [String]
                if (songData[0] == "3 stars") {
                    threeStars.setValue(songData, forKey: String(a))
                    a += 1
                }
                if (songData[0] == "2 stars") {
                    twoStars.setValue(songData, forKey: String(b))
                    b += 1
                }
                if (songData[0] == "1 stars") {
                    oneStars.setValue(songData, forKey: String(c))
                    c += 1
                }
            }
            
        }
        
        myFavoritesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //--------------------------------
    // Return Number of Rows in Section
    //--------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (threeStars.allKeys as! [String]).count + (twoStars.allKeys as! [String]).count + (oneStars.allKeys as! [String]).count
    }

    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteList", for: indexPath)
        let rowNumber = (indexPath as NSIndexPath).row
        
        var musicData = NSArray()
        // Since all dictionaries start with Key of 1, we will need to keep track of the size of the other dictionaries
        let size2: Int = (threeStars.allKeys as! [String]).count + (twoStars.allKeys as! [String]).count
        // The first rownumbers starting from 0 will go to the Three Star songs
        if (rowNumber < (threeStars.allKeys as! [String]).count) {
            musicData = threeStars["\(rowNumber+1)"] as! NSArray
        }
        // After all Three stars have been used, move on to the Two Stars
        else if (rowNumber >= (threeStars.allKeys as! [String]).count && rowNumber < size2) {
            musicData = twoStars["\(rowNumber+1 - (threeStars.allKeys as! [String]).count)"] as! NSArray
        }
        // And Finally the One Stars
        else {
            musicData = oneStars["\(rowNumber+1 - size2)"] as! NSArray
        }
        
        // Set up the Cells
        cell.textLabel!.text = musicData[1] as? String
        cell.detailTextLabel!.text = musicData[3] as? String
        
        let movieRating = musicData[0] as? String
        cell.imageView!.image = UIImage(named: movieRating!)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
