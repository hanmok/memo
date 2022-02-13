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
    @State var height: CGFloat = 160 {
        willSet {
            print("height newValue in BookmarkedFolderView: \(newValue)")
            if newValue == UIScreen.screenHeight {
                UIView.setAnimationsEnabled(false)
            } else {
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    @State var newMemoPressed = false
    
    @ObservedObject var folder: Folder
    
    // first Test
    var body: some View {
        
        return ZStack {
            NavigationView {
                ZStack {
                    VStack {
                        HStack {
//                            Text(Image(systemName: "bookmark")) + Text(" BookMarked Folders")
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(colorScheme.adjustBlackAndWhite())
                        .padding(.leading, Sizes.overallPadding)
                        .padding(.vertical)
//                        .offset(y: -25)
                        
                        ScrollView(.horizontal) {
                            HStack(alignment: .top, spacing: Sizes.smallSpacing) {
                                
                                ForEach(Folder.returnContainedMemos(folder: folder, onlyMarked: true), id: \.self) {bookMarkedMemo in
                                    
                                    NavigationLink(
                                        destination: SpecialMemoView(memo: bookMarkedMemo, passedHeight: $height, parent: bookMarkedMemo.folder!, initialTitle: bookMarkedMemo.title, isNewMemo: false)) {
                                        BookMarkedMemoBoxView(memo: bookMarkedMemo)
                                            .padding(.top, 0)
                                    }
                                }
                            }
                            .padding(.horizontal, Sizes.overallPadding)
                        }
                        Spacer()
                    }
                    .background(colorScheme.adjustSubColors())
                    
                    
                    NavigationLink(destination:
                                    SpecialMemoView(
                                        memo: Memo(title: "", contents: "", context: context),
                                        passedHeight: $height,
                                        parent: folder,
                                        initialTitle: "Enter Title" ,
                                        isNewMemo: true),
                                   isActive: $newMemoPressed) {}
                }        .navigationBarHidden(true)
            } // end of NavigationView
            VStack {
                HStack {
                    
                    HStack {
                        Text(Image(systemName: "bookmark.fill")) + Text(" BookMarked Memos")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(colorScheme.adjustBlackAndWhite())
                    .padding(.leading, Sizes.overallPadding)
//                    .padding(.vertical)
                    .offset(y: height == 160 ? -40 : -100)
                    
                    Spacer()
                    
                    
                    
                    Button {
                        height = UIScreen.screenHeight
                        newMemoPressed = true
                    } label:
                    {
                        PlusImage2()
                    }
                    .padding(.trailing, Sizes.overallPadding)
                    .offset(y: height == 160 ? -25 : -100)
                }
                Spacer()
            }
            
        } // end of ZStack
        
        .frame(height: height)
        .background(.red)
        
    }
}
