//
//  OtherAnswersCell.swift
//  StackOverflow Q&A
//
//  Created by Nolan Fuchs on 1/9/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import UIKit

class OtherAnswersCell: UITableViewCell {

    // This cell sets up the layout for the second view controller at index 2+ (the answers for the corresponding question)
    
    @IBOutlet weak var answerProfilePicture: UIImageView?
    @IBOutlet weak var answerText: UILabel?
    @IBOutlet weak var answerName: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
