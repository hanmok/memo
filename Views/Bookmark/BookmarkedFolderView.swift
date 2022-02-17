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
    @State var presentingNewMemo = false
    
    var body: some View {
        
        return ZStack {
            NavigationView {
                ZStack(alignment: .topLeading) {
                    
                    // BOOKMARK Memos
                    VStack(spacing: 0) {
                        ScrollView(.horizontal) {
                            VStack {
                                HStack(alignment: .top, spacing: Sizes.properSpacing) {
                                    
                                    ForEach(Folder.returnContainedMemos(folder: folder, onlyMarked: true), id: \.self) {bookMarkedMemo in
                                        
                                        NavigationLink(destination:
//                                                        BookmarkMemoView(memo: bookMarkedMemo,
//                                                                         parent: bookMarkedMemo.folder!,
//                                                                         presentingView: $presentingView)
                                                       
                                                       ModifiedBookmarkMemoView(memo: bookMarkedMemo,
                                                                        parent: bookMarkedMemo.folder!,
                                                                        presentingView: $presentingView)
                                                       
                                                        .environmentObject(memoEditVM)
                                                        .environmentObject(folderEditVM)
                                        ) {
                                            BookmarkedMemoBoxView(memo: bookMarkedMemo)
//                                            ModifiedMemoBoxView(memo: bookMarkedMemo)
//                                            ModifiedBookmarkMemoView(memo: bookMarkedMemo)
                                        }
                                    }
                                } // end of HStack
                                .padding(.horizontal, Sizes.properSpacing)
                                Spacer()
                            }
                        } // end of ScrollView
                        .frame(height: 150)
                        .padding(.top, 10) // prev: 30
                        
                        Spacer()
                    } // end of VStack
//                    .background(Color(UIColor(named: "mainColor")!))
//                    .background(Color.applyMainColor())
                    .background(colorScheme.adjustMainColors())
//                    .padding(.horizontal, Sizes.overallPadding)
                    // Another ZStack Element
                    // NEW MEMO
                    NavigationLink(destination:
//                                    NewMemoView(parent: folder, presentingNewMemo: $presentingNewMemo)
                                   ModifiedNewMemoView(parent: folder, presentingNewMemo: $presentingNewMemo)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                                   ,isActive: $presentingNewMemo) {}
                }
                .navigationBarHidden(true)
            } // end of NavigationView, Another ZStack Element begins
            .padding(.horizontal, Sizes.overallPadding)
            //            .navigationBarHidden(true)
            VStack {
                HStack {
                    ZStack {
                        // BookMarked memos Text.
                        Rectangle()
                            .frame(width: UIScreen.screenWidth, height: 30)
//                            .background(Color(UIColor(named: "subColor")!))
//                            .foregroundColor(Color(UIColor(named: "subColor")!))
                            .background(colorScheme.adjustSecondSubColors())
                            .foregroundColor(colorScheme.adjustSecondSubColors())
                            .offset(y: -20)
                        
                        HStack {
                            HStack {
                                Text(Image(systemName: "bookmark.fill")) + Text(" BookMarked Memos")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(colorScheme.adjustBlackAndWhite())
                            .offset(y: presentingView || presentingNewMemo ? -100 : -20 )
                            .animation(.spring(response: 0.2), value: presentingView || presentingNewMemo)
                            
                            Spacer()
                            
                            // Adding New Memo Button
                            Button {
                                presentingNewMemo = true
                            } label:
                            {
                                PlusImage2() // plus Image with subColor
                            }
//                            .padding(.trailing, Sizes.overallPadding)
                            .offset(y: presentingView || presentingNewMemo ? -100 : -35 ) // priv : -25
                            .animation(.spring(response: 0.2), value: presentingView || presentingNewMemo)
                        }
                        .padding(.horizontal, Sizes.overallPadding)
                    } // end of ZStack
                }
                .padding(.horizontal, Sizes.overallPadding)
//                .background(Color(.sRGB, white: 0, opacity: 0.5))
                .offset(y: presentingView || presentingNewMemo ? -100 : -20) // remove top bar when new Memo Presented.
                Spacer()
            }
        } // end of ZStack
        .offset(y: presentingView || presentingNewMemo ? 0 : UIScreen.screenHeight - 250)
        .animation(.spring(response: 0.1), value: presentingView || presentingNewMemo)
        //        .ignoresSafeArea( edges: .horizontal)
    }
}
