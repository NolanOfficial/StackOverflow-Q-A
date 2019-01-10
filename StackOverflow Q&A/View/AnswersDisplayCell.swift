//
//  AnswersDisplayCell.swift
//  StackOverflow Q&A
//
//  Created by Nolan Fuchs on 1/9/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import UIKit

class AnswersDisplayCell: UITableViewCell {
    
    // This cell sets up everything for the index.row 1 for the second view controller (body of the question)
    
    @IBOutlet weak var answerBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
