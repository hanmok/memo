//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI

struct FolderView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

//    @AppStorage("hasCollapsed") var hasCollapsed = false

    @State var memoSelected = false
    @State var searchKeyword = ""
    @State var pinnedFolder: Bool = false
    var folder: Folder
    
    

    func plusButtonPressed() {
        
    }
    func search() {
        
    }
    
    func pinThisFolder() {
        pinnedFolder.toggle()
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

        VStack(spacing: 0) { // make subfolders attached to NavigationBar
            
//            CollapsibleFolderList(hasCollapsed: hasCollapsed, folder: folder)
            CollapsibleFolderList(folder: folder) // 왜.. 얘는...
                .padding()
            SubFolderToolBarView()
                .opacity(0.8)
                .cornerRadius(10)
                .padding(.horizontal, Sizes.overallPadding)
            // um.. this is wrong..
            MemoList(folder: folder)
                .padding(.horizontal, Sizes.overallPadding)
                .background(.green)
//            Spacer()
        } // end of main VStack

        .navigationBarTitle(folder.title)
        .navigationBarItems(trailing: Button(action: pinThisFolder, label: {
            ChangeableImage(imageSystemName: pinnedFolder ? "pin.fill" : "pin", width: 24, height: 24)
        }))
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
    }
}


// Folder Name with.. a little Space
struct FolderView_Previews: PreviewProvider {
    
    static var previews: some View {
        FolderView(folder: folder8)
    }
}



