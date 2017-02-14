//
//  TaskTableViewCell.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-01-23.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import UIKit
import LibSimpleDeadlines

class TaskTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var counterView: CircleCounterView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: - Configure func

    func configureCell(task: Task) {

        if task.isDone {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.title!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            nameLabel.attributedText = attributeString
        } else {
            nameLabel.text = task.title
        }
        
        categoryLabel.text = task.category?.name
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        if let date = task.date {
            let dateString = formatter.string(from: date as Date)
            dateLabel.text = dateString
        }
        
        let remainData = task.getRemainingDaysAndColor()
        counterView.dayRemaining = remainData.0
        counterView.color = remainData.1
    }
}
