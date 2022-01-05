//
//  NSPredicate+helper.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/01/05.
//

import CoreData
import Foundation

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}
