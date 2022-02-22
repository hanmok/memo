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
    
//    static var mainColor = Color(.sRGB, red: 140/255, green: 180/255, blue: 140/255)
    
    // Those two are mainColors
//    static var subColor = Color(.sRGB, red: 100/255, green: 200/255, blue: 100/255)
    
//    static var subColorDark = Color(.sRGB, red: 50/255, green: 150/255, blue: 50/255)
    
    // subColor
//    static var subColor2 = Color(.sRGB, red: 130/255, green: 230/255, blue: 130/255)

    static var subColorDark2 = Color(.sRGB, red: 80/255, green: 180/255, blue: 80/255)
    
    // second subColor
    
    static var weekSubColor = Color(.sRGB, red: 150/255, green: 220/255, blue: 150/255)
    
    // ivory Colors
    
//    static let ivory = Color(.sRGB, red: 214/255, green: 207/255, blue: 181/255)
    static let ivory = Color(red: 214, green: 207, blue: 181)
    
    // MAIN COLOR
    static let cream = Color(red: 244, green: 240, blue: 211)

    static let bone = Color(red: 196, green: 192, blue: 175)
    static let darkCream = Color(red: 144, green: 140, blue: 111)
    static let ecru = Color(red: 237, green: 223, blue: 200)
    
    
//    static let pastelColors: [Color] = [
//        Color(red: 235, green: 165, blue: 138),
//        Color(red: 242, green: 196, blue: 181),
//        Color(red: 238, green: 191, blue: 202),
//        Color(red: 245, green: 203, blue: 141),
//        Color(red: 251, green: 245, blue: 173),
//        Color(red: 146, green: 199, blue: 160),
//        Color(red: 172, green: 211, blue: 198),
//        Color(red: 207, green: 228, blue: 191),
//        Color(red: 221, green: 240, blue: 251),
//        Color(red: 197, green: 222, blue: 243),
//        Color(red: 175, green: 194, blue: 225),
//        Color(red: 229, green: 209, blue: 224),
////        someIvorys
//        Color(red: 248, green: 250, blue: 230),
//        Color(red: 254, green: 253, blue: 246),
//        Color(red: 246, green: 244, blue: 232)
//        // original
////        Color(red: 198, green: 184, blue: 215),
////        Color(red: 221, green: 221, blue: 237),
////        Color(red: 226, green: 195, blue: 199)
//    ]
    
    // cream Color Tests, lighter
//    static let pastelColors: [Color] = [
//        Color(red: 244, green: 240, blue: 211),
//        Color(red: 245, green: 241, blue: 212),
//        Color(red: 246, green: 242, blue: 213),
//        Color(red: 247, green: 243, blue: 214),
//        Color(red: 248, green: 244, blue: 215),
//        Color(red: 249, green: 245, blue: 216),
//        Color(red: 250, green: 246, blue: 217),
//        Color(red: 251, green: 247, blue: 218),
//        Color(red: 252, green: 248, blue: 219),
//        Color(red: 253, green: 249, blue: 220),
//        Color(red: 254, green: 250, blue: 221),
//        Color(red: 255, green: 251, blue: 222),
//        Color(red: 244, green: 252, blue: 223),
//        Color(red: 244, green: 253, blue: 224),
//        Color(red: 244, green: 254, blue: 225)
//    ]
    
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
    

    static let pastelUIColors = Color.convertToUIColors(colors: Color.pastelColors)
}

extension UIColor {
}

extension Color {
    init(red: Double, green: Double, blue: Double) {
        self.init(.sRGB, red: Double(red / 255.0), green: Double(green / 255.0), blue: Double(blue / 255.0))
    }
    
    func convertToUIColor() -> UIColor {
        return UIColor(self)
    }
    
    static func convertToUIColors(colors: [Color]) -> [UIColor] {
        return colors.map { $0.convertToUIColor()}
    }
}


extension Color {
    // Dark, Light 
    static let mainColor = Color(UIColor.mainColor) // 244 240 211, white(29)
    static let subColor = Color(UIColor.subColor) // 232 227 199
    static let memoViewTextColor = Color(UIColor.memoTextColor) // white(0), white(0.8)
    static let blackAndWhite = Color(UIColor.blackAndWhite) // white(0), white(1)
    
    static let swipeBtnColor1 = Color(UIColor.swipeBtnColor1) // 232 227 199, 202 197 169 ( == subColor)
    static let swipeBtnColor2 = Color(UIColor.swipeBtnColor2) // 212 207 179, 182 177 149
    static let swipeBtnColor3 = Color(UIColor.swipeBtnColor3) // 192 187 159, 162 157 129
    
    static let bookmarkBarColor = Color(UIColor.bookmarkBarColor) //212 207 179, 182 177 149 (== 3, 2)
    
    static let memoBoxColor = Color(UIColor.memoBoxColor)

    static let navBtnColor = Color(UIColor.navBtnColor)
//    static let memoBtnColor = Color(UIColor.memoBtnColor)
    static let selectedBoxStrokeColor = Color(UIColor.selectedBoxStrokeColor)
    // cream, White(0.65)
}

extension UIColor {
    static let mainColor = UIColor(named: ColorKeys.mainColor)!
    static let subColor = UIColor(named: ColorKeys.subColor)!
    static let memoTextColor = UIColor(named: ColorKeys.memoViewTextColor)!
    static let blackAndWhite = UIColor(named: ColorKeys.blackAndWhite)!
    
    static let swipeBtnColor1 = UIColor(named: ColorKeys.swipeBtnColor1)!
    static let swipeBtnColor2 = UIColor(named: ColorKeys.swipeBtnColor2)!
    static let swipeBtnColor3 = UIColor(named: ColorKeys.swipeBtnColor3)!
    
    static let bookmarkBarColor = UIColor(named: ColorKeys.bookmarkBarColor)!
    
    static let memoBoxColor = UIColor(named: ColorKeys.memoBoxColor)!
    // dark -> white(0.8, 0.8, 0.8), light -> .black
    static let navBtnColor = UIColor(named: ColorKeys.navBtnColor)!
//    static let memoBtnColor = UIColor(named: ColorKeys.memoBtnColor)!
    static let selectedBoxStrokeColor = UIColor(named: ColorKeys.selectedBoxStrokeColor)!
}

struct ColorKeys {
    static let mainColor = "mainColor"
    static let subColor = "subColor"
    static let memoViewTextColor = "memoViewTextColor"
    static let blackAndWhite = "blackAndWhite"
    
    static let swipeBtnColor1 = "swipeBtnColor1"
    static let swipeBtnColor2 = "swipeBtnColor2"
    static let swipeBtnColor3 = "swipeBtnColor3"
    
    static let swipeBtnImageColor = "swipeBtnImageColor"
    
    static let bookmarkBarColor = "bookmarkBarColor"
    
    static let memoBoxColor = "memoBoxColor"
    static let navBtnColor = "navBtnColor"
//    static let memoBtnColor = "memoBtnColor"
    static let selectedBoxStrokeColor = "selectedBoxStrokeColor"
}

