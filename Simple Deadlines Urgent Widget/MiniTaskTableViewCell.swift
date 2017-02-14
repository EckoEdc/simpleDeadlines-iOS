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

    // MARK: Outlets
    @IBOutlet weak var counterView: CircleCounterView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Configure func
    
    func configureCell(task: Task) {
        let remainData = task.getRemainingDaysAndColor()
        counterView.color = remainData.1
        counterView.dayRemaining = remainData.0
        titleLabel.text = task.title
    }

}
