//
//  PlusImage.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

struct PlusImage: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        
        ZStack {
            ChangeableImage(imageSystemName: "circle", width: 50, height: 50)
//                .foregroundColor(Color.subColor)
//                .background(Color.subColor)
                .foregroundColor(colorScheme == .dark ? Color.black : Color.subColor)
                .background(colorScheme == .dark ? Color.black : Color.subColor)
            
                .clipShape(Circle())
            
                .overlay(Circle()
                            .stroke( Color.subColor, lineWidth: 3))
            
            SystemImage("plus")
                .frame(width: 25, height: 25)
//                .foregroundColor(Color.black)
                .foregroundColor(colorScheme == .dark ? Color.subColor : Color.black)
        }
    }
}





