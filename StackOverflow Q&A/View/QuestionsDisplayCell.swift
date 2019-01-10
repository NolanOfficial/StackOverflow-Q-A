//
//  QuestionsDisplayCell.swift
//  StackOverflow Q&A
//
//  Created by Nolan Fuchs on 1/8/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import UIKit

class QuestionsDisplayCell: UITableViewCell {
    
    // This cell sets up everything for the first view controller (Questions Only)

    @IBOutlet weak var questionProfilePicture: UIImageView?
    @IBOutlet weak var questionTitle: UILabel?
    @IBOutlet weak var questionOwnerName: UILabel?
    @IBOutlet weak var questionNumberOfAnswers: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
