//
//  MainTableviewCell.swift
//  Tutorial1
//
//  Copyright © 2019 튜토리얼. All rights reserved.
//

import UIKit

class MainTableviewCell: UITableViewCell {
    static let cell_id = "cell_id_lap"
    
    @IBOutlet weak var timeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = ""
    }
}
