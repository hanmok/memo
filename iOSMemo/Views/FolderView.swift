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
    @StateObject var selectedViewModel = SelectedMemoViewModel()
    @State var shouldAddSubFolder = false
    @State var shouldHideSubFolders = false
    
    @State var newSubFolderName = ""
    @State var isAddingMemo = false
    //    @State var shouldHideSubFolders = false
    
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
//                ScrollView(
//                GeometryReader { proxy in
                VStack {
                    // how to know size of this view ??
//                    if !shouldHideSubFolders {
                        SubFolderPageView(
                            shouldAddSubFolder: $shouldAddSubFolder,
                            shouldHideSubFolderView: $shouldHideSubFolders
                        )
//                            .environmentObject(currentFolder)
                    
                        MemoList(isAddingMemo: $isAddingMemo)
//                            .environmentObject(currentFolder)
                            .environmentObject(selectedViewModel)
                    } // end of main VStack
                .environmentObject(currentFolder)
                // current folder to both SubFolderPageView, MemoList

            } // end of ScrollView
            VStack {
                Spacer()
//                Spacer()
                HStack {
                    Spacer()
                    if selectedViewModel.count == 0 {
                        // show plus button
                        Button(action: {
                            isAddingMemo = true
                            // navigate to MemoView
                        }) {
                            PlusImage()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                        }
                    } else {
                        // Do handler actions here
                        MemosToolBarView(pinnedAction: { selMemos in
                            // TODO : if all is pinned -> unpin
                            // else : pin all
                            
                            var allPinned = true
                            for each in selMemos {
                                if each.pinned == false {
                                    allPinned = false
                                    break
                                }
                            }
                            
                            if !allPinned {
                                for each in selMemos {
                                    each.pinned = true
                                }
                            }
                            context.saveCoreData()
                            
                        }, cutAction: { selMemos in
                            
                            
                        }, copyAction: { selMemos in
                            // TODO : .sheet(FolderMindMap)
                            
                        }, changeColorAcion: {selMemos in
                            // Change backgroundColor
                            for eachMemo in selMemos {
                                //                                    eachMemo.bgColor = bgColor
                            }
                        }, removeAction: { selMemos in
                            for eachMemo in selMemos {
                                selectedViewModel.memos.remove(eachMemo)
                                Memo.delete(eachMemo)
                            }
                            context.saveCoreData()
                        })
                            .padding([.trailing], Sizes.largePadding)
                            .padding(.bottom,Sizes.overallPadding )
                    }
                } // end of HStack
            } // end of VStack
            
            // When add folder pressed
            // overlay white background when Alert show up
            if shouldAddSubFolder {
                Color(.white)
                    .opacity(0.8)
            }
            
            // When add folder pressed
            // Present TextFieldAlert
            TextFieldAlert(
                isPresented: $shouldAddSubFolder,
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
        } // end of ZStack
        .frame(maxHeight: .infinity)
        .navigationTitle(currentFolder.title)
        .navigationBarItems(trailing:Button(action: {
            print("subfolder Info: \n \(currentFolder.subfolders)")
            print("memos Info: \n \(currentFolder.memos)")
        }, label: {
            ChangeableImage(imageSystemName: "magnifyingglass")
        }))
        
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




