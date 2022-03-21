//
//  BookMarkedMemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/09.
//

import SwiftUI

struct PinnedMemoBoxView: View {
    
    @ObservedObject var memo: Memo
    
    @Environment(\.colorScheme) var colorScheme
    
    var frameSize = ( UIScreen.screenWidth - 6 * Sizes.properSpacing ) / 2
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            if memo.titleToShow != "" {
                Text(memo.titleToShow)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blackAndWhite)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(width: frameSize, alignment: .leading)
                    .padding(.horizontal, Sizes.smallSpacing)
                    .padding(.top, 5)
            }
            
            if memo.contentsToShow != "" {
                Text(memo.contentsToShow)
                    .font(.caption)
                    .foregroundColor(Color.blackAndWhite)
                    .multilineTextAlignment(.leading)
                    .frame(width: frameSize, alignment: .leading)
                    .padding(.horizontal, Sizes.smallSpacing)
                    .padding(.bottom, 5)
            }
            Spacer()
        }
        .tint(Color.black)
        .background(Color.memoBoxColor)
        .cornerRadius(7)
    }
}

