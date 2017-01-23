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

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var remainingDaysLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let circleLayer = CAShapeLayer()

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
        let dateString = formatter.string(from: task.date! as Date)
        dateLabel.text = dateString
        
        let remainData = task.getRemainingDaysAndColor()
        drawCircle(color: remainData.1)
        remainingDaysLabel.text = String(remainData.0)
    }
    
    func drawCircle(color: UIColor) {
        let width = Double(counterView.bounds.size.width);
        let height = Double(counterView.bounds.size.height);
        circleLayer.bounds = CGRect(x: 2.0, y: 2.0, width: width-2.0, height: height-2.0)
        circleLayer.position = CGPoint(x: width/2, y: height/2);
        let rect = CGRect(x: 2.0, y: 2.0, width: width-2.0, height: height-2.0)
        let path = UIBezierPath.init(ovalIn: rect)
        circleLayer.path = path.cgPath
        circleLayer.fillColor = color.cgColor
        circleLayer.lineWidth = 2.0
        if !counterView.layer.sublayers!.contains(circleLayer) {
            counterView.layer.insertSublayer(circleLayer, at: 0)
        }
    }
}
