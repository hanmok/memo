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
                                            SpecialMemoView(
                                                memo: bookMarkedMemo, presentingView: $presentingView,
                                                passedHeight: $height, parent: bookMarkedMemo.folder!,
                                                initialTitle: bookMarkedMemo.title, isNewMemo: false)) {
                                        BookMarkedMemoBoxView(memo: bookMarkedMemo)
                                            .padding(.top, 0)
                                    }
                                }
                            } // end of HStack
                            .padding(.horizontal, Sizes.overallPadding)
//                            .background(.orange)
                            Spacer()
                            }
                        }
                        .frame(height: 150)
//                        .background(.blue)
                        .padding(.top, 30)

                        Spacer()
                    } // end of VStack
                    .background(colorScheme.adjustSubColors())
                    
                    
                    NavigationLink(destination:
                                    SpecialMemoView(
                                        memo: Memo(title: "", contents: "", context: context),
                                        presentingView: $presentingView, passedHeight: $height,
                                        parent: folder,
                                        initialTitle: "Enter Title" ,
                                        isNewMemo: true),
                                   isActive: $newMemoPressed) {}
                }
                .navigationBarHidden(true)
            } // end of NavigationView
            .navigationBarHidden(true)
//            .ignoresSafeArea()
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
//                    .offset(y: height == 160 ? -40 : -100)
                    .offset(y: presentingView ? -100 : -40 )
                    //                    .offset(y: -40)

                    
                    Spacer()
                    
                    
                    
                    Button {
                        height = UIScreen.screenHeight
                        newMemoPressed = true
                    } label:
                    {
                        PlusImage2()
                    }
                    .padding(.trailing, Sizes.overallPadding)
//                    .offset(y: height == 160 ? -25 : -100)
                    .offset(y: presentingView ? -100 : -25 )
//                    .offset(y: -25)
                }
                Spacer()
            }
            
        } // end of ZStack
//        .offset(y: presentingView ? 0 : UIScreen.screenHeight - 300)
        .offset(y: presentingView ? 0 : UIScreen.screenHeight - 250)
        .animation(.spring(), value: presentingView)
//        .background(.red)
        
    }
}
