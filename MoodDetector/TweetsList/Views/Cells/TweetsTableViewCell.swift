//
//  TweetsTableViewCell.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {
    @IBOutlet weak var tweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Configure cell
    func configure(tweet: Tweet) {
        tweetLabel.text = tweet.text
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tweetLabel.text = nil
    }
}
