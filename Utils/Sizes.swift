//
//  Sizes.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import UIKit

struct Sizes {
    /// 40
    static let largePadding: CGFloat = 40
    /// 20
    static let overallPadding: CGFloat = 20
    /// 28
    static let littleBigPadding: CGFloat = 28
    /// 10, navBtn
    static let properSpacing: CGFloat = 10
    
    static let navBtnLeadingSpacing: CGFloat = 10
    /// 4
    static let minimalSpacing: CGFloat = 4
    /// 4
    static let spacingBetweenMemoBox: CGFloat = 4
    /// 8
    static let smallSpacing: CGFloat = 8
    /// 12
    static let memoVerticalSpacing: CGFloat = 12
    /// 24
    static let memoHorizontalSpacing: CGFloat = 24
    /// 10
    static let largeCornerRadius: CGFloat = 10
    /// 5
    static let smallCornerRadius: CGFloat = 5
    /// 24
    static let regularButtonSize: CGFloat = 24
    /// 6
    static let subFolderLeading: CGFloat = 6
    /// 16
    static let spacingBetweenButtons: CGFloat = 16
}


extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
