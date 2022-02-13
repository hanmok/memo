//
//  ColorExt.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/17.
//

import struct SwiftUI.Color

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
    
    static var subColor = Color(.sRGB, red: 100/255, green: 200/255, blue: 100/255)
    
    static var subColorDark = Color(.sRGB, red: 50/255, green: 150/255, blue: 50/255)
    
    static var subColor2 = Color(.sRGB, red: 130/255, green: 230/255, blue: 130/255)

    static var subColorDark2 = Color(.sRGB, red: 80/255, green: 180/255, blue: 80/255)
}
