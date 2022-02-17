//
//  MemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import SwiftUI

// used only to show.
struct ModifiedMemoBoxView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    
    @ObservedObject var memo: Memo
    
    // must have title.
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
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
            
            if contents != nil {
                Text(contents!)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .bottom], 5 )
            }
        }
        .tint(colorScheme == .dark ? Color(white: 228 / 255) : Color(white: 1))
        .padding(.horizontal, Sizes.smallSpacing)
        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
        .background(Color(.sRGB, red: 242 / 255, green: 206 / 255, blue: 128 / 255))
//        .background(Color(.sRGB, white: 0.5, opacity: 0.1))
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(memoEditVM.selectedMemos.contains(memo) ? Color(UIColor(named: "mainColor")!) : .clear, lineWidth: 2)
        )
    }
}
