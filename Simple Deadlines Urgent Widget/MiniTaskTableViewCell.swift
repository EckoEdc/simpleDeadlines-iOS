//
//  MiniTaskTableViewCell.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-01-24.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import UIKit
import LibSimpleDeadlines

class MiniTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var counterView: CircleCounterView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(task: Task) {
        let remainData = task.getRemainingDaysAndColor()
        counterView.color = remainData.1
        counterView.dayRemaining = remainData.0
        titleLabel.text = task.title
    }

}
