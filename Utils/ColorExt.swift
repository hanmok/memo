//
//  ColorExt.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/17.
//

import struct SwiftUI.Color
import SwiftUI
import UIKit

extension Color {
    
    
    init(rgba: Int) {
        self.init(
            .sRGB,
            red: Double((rgba & 0xFF000000) >> 24) / 255,
            green: Double((rgba & 0x00FF0000) >> 16) / 255,
            blue: Double((rgba & 0x0000FF00) >> 8) / 255,
            opacity: Double((rgba & 0x000000FF)) / 255
        )
    }
    
    var asRgba: Int {
        let components = cgColor!.components!
        let (r, g, b, a) = (components[0], components[1], components[2], components[3])
        return
        (Int(a * 255) << 0) +
        (Int(b * 255) << 8) +
        (Int(g * 255) << 16) +
        (Int(r * 255) << 24)
    }
    
    init(red: Int, green: Int, blue: Int) {
        self.init(.sRGB, red: Double(Double(red) / 255.0), green: Double(Double(green) / 255.0), blue: Double(Double(blue) / 255.0))
    }
    
    func convertToUIColor() -> UIColor {
        return UIColor(self)
    }
    
    static func convertToUIColors(colors: [Color]) -> [UIColor] {
        return colors.map { $0.convertToUIColor()}
    }
    
    
    // 색상을.. 이렇게 많이 써야해 ?? ???
    // Dark, Light 해도 최대 6개면 색감 있는 건 충분할 것 같은데..
    

    
    /// dragging Background For Light,  memoTool Background Light,  textField accentColor Light
    static let newColor = Color(red: 181, green: 220, blue: 250)

    
    /// Checkmark Color
//    static let newMain1 = Color(rgba: 0xA3CEEF)
//    static let newMain1 = Color.black
    
    /// dragging Dark Background, plusImage Color
    static let newMain3 = Color(rgba: 0x009DCF)
    
    /// MemoToolbar Background For Dark
    static let newMain4 = Color.yellow
    

    /// white
    static let navColorForDark = UIColor(rgbHex: 0xFFFFFF).convertToColor()
    
    /// black
    static let navColorForLight = UIColor(rgbHex: 0x000000).convertToColor()
    
    
    
    // MARK: - Gray Scale
    /// memoBox Background Light
    static let newMemoBoxColor = Color(.sRGB, red: 0.96, green: 0.96, blue: 0.96, opacity: 1)
    
    /// SecondView DarkMode Background
    static let newBGforDark = Color(.sRGB, red: 0.15, green: 0.15, blue: 0.15, opacity: 1)
    
    
    
    
    
    
    
    static let memoTextColor = Color(UIColor.memoTextColor) // white(0), white(0.8)
    
    static let blackAndWhite = Color(UIColor.blackAndWhite) // white(0), white(1)
    
    static let bgForDark = Color(uiColor: UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1))
    
//    static let swipeBtnColor2 = UIColor(rgbHex: 0xFDAEAC).convertToColor()
    static let swipeBtnColor2 = UIColor(rgbHex: 0xA3CEEF).convertToColor()
    
    static let swipeBtnColor3 = UIColor(rgbHex: 0xFF7F7C).convertToColor()
    
    static let memoBoxColor = Color(UIColor.memoBoxColor)
    
    //    static let navBtnColor = Color(UIColor.navBtnColor)
    static let navBtnColor = Color.navColorForDark
    
    // cream, White(0.65)
    static let textViewTintColor = Color(UIColor.textViewTintColor)

    
//    static let basicColors = Color(UIColor.basicColors)
//    static let basicColors = Color.red
    //    static let basicColors =
    
//    static let buttonTextColor = Color(UIColor.buttonTextColor)
    
    
    
}

extension UIColor {
    
    func convertToColor() -> Color {
        return Color(self)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgbHex: Int) {
        self.init(
            red: (rgbHex >> 16) & 0xFF,
            green: (rgbHex >> 8) & 0xFF,
            blue: rgbHex & 0xFF
        )
    }
}



extension UIColor {
    
//    static let buttonTextColor = UIColor(named: ColorKeys.buttonTextColor)!
    
    static let newBGForDark = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1)
    static let mainColor = UIColor(named: ColorKeys.mainColor)!
    static let subColor = UIColor(named: ColorKeys.subColor)!
    static let memoTextColor = UIColor(named: ColorKeys.memoTextColor)!
    static let blackAndWhite = UIColor(named: ColorKeys.blackAndWhite)!
    
    static let swipeBtnColor1 = UIColor(named: ColorKeys.swipeBtnColor1)!
    static let swipeBtnColor2 = UIColor(named: ColorKeys.swipeBtnColor2)!
    static let swipeBtnColor3 = UIColor(named: ColorKeys.swipeBtnColor3)!
    
    static let pinBarColor = UIColor(named: ColorKeys.pinBarColor)!
    
    static let memoBoxColor = UIColor(named: ColorKeys.memoBoxColor)!
    // dark -> white(0.8, 0.8, 0.8), light -> .black
    static let navBtnColor = UIColor(named: ColorKeys.navBtnColor)!
    //    static let memoBtnColor = UIColor(named: ColorKeys.memoBtnColor)!
    static let selectedBoxStrokeColor = UIColor(named: ColorKeys.selectedBoxStrokeColor)!
    
    static let textViewTintColor = UIColor(named: ColorKeys.textViewTintColor)!
    
    static let memoBoxSwipeBGColor = UIColor(named: ColorKeys.memoBoxSwipeBGColor)!
    
//    static let basicColors = UIColor(named: ColorKeys.basicColors)!
    
}

struct ColorKeys {
    static let newBGForDark = "newBGForDark"
    static let mainColor = "mainColor"
    static let subColor = "subColor"
    static let memoTextColor = "memoViewTextColor"
    static let blackAndWhite = "blackAndWhite"
    
    static let swipeBtnColor1 = "swipeBtnColor1"
    static let swipeBtnColor2 = "swipeBtnColor2"
    static let swipeBtnColor3 = "swipeBtnColor3"
    
    static let swipeBtnImageColor = "swipeBtnImageColor"
    
    static let pinBarColor = "pinBarColor"
    
    static let memoBoxColor = "memoBoxColor"
    static let navBtnColor = "navBtnColor"
    
    static let selectedBoxStrokeColor = "selectedBoxStrokeColor"
    
    static let textViewTintColor = "textViewTintColor"
    
    static let memoBoxSwipeBGColor = "memoBoxSwipeBGColor"
    
//    static let basicColors = "basicColors"
    
    static let buttonTextColor = "buttonTextColor"
}

