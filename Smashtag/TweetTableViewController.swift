//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by AmenophisIII on 9/25/15.
//  Copyright (c) 2015 AmenophisIII. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController , UITextFieldDelegate {

    
    
    
    var tweets = [[Tweet]] () // array of arrays of Tweets
    
    var searchText: String? = "#USC" {
        
        didSet{
            lastSuccessfulRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
        
        
    }
    
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refresh()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    
    
    var lastSuccessfulRequest : TwitterRequest?
    
    var nextRequestToAttempt : TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest (search : searchText!, count: 100)
            } else {return nil}
        } else {
            return lastSuccessfulRequest!.requestForNewer!
        }
    }
    
    
    
    func refresh() {
        if refreshControl != nil{
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
       
    }
    
    
    
    // our refresh
    @IBAction func refresh(sender: UIRefreshControl?) {
        
        if searchText != nil {
            let request = TwitterRequest(search: searchText!, count: 100)
            
            request.fetchTweets { (newTweets) -> Void in
                dispatch_async( dispatch_get_main_queue() ) // the code in the following closure is now off the main queue, but will return after it completes
                    { () -> Void in
                        
                        if newTweets.count > 0 {
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData() // because this is UI stuff, we do Async
                            sender?.endRefreshing()
                            
                        }
                } // end async code, back to the main queue
            }
            
        } else {
            sender?.endRefreshing()
        }

    }
    
    
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }

    // this is what happens when someone presses the enter of my textfield - inspect field to setup
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField{
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true // antique
    }
    
    
    // MARK: - UI Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections - in our case we want the # of arrays/pull requests/refreshes(?)
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return tweets[section].count
    }

    //being a good coder
    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(/* see prev comment*/ Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell

        // Configure the cell...
        
        cell.tweet = tweets[indexPath.section][indexPath.row]
        println( "Hashtags: \(cell.tweet!.hashtags)" )
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
