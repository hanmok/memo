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

    @State var isAddingSubfolder = false
    @State var newSubFolderName = ""
    @State var isAddingMemo = false
//    @EnvironmentObject var nav: NavigationStateManager
    
//    @State var testToggler = false
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    //    @EnvironmentObject var nav: NavigationStateManager
    
    @ObservedObject var currentFolder: Folder
    
//    var testMemos: [Memo] {
//        return currentFolder.memos.sorted()
//    }
    
//    var memoColumns: [GridItem] {
//        [GridItem(.flexible(minimum: 150, maximum: 200)),
//         GridItem(.flexible(minimum: 150, maximum: 200))
//        ]
//    }
    
    
    // use it to switch plus button into toolbar
//    @State var memoSelected = false
//    @State var plusButtonPressed: Bool = false
    // if changed, present sheet
    
    func search() {
        
    }
    
    func editFolder() {
        
    }
    
    var body: some View {
//        NavigationView {
            ZStack {
                ScrollView(.vertical) {
                    VStack {
                        SubFolderPageView(shouldAddSubFolder: $isAddingSubfolder)
                            .environmentObject(currentFolder)
//                            .background(.yellow)
                        
                        MemoList(isAddingMemo: $isAddingMemo)
                            .environmentObject(currentFolder)
                    } // end of main VStack
                    .frame(maxHeight: .infinity)
                } // end of ScrollView
                
                // overlay white background when Alert show up
                if isAddingSubfolder {
                    Color(.white)
                        .opacity(0.8)
                }
                
                // When add folder pressed
                TextFieldAlert(
                    isPresented: $isAddingSubfolder,
                    text: $newSubFolderName) { subfolderName in
                        currentFolder.add(
                            subfolder: Folder(title: newSubFolderName, context: context)
                        )
                        // setup initial name empty
                        newSubFolderName = ""
                    }
                
//                NavigationLink(isActive: $isAddingMemo, destination: MemoView(memo: Memo(title: "", contents: "", context: context) , parent: currentFolder), label: Text(""))
                
                // add new memo
                // MemoView need to know whether it's new or not.
                NavigationLink(destination: MemoView(memo: Memo(title: "", contents: " ", context: context), parent: currentFolder, isNewMemo: true), isActive: $isAddingMemo) {}
                
//            } // end of navigation View
//            .navigationBarTitle(currentFolder.title)
//            .navigationBarItems(trailing:Button(action: {
//            }, label: {
//                ChangeableImage(imageSystemName: "magnifyingglass")
//            }))
        }
            
//        } // end of navigation View
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




