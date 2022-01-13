//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData
// navigation 이 안되면, test 가 거의.. 불가능해짐.. 왜 안될까 ??
// FolderView should get a Valid Folder.

struct FolderView: View {

    @State var testToggler = false
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    //    @EnvironmentObject var nav: NavigationStateManager
    
    // get nav.selectedFolder from HomeView
    // updated.
    @ObservedObject var currentFolder: Folder
    
    var selectedMemos: [Memo]? // handle checked memos according to MemoToolBarView's action
    
    
    
    // use it to switch plus button into toolbar
    @State var memoSelected = false
//    @State var pinnedFolder: Bool = false
    @State var plusButtonPressed: Bool = false
    // if changed, present sheet
    
    func search() {
        
    }
    
//    func pinThisFolder() {
//        pinnedFolder.toggle()
//    }
    
    func editFolder() {
        
    }
    
    var subfolders: [Folder] {
        var folders: [Folder] = []
        for eachFolder in currentFolder.subfolders {
            folders.append(eachFolder)
        }
        folders.sort()
        return folders
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
//                    SubFolderPageView(folder: currentFolder)
                    SubFolderPageView()
                        .environmentObject(currentFolder)
                        .background(.yellow)
                    
                    MemoList(folder: currentFolder)
                    
                } // end of main VStack
            }
            
            .navigationBarTitle(currentFolder.title)
        } // end of navigation View
        
        // MainTabBar, + Icon to add memos
        .overlay {
            VStack {
                Spacer()
                // + Icon
                HStack {
                    Spacer()
                    
                    if !memoSelected {
                        // plus button
                        Button(action: {
                            plusButtonPressed.toggle()
                            let newMemo = Memo(title: "new memo", contents: "new contents", context: context)
                            currentFolder.add(memo: newMemo)
                            context.saveCoreData()
                        }) {
                            PlusImage()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                        }
                    } else { // if some memos are selected
                        MemosToolBarView()
                            .padding([.trailing], Sizes.largePadding)
                            .padding(.bottom,Sizes.overallPadding )
                    }
                }
            }
        }
    }
}


// Folder Name with.. a little Space
struct FolderView_Previews: PreviewProvider {
    
    static var testFolder = Folder(title: "test Folder", context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        
        FolderView(currentFolder: testFolder)
    }
}
//




