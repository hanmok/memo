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
//    @ObservedObject var trashBinFolder: Folder
    @State var newMemoPressed = false
    @State var presentingView = false
    @ObservedObject var folder: Folder
    @State var presentingNewMemo = false
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    var hasSafeBottom: Bool
    
    var body: some View {
        print("hasSafeBottom: \(hasSafeBottom)")
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
                                                        MemoView(memo: bookMarkedMemo, parent: bookMarkedMemo.folder!, presentingView: $presentingView )
                                                       
                                                        .environmentObject(memoEditVM)
                                                        .environmentObject(folderEditVM)
                                                        .environmentObject(trashBinVM)
                                        ) {
                                            BookmarkedMemoBoxView(memo: bookMarkedMemo)
                                        }
                                    }
                                } // end of HStack
                                .padding(.horizontal, Sizes.properSpacing)
//                                Spacer()
                            }
                        } // end of ScrollView
//                        .frame(height: 150)
                        .frame(height: hasSafeBottom ? 150 : 125)
                        .padding(.top, 10)
                        
                        Spacer()
                    } // end of VStack
                    
                    // Another ZStack Element
                    // NEW MEMO
                    NavigationLink(destination:
                                    NewMemoView(parent: folder, presentingNewMemo: $presentingNewMemo)
                                    .environmentObject(trashBinVM)
                                    .environmentObject(memoEditVM)
                                    .environmentObject(folderEditVM)
                                   ,isActive: $presentingNewMemo) {}
                }
                .navigationBarHidden(true)
            } // end of NavigationView, Another ZStack Element begins
            .padding(.horizontal, Sizes.overallPadding)
            VStack {
                HStack {
                    ZStack {
                        // BookMarked memos Text.
                        Rectangle()
                            .frame(width: UIScreen.screenWidth, height: 30)
                            .background(Color.bookmarkBarColor)
                            .foregroundColor(Color.bookmarkBarColor)
                            .offset(y: -20)
                        
                        HStack {
                            HStack {
                                Text(Image(systemName: "bookmark.fill")) + Text(" BookMarked Memos")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.blackAndWhite)
                            .offset(y: presentingView || presentingNewMemo ? -100 : -20 )
                            .animation(.spring(response: 0.2), value: presentingView || presentingNewMemo)
                            
                            Spacer()
                            
                            // Adding New Memo Button
                            Button {
                                presentingNewMemo = true
                            } label:
                            {
                                PlusImage() // plus Image with subColor
                            }

                            .offset(y: presentingView || presentingNewMemo ? -100 : -35 ) // priv : -25
                            .animation(.spring(response: 0.2), value: presentingView || presentingNewMemo)
                        }
                        .padding(.horizontal, Sizes.overallPadding)
                    } // end of ZStack
                }
                .padding(.horizontal, Sizes.overallPadding)
                .offset(y: presentingView || presentingNewMemo ? -100 : -20) // remove top bar when new Memo Presented.
                Spacer()
            }
        } // end of ZStack
        .offset(y: (presentingView || presentingNewMemo) ? 0 : (hasSafeBottom ? UIScreen.screenHeight - 250 : UIScreen.screenHeight - 170  ))
        .animation(.spring(response: 0.1), value: presentingView || presentingNewMemo)
    }
}
