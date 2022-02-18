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
    static var subColor = Color(.sRGB, red: 100/255, green: 200/255, blue: 100/255)
    
    static var subColorDark = Color(.sRGB, red: 50/255, green: 150/255, blue: 50/255)
    
    // subColor
    static var subColor2 = Color(.sRGB, red: 130/255, green: 230/255, blue: 130/255)

    static var subColorDark2 = Color(.sRGB, red: 80/255, green: 180/255, blue: 80/255)
    
    // second subColor
    
    static var weekSubColor = Color(.sRGB, red: 150/255, green: 220/255, blue: 150/255)
    
    // ivory Colors
    
//    static let ivory = Color(.sRGB, red: 214/255, green: 207/255, blue: 181/255)
    static let ivory = Color(red: 214, green: 207, blue: 181)
    
    static let cream = Color(red: 244, green: 240, blue: 211)

    static let bone = Color(red: 196, green: 192, blue: 175)
    static let darkCream = Color(red: 144, green: 140, blue: 111)
    static let ecru = Color(red: 237, green: 223, blue: 200)
    
    
    static let pastelColors: [Color] = [
        Color(red: 235, green: 165, blue: 138),
        Color(red: 242, green: 196, blue: 181),
        Color(red: 238, green: 191, blue: 202),
        Color(red: 245, green: 203, blue: 141),
        Color(red: 251, green: 245, blue: 173),
        Color(red: 146, green: 199, blue: 160),
        Color(red: 172, green: 211, blue: 198),
        Color(red: 207, green: 228, blue: 191),
        Color(red: 221, green: 240, blue: 251),
        Color(red: 197, green: 222, blue: 243),
        Color(red: 175, green: 194, blue: 225),
        Color(red: 229, green: 209, blue: 224),
//        someIvorys
        Color(red: 248, green: 250, blue: 230),
        Color(red: 254, green: 253, blue: 246),
        Color(red: 246, green: 244, blue: 232)
        // original
//        Color(red: 198, green: 184, blue: 215),
//        Color(red: 221, green: 221, blue: 237),
//        Color(red: 226, green: 195, blue: 199)
    ]
    
    static let someIvorys: [Color] = [
        Color(red: 248, green: 250, blue: 230),
        Color(red: 254, green: 253, blue: 246),
        Color(red: 246, green: 244, blue: 232)
    ]
    
//    static let ui: UIColor = UIColor(red:1, green: 1, blue: 1, withAlpha: 0)
    static let pastelUIColors = Color.convertToUIColors(colors: Color.pastelColors)
}

extension UIColor {
//    convenience init(red:Double, green: Double, blue: Double, withAlpha: Double = 1) {
////    init(red:Double, green: Double, blue: Double, int: Bool) {
//        self.init(red: red / 255.0, green: green / 255, blue: blue / 255)
//    }
    
    
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


extension ColorScheme {
     func adjustBlackAndWhite() -> Color {
        return self == .dark ? .white : .black
    }
 
    func adjustMainColors() -> Color {
        return self == .dark ? Color.cream : Color.cream
    }
    
    func adjustSecondSubColors() -> Color {
        return self == .dark ? Color.ivory : Color.ivory
    }
}

extension Color {
    static func applyMainColor() -> Color {
        return Color(UIColor(named: "mainColor")!)
    }
}

