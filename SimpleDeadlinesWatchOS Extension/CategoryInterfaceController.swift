//
//  CategoryInterfaceController.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-01-26.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import WatchKit
import Foundation

class CategoryRow: NSObject {
    @IBOutlet var nameLabel: WKInterfaceLabel!
    var categoryName: String = ""
}

class CategoryInterfaceController: WKInterfaceController {

    var interfaceController: InterfaceController? = nil
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        interfaceController = context as? InterfaceController
        
        guard interfaceController != nil else {return}
        
        self.tableView.setNumberOfRows(interfaceController!.category.count, withRowType: "categoryRow")

        for i in 0 ..< interfaceController!.category.count {
            if let row = self.tableView.rowController(at: i) as? CategoryRow {
                row.nameLabel.setText(interfaceController!.category[i])
                row.categoryName = interfaceController!.category[i]
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if let row = self.tableView.rowController(at: rowIndex) as? CategoryRow {
            interfaceController?.currentCategory = row.categoryName
        }
        pop()
    }

}
