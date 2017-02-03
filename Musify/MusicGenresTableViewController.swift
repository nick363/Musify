//
//  MusicGenresTableViewController.swift
//  Musify
//
//  Created by CS3714 on 12/7/16.
//  Copyright © 2016 Nicholas Hu. All rights reserved.
//

import UIKit

class MusicGenresTableViewController: UITableViewController {
    
    @IBOutlet var musicGenresTableView: UITableView!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    var genreNames = [String]()
    var dict_MusicGenres: NSMutableDictionary = NSMutableDictionary()
    var dataObjectToPass: [String] = ["", "", "", "", "", ""]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Set up an Add button in the navigation bar
//        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MyMoviesTableViewController.addMovie(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
        
        dict_MusicGenres = applicationDelegate.dict_MusicGenres
        
        genreNames = applicationDelegate.dict_MusicGenres.allKeys as! [String]
        genreNames.sort { $0 < $1 }
        //print(genreNames)
    }
    
    
    /*
     ----------------------------------------------
     MARK: - Unwind Segue Method
     ----------------------------------------------
     */
    @IBAction func unwindToMusicGenreTableViewController (segue : UIStoryboardSegue) {
        
        if segue.identifier == "ChangeSong-Save" {
            // Obtain the object reference of the source view controller
            let controller: ChangeSongViewController = segue.source as! ChangeSongViewController
            
            let songName: String = controller.songNameLabel.text!
            let artistLabel: String = controller.artistLabel.text!
            let genreLabel: String = controller.genreLabel.text!
            
            // Get the movie rating entered by the user on the AddMovieViewController UI
            let songRatingEntered: Int = controller.ratingSegmentedControl.selectedSegmentIndex
            
            var songRating: String = ""
            
            switch songRatingEntered {
                
            case 0: songRating = "0 stars"
            case 1: songRating = "1 stars"
            case 2: songRating = "2 stars"
            case 3: songRating = "3 stars"
            default:
                print("Invalid")
            }
            
            if (songRating == "") {
                let alertController = UIAlertController(title: "Must Fill all Fields",
                                                        message: "All text fields must have input",
                                                        preferredStyle: UIAlertControllerStyle.alert)
                
                // Create a UIAlertAction object and add it to the alert controller
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                // Present the alert controller by calling the presentViewController method
                self.present(alertController, animated: true, completion: nil)
                
                
            } else {
                let genreDict = applicationDelegate.dict_MusicGenres[genreLabel]
                
                print(genreDict)
                
                //let newGenreDict = genreDict
                (genreDict! as AnyObject).removeObject(forKey: dataObjectToPass[5])
                
                print(genreDict)
                
                var youtubeURL: String = dataObjectToPass[4]
                
                let updatedTask: [String] = [songRating,songName,youtubeURL,artistLabel]
                
                (genreDict! as AnyObject).setValue(updatedTask, forKey: dataObjectToPass[5])
                
                applicationDelegate.dict_MusicGenres.removeObject(forKey: genreLabel)
                applicationDelegate.dict_MusicGenres.setValue(genreDict, forKey: genreLabel)
                
                print(applicationDelegate.dict_MusicGenres)
                
                genreNames = applicationDelegate.dict_MusicGenres.allKeys as! [String]
                
                // Sort the country names within itself in alphabetical order
                genreNames.sort { $0 < $1 }
                
                // Reload the rows and sections of the Table View countryCityTableView
                musicGenresTableView.reloadData()
            }
        
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     -----------------------------
     MARK: - Display Error Message
     -----------------------------
     */
    func showErrorMessageFor(_ fileName: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: "Unable to Access the File: \(fileName)!",
            message: "The file does not reside in the application's main bundle (project folder)!",
            preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return genreNames.count
    }

    //--------------------------------
    // Return Number of Rows in Section
    //--------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let indexLetter = genreNames[section]
        
        let arrayOfGenreNames = applicationDelegate.dict_MusicGenres[indexLetter]
        
        return (arrayOfGenreNames! as AnyObject).count
    }
    
    //----------------------------
    // Set Title for Section Header
    //----------------------------
    
    // Asks the data source to return the section title for a given section number
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        
        return genreNames[section]
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicList", for: indexPath)
        
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        // Obtain the index letter for the given section number
        let genreName = genreNames[sectionNumber]
        
        let musicOfGenre = applicationDelegate.dict_MusicGenres[genreName] as! [String:AnyObject]
        
        let musicData: NSArray = musicOfGenre["\(rowNumber+1)"] as! NSArray
        
        cell.textLabel!.text = musicData[1] as? String
        cell.detailTextLabel!.text = musicData[3] as? String
        
        let movieRating = musicData[0] as? String
        cell.imageView!.image = UIImage(named: movieRating!)
        
        if (indexPath as NSIndexPath).row % 2 == 0 {
            // Set even-numbered row's background color to MintCream, #F5FFFA 245,255,250
            cell.backgroundColor = MINT_CREAM
            
        } else {
            // Set odd-numbered row's background color to OldLace, #FDF5E6 253,245,230
            cell.backgroundColor = OLD_LACE
        }
        
        return cell
    }
    
    //---------------------------
    // Allow for Deletion of Rows
    //---------------------------
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Obtain the name of the country of the city to be deleted
            let genreToDelete = genreNames[(indexPath as NSIndexPath).section]
            
            // Obtain the list of movies in the Genre
            let musicOfGenre = applicationDelegate.dict_MusicGenres[genreToDelete]
            
            (musicOfGenre! as AnyObject).removeObject(forKey: "\(indexPath.row + 1)")
            
            // Check if there are no movies left in the genre dictionary
            if (musicOfGenre! as AnyObject).allKeys.count == 0 {
                
                // If no movies in genre, then we should also delete the genre
                applicationDelegate.dict_MusicGenres.removeObject(forKey: genreToDelete)
                
                //We need to update the genres since the dictionary for that genre has been deleted
                genreNames = applicationDelegate.dict_MusicGenres.allKeys as! [String]
                
                genreNames.sort { $0 < $1 }
                
                musicGenresTableView.reloadData()
                
            } else {
                let start = indexPath.row + 1
                let range = (musicOfGenre! as AnyObject).count+0
                // If there exists at least one movie left in the genre, then we want to update the indexes of all the movies
                //for var index = indexPath.row + 2; index <= (moviesOfGenre! as AnyObject).count+1; index += 1
                if(start <= range) {
                    for var i in start...range
                    {
                        let temp = (musicOfGenre! as AnyObject)["\(i+1)"]
                        //print("temp at : ", i+1)
                        //print(temp)
                        (musicOfGenre! as AnyObject).removeObject(forKey: "\(i+1)")
                        //print("Changing to Location: ", i)
                        (musicOfGenre! as AnyObject).setValue(temp as Any, forKey: "\(i)")
                    }
                }
                
                applicationDelegate.dict_MusicGenres.setValue(musicOfGenre, forKey: genreToDelete)
                //print("Reloading Table")
                //print(applicationDelegate.dict1_MovieGenres[genreToDelete])
                musicGenresTableView.reloadData()
            }
        }
    }
    
    //---------------------------
    // Allow for Movement of Rows
    //---------------------------
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let genre = genreNames[fromIndexPath.section]
        
        // Row number to move FROM
        let rowNumberFrom = fromIndexPath.row
        // Row number to move TO
        let rowNumberTo = to.row
        
        let musicOfGenre = applicationDelegate.dict_MusicGenres[genre]
        
        var firstMusicToMove = (musicOfGenre! as AnyObject)["\(rowNumberFrom + 1)"]
        var lastMovieToMove = (musicOfGenre! as AnyObject)["\(rowNumberTo + 1)"]
        
        if rowNumberFrom > rowNumberTo {
            // Movement is from lower part of the list to the upper part
            // Loop from where Movie is put, and push all movie after it up one position
            for var i in (rowNumberTo + 1)...(rowNumberFrom + 1) {
                let temp = (musicOfGenre! as AnyObject)["\(i)"]
                (musicOfGenre! as AnyObject).removeObject(forKey: "\(i)")
                (musicOfGenre! as AnyObject).setValue(firstMusicToMove as Any, forKey: "\(i)")
                firstMusicToMove = temp
            }
        } else if rowNumberFrom < rowNumberTo {
            // Movement is from upper part of the list to the lower part
            // Loop from the Movies previous position to its new location, and push those movies down a position
            for var i in (rowNumberFrom + 1)...(rowNumberTo) {
                let temp = (musicOfGenre! as AnyObject)["\(i+1)"]
                (musicOfGenre! as AnyObject).removeObject(forKey: "\(i)")
                (musicOfGenre! as AnyObject).setValue(temp as Any, forKey: "\(i)")
            }
            (musicOfGenre! as AnyObject).removeObject(forKey: "\(rowNumberTo + 1)")
            (musicOfGenre! as AnyObject).setValue(firstMusicToMove as Any, forKey: "\(rowNumberTo + 1)")
        }
        
        // Update the new list of cities for the Movies in the NSMutableDictionary
        applicationDelegate.dict_MusicGenres.setValue(musicOfGenre, forKey: genre)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    //--------------------------
    // Movement of City Approval
    //--------------------------
    
    // This method is invoked when the user attempts to move a row (city)
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        let genreFrom = genreNames[(sourceIndexPath as NSIndexPath).section]
        let genreTo = genreNames[(proposedDestinationIndexPath as NSIndexPath).section]
        
        if genreFrom != genreTo {
            
            // The user attempts to move a movie from one genre to another, which is prohibited
            
            /*
             Create a UIAlertController object; dress it up with title, message, and preferred style;
             and store its object reference into local constant alertController
             */
            let alertController = UIAlertController(title: "Move Not Allowed!",
                                                    message: "Order music according to your liking only within the same genre!",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            // Create a UIAlertAction object and add it to the alert controller
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Present the alert controller by calling the presentViewController method
            present(alertController, animated: true, completion: nil)
            
            return sourceIndexPath  // The row (city) movement is denied
        }
        else {
            return proposedDestinationIndexPath  // The row (city) movement is approved
        }
        
    }
    
    //--------------------------------
    // Row Has Been Tapped
    //--------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        let genreName = genreNames[sectionNumber]
        
        let moviesOfGenre = dict_MusicGenres[genreName] as! [String:AnyObject]
        let movieData: NSArray = moviesOfGenre["\(rowNumber+1)"] as! NSArray
        
        dataObjectToPass[0] = (movieData[1] as? String)!
        dataObjectToPass[1] = (movieData[2] as? String)!
        
        performSegue(withIdentifier: "showMusicVideo", sender: self)
    }
    
    //--------------------------------
    // Detail Disclosure Button Tapped
    //--------------------------------
    // This is the method invoked when the user taps the Detail Disclosure button (circle icon with i)
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let sectionNumber = (indexPath as NSIndexPath).section
        let rowNumber = (indexPath as NSIndexPath).row
        
        let genreName = genreNames[sectionNumber]
        
        let musicOfGenre = dict_MusicGenres[genreName] as! [String:AnyObject]
        let movieData: NSArray = musicOfGenre["\(rowNumber+1)"] as! NSArray
        
        dataObjectToPass[0] = (movieData[0] as? String)!
        dataObjectToPass[1] = (movieData[1] as? String)!
        dataObjectToPass[2] = (movieData[3] as? String)!
        dataObjectToPass[3] = genreName
        dataObjectToPass[4] = (movieData[2] as? String)!
        dataObjectToPass[5] = String(rowNumber + 1)
        
        performSegue(withIdentifier: "editSong", sender: self)
    }
    
    /*
     -------------------------
     MARK: - Prepare for Segue
     -------------------------
     */
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMusicVideo" {
            
            // Obtain the object reference of the destination (downstream) view controller
            let musicVideoViewController: MusicVideoViewController = segue.destination as! MusicVideoViewController
            
            /*
             This view controller creates the dataObjectToPass and passes it (by value) to the downstream view controller
             MovieTrailerViewController by copying its content into MovieTrailerViewController property dataObjectPassed.
             */
            musicVideoViewController.dataObjectPassed = dataObjectToPass
            
        }
        if segue.identifier == "editSong" {
            
            // Obtain the object reference of the destination (downstream) view controller
            let changeSongViewController: ChangeSongViewController = segue.destination as! ChangeSongViewController
            
            /*
             This view controller creates the dataObjectToPass and passes it (by value) to the downstream view controller
             MovieTrailerViewController by copying its content into MovieTrailerViewController property dataObjectPassed.
             */
            changeSongViewController.dataObjectPassed = dataObjectToPass
            
        }
    }

}
