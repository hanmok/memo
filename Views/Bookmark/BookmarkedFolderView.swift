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
    
    @EnvironmentObject var trashBinVM: TrashBinViewModel
    
    @ObservedObject var folder: Folder
    
    @State var isPresentingMemoView = false
    @State var isPresentingNewMemoView = false
    
    var body: some View {
        print("hasSafeBottom: \(UIScreen.hasSafeBottom)")
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
                                                        MemoView(memo: bookMarkedMemo, parent: bookMarkedMemo.folder!, presentingView: $isPresentingMemoView, calledFromMainView: true )
                                                        .environmentObject(trashBinVM)
                                        ) {
                                            BookmarkedMemoBoxView(memo: bookMarkedMemo)
                                        }
                                    }
                                } // end of HStack
                                .padding(.horizontal, Sizes.properSpacing)
                            }
                        } // end of ScrollView
                        .frame(height: UIScreen.hasSafeBottom ? 150 : 125)
                        .padding(.top, 10)
                        
                        Spacer()
                    } // end of VStack
                    
                    // Another ZStack Element
                    // NEW MEMO
                    NavigationLink(destination:
                                    NewMemoView(parent: folder, presentingNewMemo: $isPresentingNewMemoView)
                                    .environmentObject(trashBinVM)
                                   ,isActive: $isPresentingNewMemoView) {}
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
                            .offset(y: UIScreen.hasSafeBottom ? -20 : -15)
                        
                        HStack {
                            HStack {
                                Text(Image(systemName: "bookmark.fill")) + Text(" BookMarked Memos")
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.blackAndWhite)
                            .offset(y: isPresentingMemoView || isPresentingNewMemoView ? -100 : UIScreen.hasSafeBottom ? -20 : -15)
                            .animation(.spring(response: 0.2), value: isPresentingMemoView || isPresentingNewMemoView)
                            
                            Spacer()
                            
                            // Adding New Memo Button
                            Button {
                                isPresentingNewMemoView = true
                            } label:
                            {
                                PlusImage() // plus Image with subColor
                            }

                            .offset(y: isPresentingMemoView || isPresentingNewMemoView ? -100 : UIScreen.hasSafeBottom ? -35: -30 ) // priv : -25
                            .animation(.spring(response: 0.2), value: isPresentingMemoView || isPresentingNewMemoView)
                        }
                        .padding(.horizontal, Sizes.overallPadding)
                    } // end of ZStack
                }
                .padding(.horizontal, Sizes.overallPadding)
                .offset(y: isPresentingMemoView || isPresentingNewMemoView ? -100 : -20) // remove top bar when new Memo Presented.
                Spacer()
            }
        } // end of ZStack
        .offset(y: (isPresentingMemoView || isPresentingNewMemoView) ? 0 : (UIScreen.hasSafeBottom ? UIScreen.screenHeight - 250 : UIScreen.screenHeight - 170  ))
        .animation(.spring(response: 0.1), value: isPresentingMemoView || isPresentingNewMemoView)
    }
}
