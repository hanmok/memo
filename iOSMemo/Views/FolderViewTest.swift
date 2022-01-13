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

struct FolderViewTest: View {

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
                    
                    // test Button
                    //                Button {
                    //                    let newFolder = Folder(title: "new Folder", context: context)
                    //                    currentFolder.add(subfolder: newFolder)
                    //                    context.saveCoreData()
                    //                    print("folder has added")
                    //                    currentFolder.getFolderInfo()
                    //                } label: {
                    //                    Text("add new SubFolder")
                    //                }
                    
//                    // test Button 2, print currentFolder's info
//                    Button {
//                        print(currentFolder.getFolderInfo())
//                    } label: {
//                        Text("print currentFolder Info")
//                    }
//
//                    // test Button 3, update subfolder's title
//                    Button {
//                        let updateFolder = subfolders.first!
//                        updateFolder.title = "updated title4"
//                        context.saveCoreData()
//                    } label: {
//                        Text("update first folder's name")
//                    }
//
//                    // test Button 4, update memo's title
//                    Button {
//                        let firstMemo = currentFolder.memos.first!
//                        firstMemo.title = "updated Memo Title22"
//
//                        context.saveCoreData()
//                    } label: {
//                        Text("update memo's title")
//                    }
                    
                    
                    
//                    SubFolderPageView(folder: currentFolder)
                    SubFolderPageView()
                        .environmentObject(currentFolder)
                        .background(.yellow)
                    
                   
                    MemoList(folder: currentFolder)
                    
                    
                } // end of main VStack
            }
            
            .navigationBarTitle(currentFolder.title)
//            .navigationBarItems(trailing: Button(action: pinThisFolder, label: {
//                ChangeableImage(imageSystemName: pinnedFolder ? "pin.fill" : "pin", width: 24, height: 24)
//            }))
            .onAppear {
                // appear after navigate to back
                // 하지만 update 안됨.. ??
                print("FolderView has appeared flag 2")
            }
            
        } // end of navigation View
        
        
        
        .onAppear(perform: {
            // folderView appears when initially launched
            print("FolderView has appeared, folder: \(currentFolder.title)")
        })
        .onChange(of: currentFolder, perform: { newValue in
            print("current Folder has changed")
        })
        
        // MainTabBar, + Icon to add memos
        .overlay {
            VStack {
                Spacer()
                // + Icon
                HStack {
                    Spacer()
                    
                    if !memoSelected {
                        

                        // test Button
//                        Button(action: {
//                            plusButtonPressed.toggle()
//                            let deleteMemo = currentFolder.memos.first!
//                            Memo.delete(deleteMemo)
////                            currentFolder.add(memo: newMemo)
////                            context.saveCoreData()
//                        }) {
//                            MinusImage()
//                                .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
//                        }
                        
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
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                    }
                }
            }
        }
    }
}


// Folder Name with.. a little Space
struct FolderViewTest_Previews: PreviewProvider {
    
    static var testFolder = Folder(title: "test Folder", context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        
        FolderView(currentFolder: testFolder)
    }
}
//




