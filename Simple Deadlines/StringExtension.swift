//
//  StringExtension.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-07-10.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import Foundation

extension String {
    func capitalizedFirst() -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased() + rest.lowercased()
    }
    
    func capitalizedFirst(with: Locale?) -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased(with: with) + rest.lowercased(with: with)
    }
}
