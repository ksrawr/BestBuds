//
//  TableViewCell.swift
//  BestBuds
//
//  Created by Khoi Dao on 5/12/19.
//  Copyright © 2019 An Dao & Kenneth Surban. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
