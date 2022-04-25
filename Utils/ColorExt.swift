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
    
    static var subColorDark2 = Color(.sRGB, red: 80/255, green: 180/255, blue: 80/255)
    
    // second subColor
    
    static var weekSubColor = Color(.sRGB, red: 150/255, green: 220/255, blue: 150/255)
    
    // ivory Colors
    
    static let ivory = Color(red: 214, green: 207, blue: 181)
    
    // MAIN COLOR
    static let cream = Color(red: 244, green: 240, blue: 211)

    static let bone = Color(red: 196, green: 192, blue: 175)
    static let darkCream = Color(red: 144, green: 140, blue: 111)
    static let ecru = Color(red: 237, green: 223, blue: 200)
    
    
    static let pastelColors: [Color] = [
        Color(red: 244, green: 240, blue: 211),
        Color(red: 243, green: 239, blue: 210),
        Color(red: 242, green: 238, blue: 209),
        Color(red: 241, green: 237, blue: 208),
        Color(red: 240, green: 236, blue: 207),
        Color(red: 239, green: 235, blue: 206),
        Color(red: 238, green: 234, blue: 205),
        Color(red: 237, green: 233, blue: 204),
        Color(red: 236, green: 232, blue: 203),
        Color(red: 235, green: 231, blue: 202),
        Color(red: 234, green: 230, blue: 201),
        Color(red: 233, green: 229, blue: 200),
        Color(red: 232, green: 228, blue: 199),
        Color(red: 231, green: 227, blue: 198),
        Color(red: 230, green: 226, blue: 197)
    ]
    
    
    
    static let someIvorys: [Color] = [
        Color(red: 248, green: 250, blue: 230),
        Color(red: 254, green: 253, blue: 246),
        Color(red: 246, green: 244, blue: 232)
    ]
    
    static let newMain = UIColor(rgbHex: 0xFDAEAC).convertToColor()
    
//    static let newNav = UIColor(rgbHex: 0xFFBFBC).convertToColor()
//    static let newNav = UIColor(rgbHex: 0xFFD5D3).convertToColor()
//    static let newNavForDark = UIColor(rgbHex: 0xFFDAD8).convertToColor()
    static let newNavForDark = UIColor(rgbHex: 0x6666BB).convertToColor()
//    static let newNavForLight = UIColor(rgbHex: 0xF87577).convertToColor().opacity(0.7)
//    static let newNavForLight = UIColor(rgbHex: 0x161FA7).convertToColor().opacity(0.7) // 약간 애매..
//    static let newNavForLight = UIColor(rgbHex: 0x0A1172).convertToColor().opacity(0.7) // 괜찮아 보이는데.. ?
//    static let newNavForLight = UIColor(rgbHex: 0x002147).convertToColor().opacity(0.7) // OxFord blue
//    static let newNavForLight = UIColor(rgbHex: 0x0055BB).convertToColor().opacity(0.7) //
//    static let newNavForLight = UIColor(rgbHex: 0x0033CC).convertToColor().opacity(0.7) //
    static let newNavForLight = UIColor(rgbHex: 0x000077).convertToColor().opacity(0.7)   // purple
    
    static let newMemoToolBoxColor = UIColor(rgbHex: 0x000077).convertToColor()   // purple
//    static let newNavForLight = UIColor(rgbHex: 0x000077).convertToColor().opacity(0.7)   // purple
    
    
//    static let newMain = Color(red: 248, green: 250, blue: 230)
//    static let some = Color(
//    (red: 0.973, green: 0.459, blue: 0.467, alpha: 1)
    

    static let pastelUIColors = Color.convertToUIColors(colors: Color.pastelColors)
    static let testColor = UIColor(rgbHex: 0xFAE5C5).convertToColor() // look fine
    static let testColor2 = UIColor(rgbHex: 0xFAEACA).convertToColor()
    static let testColor3 = UIColor(rgbHex: 0xFFE7E5).convertToColor() // looks good!
    static let newMemoBoxColor = UIColor(rgbHex: 0xFFE9E7).convertToColor() // looks better!
    
    static let bgForDark = UIColor(rgbHex: 0x551308).convertToColor()

    
}




extension Color {
    init(red: Int, green: Int, blue: Int) {
        self.init(.sRGB, red: Double(Double(red) / 255.0), green: Double(Double(green) / 255.0), blue: Double(Double(blue) / 255.0))
    }
    
    func convertToUIColor() -> UIColor {
        return UIColor(self)
    }
    
    static func convertToUIColors(colors: [Color]) -> [UIColor] {
        return colors.map { $0.convertToUIColor()}
    }
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





extension Color {
    // Dark, Light 
    static let mainColor = Color(UIColor.mainColor) // 244 240 211, white(29)
    static let subColor = Color(UIColor.subColor) // 232 227 199
    
    static let memoTextColor = Color(UIColor.memoTextColor) // white(0), white(0.8)
    
    static let blackAndWhite = Color(UIColor.blackAndWhite) // white(0), white(1)
    
    static let swipeBtnColor1 = Color(UIColor.swipeBtnColor1) // 232 227 199, 202 197 169 ( == subColor)
    static let swipeBtnColor2 = Color(UIColor.swipeBtnColor2) // 212 207 179, 182 177 149
    static let swipeBtnColor3 = Color(UIColor.swipeBtnColor3) // 192 187 159, 162 157 129
    
    static let pinBarColor = Color(UIColor.pinBarColor) //212 207 179, 182 177 149 (== 3, 2)
    
    static let memoBoxColor = Color(UIColor.memoBoxColor)

//    static let navBtnColor = Color(UIColor.navBtnColor)
    static let navBtnColor = Color.newNavForDark
    
//    static let memoBtnColor = Color(UIColor.memoBtnColor)
    static let selectedBoxStrokeColor = Color(UIColor.selectedBoxStrokeColor)
    // cream, White(0.65)
    static let textViewTintColor = Color(UIColor.textViewTintColor)
    
    static let memoBoxSwipeBGColor = Color(UIColor.memoBoxSwipeBGColor)
//    UIColor(named: ColorKeys.memoBoxSwipeBGColor)!
    
    static let basicColors = Color(UIColor.basicColors)
    
    static let buttonTextColor = Color(UIColor.buttonTextColor)
}

extension UIColor {
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
    
    static let basicColors = UIColor(named: ColorKeys.basicColors)!
    
    static let buttonTextColor = UIColor(named: ColorKeys.buttonTextColor)!
}

struct ColorKeys {
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
    
    static let basicColors = "basicColors"
    
    static let buttonTextColor = "buttonTextColor"
}

