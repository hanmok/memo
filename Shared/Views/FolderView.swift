//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

struct FolderView: View {
    @State var memoSelected = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    
    var folder: Folder
    
    @AppStorage("hasCollapsed") var hasCollapsed = false
    
    @State var searchKeyword = ""
    func plusButtonPressed() {
        
    }
    func search() {
        
    }
    
    func editFolder() {
        
    }
    
    func getSubfolderListSize(_ input: Folder)-> CGFloat {
        if let numOfSubfolders = input.subFolders?.count {
            let maxCount = min(5, numOfSubfolders)
            return CGFloat(maxCount * 36)
        }
        return 36
    }
    
    var subfolders: [Folder]? {
        //        return folder.subFolders
        if let validSubFolders = folder.subFolders {
            return validSubFolders
        } else {
            return nil
        }
    }
    
//    func navigateBack() { }
    
    var body: some View {

        VStack { // make subfolders attached to NavigationBar
            
//            SubFolderList(folder: folder)
//            CollapsibleFolderList(folder: folder)
//
//            MemoList(folder: folder)
//                .padding(.horizontal, Sizes.overallPadding)
            
            CollapsibleFolderList(hasCollapsed: hasCollapsed, folder: folder)
//                .padding(.horizontal, Sizes.overallPadding)
//            Spacer()
        } // end of main VStack
//        .searchable(text: $searchKeyword)
        .navigationBarTitle(folder.title)
        .onAppear(perform: {
            print("FolderView has appeared, folder: \(folder)")
        })
        
        // MainTabBar, + Icon to add memos
        .overlay {
            VStack {
                Spacer()
                // + Icon
                HStack {
                    Spacer()
                    
                    if !memoSelected {
                        Button(action: plusButtonPressed) {
                            PlusImage()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                        }
                    } else {
                        MemosToolBarView()
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                    }
                }
            }
        }
//        .background(.clear)
//        .background(Color(.sRGB, white: 255.0/242.0, opacity: 0))
    }
}


// Folder Name with.. a little Space
struct FolderView_Previews: PreviewProvider {
    
    //
    
    static var previews: some View {
        //        FolderView(folder: folder8, title: "My Folder Name", color: Color(UIColor(red: 0, green: 0, blue: 255, alpha: 0.6)), numOfSubfolders: 3)
        //        FolderView(folder: folder8, title: "My Folder Name", color: Color(UIColor(red: 0, green: 0, blue: 255, alpha: 0.6)))
        FolderView(folder: folder8)
        
    }
}



