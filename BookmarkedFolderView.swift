//
//  BookmarkedFolderView.swift
//  DeeepMemo
//
//  Created by 이한목 on 2022/02/13.
//

import SwiftUI
import CoreData

struct BookmarkedFolderView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var memoEditVM: MemoEditViewModel
    @EnvironmentObject var folderEditVM: FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
    
    // 160 for bookMark, UIScreen.screenHeight for MemoView
    @State var height: CGFloat = 160
    
    @ObservedObject var folder: Folder
    
    
    var body: some View {
        VStack {
            HStack {
                Text(folder.title)
                    .foregroundColor(colorScheme.adjustBlackAndWhite())
                    
                Spacer()
                Button {
                    print("fetchedMemos: \(folder.memos.count)")
                    for each in folder.memos.sorted() {
                        print(each.title)
                    }
                } label:
                {
                    PlusImage()
                }

                    .padding(.trailing, Sizes.overallPadding)
                    .offset(y: -25)
            }
            .padding(.leading, Sizes.overallPadding)
            
            ScrollView(.horizontal) {
                HStack(spacing: Sizes.smallSpacing) {
                    
                    ForEach(Folder.returnContainedMemos(folder: folder, onlyMarked: true), id: \.self) {bookMarkedMemo in
                        
                        BookMarkedMemoBoxView(memo: bookMarkedMemo)
                            .padding(.top, 0)

                    }
                }
            }
            .padding(.leading, Sizes.overallPadding)
            
            Spacer()
        }
        // when it applied, it occupy all screen
        .frame(height: height)
//        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .background(colorScheme.adjustSubColors())
    }
}
