//
//  TweetsTableViewCell.swift
//  twitter
//
//  Created by Angela Chen on 6/27/16.
//  Copyright © 2016 Angela Chen. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TweetsTableViewCell: UITableViewCell, TTTAttributedLabelDelegate {

    @IBOutlet weak var screenameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet var tweetLabel: TTTAttributedLabel!
    @IBOutlet var avatarButton: UIButton!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
