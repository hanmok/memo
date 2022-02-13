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
    
    @State var newMemoPressed = false
    @State var presentingView = false
    @ObservedObject var folder: Folder
    
    // first Test
    var body: some View {
        
        return ZStack {
            NavigationView {
                ZStack {
                    VStack(spacing: 0) {
                        ScrollView(.horizontal) {
                            
                            VStack {
                            HStack(alignment: .top, spacing: Sizes.smallSpacing) {
                                
                                ForEach(Folder.returnContainedMemos(folder: folder, onlyMarked: true), id: \.self) {bookMarkedMemo in
                                    
                                    NavigationLink(
                                        destination:
                                            BookmarkMemoView(
                                                memo: bookMarkedMemo, presentingView: $presentingView,
                                                parent: bookMarkedMemo.folder!,
                                                initialTitle: bookMarkedMemo.title, isNewMemo: false)) {
                                        BookmarkedMemoBoxView(memo: bookMarkedMemo)
                                            .padding(.top, 0)
                                    }
                                }
                            } // end of HStack
                            .padding(.horizontal, Sizes.overallPadding)
                            Spacer()
                            }
                        }
                        .frame(height: 150)
                        .padding(.top, 30)

                        Spacer()
                    } // end of VStack
                    .background(colorScheme.adjustSubColors())
                    
                    
                    NavigationLink(destination:
                                    BookmarkMemoView(
                                        memo: Memo(title: "", contents: "", context: context),
                                        presentingView: $presentingView,
                                        parent: folder,
                                        initialTitle: "Enter Title" ,
                                        isNewMemo: true),
                                   isActive: $newMemoPressed) {}
                }
                .navigationBarHidden(true)
            } // end of NavigationView
            .navigationBarHidden(true)
            VStack {
                HStack {
                    
                    HStack {
                        Text(Image(systemName: "bookmark.fill")) + Text(" BookMarked Memos")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(colorScheme.adjustBlackAndWhite())
                    .padding(.leading, Sizes.overallPadding)
                    .offset(y: presentingView ? -100 : -45 )
                    
                    
                    Spacer()
                    
                    Button {
                        newMemoPressed = true
                    } label:
                    {
                        PlusImage2()
                    }
                    .padding(.trailing, Sizes.overallPadding)
                    .offset(y: presentingView ? -100 : -25 )
                }
                Spacer()
            }
            
        } // end of ZStack
        .offset(y: presentingView ? 0 : UIScreen.screenHeight - 250)
        .animation(.spring(), value: presentingView)
    }
}
