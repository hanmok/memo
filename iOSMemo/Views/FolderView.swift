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
                            .environmentObject(currentFolder)
                        //                            .offset(x: shouldHideSubFolders ? UIScreen.screenSize.width : 0)
//                            .animation(.spring().speed(2), value: !shouldHideSubFolders)
//                        }
                           
                        

                        MemoList(isAddingMemo: $isAddingMemo)
                            .environmentObject(currentFolder)
//                            .scaledToFill()
//                            .background(.green)
//                            .scaledToFit()
//                            .background(.green)
//                            .frame(maxHeight: .infinity)
//                            .frame(height: .greatestFiniteMagnitude)
//                            .frame(height: 600)
//                            .safeAreaInset(edge: .bottom) {
//                                Image(systemName: "folder")
//                                    .background(.red)
//                            }
//                            .offset(y: shouldHideSubFolders ? -100 : 0)
//                            .animation(.spring().speed(2), value: !shouldHideSubFolders)
                        
//                            } // end of overlay
                        
                            
                    } // end of main VStack
                
//                }
                //                    .frame(maxHeight: .infinity)
            } // end of ScrollView
//            .background(.yellow)
//            .frame(maxHeight: .infinity)
//            .background(.yellow)
            
            // overlay white background when Alert show up
            if shouldAddSubFolder {
                Color(.white)
                    .opacity(0.8)
            }
            
            // When add folder pressed
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




