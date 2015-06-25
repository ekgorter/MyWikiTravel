//
//  GuideCell.swift
//  MyWikiTravel
//
//  Created by Elias Gorter on 19-06-15.
//  Copyright (c) 2015 EliasGorter6052274. All rights reserved.
//
// Custom tableview cell for cells in MyGuides containing a custom label.

import Foundation
import UIKit

class GuideCell: UITableViewCell {
    
    @IBOutlet weak var guideTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}