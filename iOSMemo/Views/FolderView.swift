//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData

// FolderView should get a Valid Folder.
struct FolderView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    

    // this one maybe needed to homeView
//    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var folders: FetchedResults<Folder>
        
    let currentFolder : Folder
    
    @EnvironmentObject var nav: NavigationStateManager

    @State var memoSelected = false // use it to switch plus button into toolbar
    
//    @State var searchKeyword = "" // implement it later.
    @State var pinnedFolder: Bool = false
    
    @State var plusButtonPressed: Bool = false
    // if changed, present sheet
    
    
    func search() {
        
    }
    
    func pinThisFolder() {
        pinnedFolder.toggle()
    }
    
    func editFolder() {
        
    }
    
//    func getSubfolderListSize(_ input: Folder)-> CGFloat {
//        if let numOfSubfolders = input.subFolders?.count {
//            let maxCount = min(5, numOfSubfolders)
//            return CGFloat(maxCount * 36)
//        }
//        return 36
//    }
    
    var subfolders: [Folder] {
        var folders: [Folder] = []
        for eachFolder in currentFolder.subfolders {
            folders.append(eachFolder)
        }
        return folders
    }
    
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) { // make subfolders attached to NavigationBar
                
                //            CollapsibleFolderList(hasCollapsed: hasCollapsed, folder: folder)
                CollapsibleFolderList(folder: currentFolder) // need to change ..
                    .padding([.horizontal, .top], 10)
                SubFolderToolBarView()
                    .opacity(0.8)
                    .cornerRadius(10)
                    .padding(.horizontal, Sizes.overallPadding)
                // um.. this is wrong..
                MemoList(folder: currentFolder, selectedMemo: $nav.selectedMemo)
                    .padding(.horizontal, Sizes.overallPadding)
                    .background(.green)
            } // end of main VStack
        }
        .navigationBarTitle(currentFolder.title)
        .navigationBarItems(trailing: Button(action: pinThisFolder, label: {
            ChangeableImage(imageSystemName: pinnedFolder ? "pin.fill" : "pin", width: 24, height: 24)
        }))
        .onAppear(perform: {
            print("FolderView has appeared, folder: \(currentFolder.title)")
        })
        .sheet(isPresented: $plusButtonPressed, content: {
                MemoView(memo: Memo(title: "", context: context))
        })
        
        // MainTabBar, + Icon to add memos
        .overlay {
            VStack {
                Spacer()
                // + Icon
                HStack {
                    Spacer()
                    
                    if !memoSelected {
                        Button(action: {
                            plusButtonPressed.toggle()
                        }) {
                            PlusImage()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                        }
                    } else { // if some memos are selected
                        MemosToolBarView()
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                    }
                }
            }
        }
    }
}


// Folder Name with.. a little Space
//struct FolderView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        FolderView(folder: folder8)
//    }
//}
//




