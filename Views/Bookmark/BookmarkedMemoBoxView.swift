//
//  BookMarkedMemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/09.
//

import SwiftUI

struct BookmarkedMemoBoxView: View {
    
    @ObservedObject var memo: Memo
    @Environment(\.colorScheme) var colorScheme
    
    var frameSize = ( UIScreen.screenWidth - 5 * Sizes.properSpacing ) / 2
    
    var body: some View {
        VStack(alignment: .leading) {
            if memo.titleToShow != "" {
                Text(memo.titleToShow)
                    .font(.headline)
                    .fontWeight(.bold)
//                    .foregroundColor(.primary)
                    .foregroundColor(colorScheme.adjustInverseBlackAndWhite())
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(width: frameSize, alignment: .leading)
                    .padding(5)
            }
            
            if memo.contentsToShow != "" {
                Text(memo.contentsToShow)
                    .font(.caption)
//                    .foregroundColor(.primary)
                    .foregroundColor(colorScheme.adjustInverseBlackAndWhite())
                    .multilineTextAlignment(.leading)
                    .frame(width: frameSize, alignment: .leading)
                    .padding([.leading, .bottom], 5)
            }
        }
//        .tint(colorScheme == .dark ? Color(white: 228 / 255) : Color(white: 1))
        .tint(colorScheme.adjustInverseBlackAndWhite())
        //        .background(colorScheme == .dark ? Color(white: 33 / 255) : Color(white: 0.9))
//        .background(Color.pastelColors[memo.colorIndex])
        .background(colorScheme.adjustMainColors())
        .cornerRadius(10)
    }
}

