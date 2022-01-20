//
//  ChangeableImage.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/22.
//

import SwiftUI

struct ChangeableImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var imageSystemName: String
    var width: CGFloat = 20
    var height: CGFloat = 20
    var body: some View {

        Image(systemName: imageSystemName)
            .resizable()
            .aspectRatio( contentMode: .fit)
            .tint(colorScheme == .dark ? .white : .black)
            .frame(width: width, height: height)
    }
}

//struct ChangeableImage_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeableImage()
//    }
//}


//extension ChangeableImage : StringProtocol {
//    typealias UTF8View = <#type#>
//
//    typealias UTF16View = <#type#>
//
//    typealias UnicodeScalarView = <#type#>
//
//    var startIndex: String.Index {
//        <#code#>
//    }
//
//    var endIndex: String.Index {
//        <#code#>
//    }
//
//    mutating func write(_ string: String) {
//        <#code#>
//    }
//
//    func write<Target>(to target: inout Target) where Target : TextOutputStream {
//        <#code#>
//    }
//
//    var description: String {
//        <#code#>
//    }
//
//
//}
