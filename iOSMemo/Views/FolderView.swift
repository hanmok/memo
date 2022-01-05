//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData

struct FolderView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    // need all the Folders for home View .
    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var folders: FetchedResults<Folder>
    
    // should it be not optional.. ?? if then homeFolder should be provided.
    
    @ObservedObject var selectedFolder: Folder
    
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
    
//    func getSubfolderListSize(_ input: Folder)-> CGFloat {
//        if let numOfSubfolders = input.subFolders?.count {
//            let maxCount = min(5, numOfSubfolders)
//            return CGFloat(maxCount * 36)
//        }
//        return 36
//    }
    
    var subfolders: [Folder] {
        var folders: [Folder] = []
        for eachFolder in folder.subfolders {
            folders.append(eachFolder)
        }
        return folders
    }
    
//    func navigateBack() { }
    
    var body: some View {

        VStack(spacing: 0) { // make subfolders attached to NavigationBar
            
//            CollapsibleFolderList(hasCollapsed: hasCollapsed, folder: folder)
            CollapsibleFolderList(folder: folder) // 왜.. 얘는...
                .padding([.horizontal, .top], 10)
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
//struct FolderView_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        FolderView(folder: folder8)
//    }
//}
//




