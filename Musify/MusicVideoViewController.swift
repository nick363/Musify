//
//  MusicVideoViewController.swift
//  Musify
//
//  Created by CS3714 on 12/7/16.
//  Copyright © 2016 Nicholas Hu. All rights reserved.
//

import UIKit

class MusicVideoViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    var dataObjectPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labelRect = CGRect(x: 0, y: 0, width: 300, height: 42)
        let titleLabel = UILabel(frame: labelRect)
        titleLabel.text = dataObjectPassed[0] // Movie Title
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel
        
        //display the YouTube movie trailer player as embedded within a UIWebView
        let youTubeMovieTrailerID = dataObjectPassed[1]
        let youTubeURL = "http://www.youtube.com/embed/\(youTubeMovieTrailerID)"
        
        
        // Obtain the URL structure instance from the given websiteURL
        let url = URL(string: youTubeURL)
        
        // Obtain the URLRequest structure instance from the given url
        let request = URLRequest(url: url!)
        
        // Ask the web view object to display the web page for the requested URL
        webView.loadRequest(request)
        
    }
    
    /******************************************************************************************
     * UIWebView Delegate Methods: These methods must be implemented whenever UIWebView is used.
     ******************************************************************************************/
    
    override func viewDidAppear(_ animated: Bool) {
        /*
         --------------------------------------------------------------------
         Force this view to be displayed only in Landscape device orientation
         --------------------------------------------------------------------
         */
        let landscapeValue = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(landscapeValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        // Starting to load the web page. Show the animated activity indicator in the status bar
        // to indicate to the user that the UIWebVIew object is busy loading the web page.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // Finished loading the web page. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        /*
         Ignore this error if the page is instantly redirected via javascript or in another way.
         NSURLErrorCancelled is returned when an asynchronous load is cancelled, which happens
         when the page is instantly redirected via javascript or in another way.
         */
        if (error as NSError).code == NSURLErrorCancelled  {
            print("ERROR")
            return
        }
        
        // An error occurred during the web page load. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        // Create the error message in HTML as a character string and store it into the local constant errorString
        let errorString = "<html><font size=+2 color='red'><p>An error occurred: <br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>" + error.localizedDescription
        
        // Display the error message within the UIWebView object
        // self. is required here since this method has a parameter with the same name.
        webView.loadHTMLString(errorString, baseURL: nil)
    }


}
