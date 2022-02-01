//
//  Sizes.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import Foundation
//import UIKit
import SwiftUI

struct Sizes {
    static let largePadding: CGFloat = 40
    static let overallPadding: CGFloat = 20
    static let minimalSpacing: CGFloat = 4
    static let smallSpacing: CGFloat = 8
    static let memoVerticalSpacing: CGFloat = 12
    static let memoHorizontalSpacing: CGFloat = 24
    static let largeCornerRadius: CGFloat = 10
    static let smallCornerRadius: CGFloat = 5
    static let regularButtonSize: CGFloat = 24
    static let subFolderLeading: CGFloat = 6
}


extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
