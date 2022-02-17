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
    
    var title: String {
        if let firstIndex = memo.contents.firstIndex(of: "\n") {
            //            let index = memo.contents.distance(from: memo.contents.startIndex, to: firstIndex)
            //            let newIndex = memo.contents.index(memo.contents.startIndex, offsetBy: index)
            //            let title = memo.contents[..<newIndex]
            let title = memo.contents[..<firstIndex]
            return String(title)
        } else {
            return memo.contents
        }
    }
    
    var contents: String? {
        if let firstIndex = memo.contents.firstIndex(of: "\n") {
            //            let index = memo.contents.distance(from: memo.contents.startIndex, to: firstIndex)
            //            let newIndex = memo.contents.index(memo.contents.startIndex, offsetBy: index)
            let endIndex = memo.contents.endIndex
            
            //            let contents = memo.contents[newIndex ..< endIndex]
            let contents = memo.contents[firstIndex ..< endIndex]
            return String(contents)
        }
        return nil
    }
    
    
    var frameSize = ( UIScreen.screenWidth - 5 * Sizes.properSpacing ) / 2
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: frameSize, alignment: .leading)
                .padding(5)
            
            if contents != nil {
                Text(memo.contents)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(width: frameSize, alignment: .leading)
                    .padding([.leading, .bottom], 5)
            }
        }
        .tint(colorScheme == .dark ? Color(white: 228 / 255) : Color(white: 1))
        .background(colorScheme == .dark ? Color(white: 33 / 255) : Color(white: 0.9))
        
        .cornerRadius(5)
    }
}
