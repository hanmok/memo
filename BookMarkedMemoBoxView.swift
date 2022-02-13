//
//  BookMarkedMemoBoxView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/09.
//

import SwiftUI

class OneMemoViewModel: ObservableObject {
    @Published var memo: Memo
    
    init(memo: Memo) {
        self.memo = memo
    }
}

struct BookMarkedMemoBoxView: View {
    
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
    
//    var frameSize = UIScreen.screenWidth / 2 - 1.5 * Sizes.overallPadding
//    var frameSize = (UIScreen.screenWidth - Sizes.smallSpacing) / 2 - 1.5 * Sizes.overallPadding
    var frameSize = (UIScreen.screenWidth - Sizes.overallPadding) / 2 - 2 * Sizes.smallSpacing
        
    
    // If both overview exist, contents doesn't show up
    // if overview doesn't only title and contents show up
    
    var body: some View {
        VStack(alignment: .leading) {
            if title != nil {
                Text(memo.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
//                    .frame(maxWidth: .infinity, alignment: .leading)
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
//                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .frame(width: frameSize, alignment: .leading)
                        .padding([.leading, .bottom], 5 )
                }
            }
        }
        .tint(colorScheme == .dark ? Color(white: 228 / 255) : Color(white: 1))
//        .frame(width: UIScreen.screenWidth  - 2 * Sizes.overallPadding)
        .background(colorScheme == .dark ? Color(white: 33 / 255) : Color(white: 0.9))
        .cornerRadius(5)
    }
}
