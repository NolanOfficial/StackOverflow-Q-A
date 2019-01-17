//
//  LoadingCell.swift
//  StackOverflow Q&A
//
//  Created by Nolan Fuchs on 1/16/19.
//  Copyright © 2019 Nolan Fuchs. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
