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
    @State var isSelected = false
    
    var title: String? {
        if memo.title != "" {
            return memo.title
        }
        return nil // empty Title
    }
    
    var contents: String? {
        if memo.contents != "" {
            return memo.contents
        }
        return nil // empty contents
    }
    
    var frameSize = (UIScreen.screenWidth - Sizes.overallPadding) / 2 - 2 * Sizes.smallSpacing
        
    var body: some View {
        VStack(alignment: .leading) {
            if title != nil {
                Text(memo.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(width: frameSize, alignment: .leading)
                    .padding(5)
            }
            
            if memo.overview != "" { // not using overview yet.
                Text(memo.overview)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .frame(width: frameSize, alignment: .leading)
                    .padding(.leading, 5)
            } else {
                if memo.contents != "" {
                    Text(memo.contents)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .frame(width: frameSize, alignment: .leading)
                        .padding([.leading, .bottom], 5)
                }
            }
        }
        .tint(colorScheme == .dark ? Color(white: 228 / 255) : Color(white: 1))
        .background(colorScheme == .dark ? Color(white: 33 / 255) : Color(white: 0.9))
        .cornerRadius(5)
    }
}
