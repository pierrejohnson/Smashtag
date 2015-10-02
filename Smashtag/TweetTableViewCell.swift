//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by AmenophisIII on 9/25/15.
//  Copyright (c) 2015 AmenophisIII. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    
    var tweet : Tweet? {
        didSet {
            updateUI()
        }
    }
    
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    
    func updateUI(){
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        // tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet{              // if we can load stuff in the tweet
            tweetTextLabel?.text = tweet.text   // set the label
            if tweetTextLabel?.text != nil {    // if the text is not nil
                for _ in tweet.media {          // if there is a MEDIA
                    tweetTextLabel.text! += " 📷"
                }
                for _ in tweet.hashtags{          // if there are Hashtags, PER HASHTAG
                   // tweetTextLabel.font = UIFont(name: "QuicksandDash-Regular", size: 35)
                   // tweetTextLabel.decreaseSize(self)
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL){ // blocks main thread! // blocks main thread! // blocks main thread!
                    tweetProfileImageView?.image = UIImage (data:imageData)
                }
            }
            
            
            
            let formatter = NSDateFormatter ()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle // ??
            }
            // tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
            
            
        } // end if let tweet /
    } // end updateUI()
    
    
    
} // end class
