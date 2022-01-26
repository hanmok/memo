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
//    @StateObject var selectedViewModel = SelectedMemoViewModel()
//    @StateObject var folderViewModel = FolderViewModel()
    
//    @StateObject var memoEditVM = MemoEditViewModel()
//    @StateObject var folderEditVM = FolderEditViewModel()
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var folderEditVM : FolderEditViewModel
        
    @State var newSubFolderName = ""
//    @State var presentMindMapView = false
    @State var isSpreading = true
    @State var shouldHideSubFolders = false
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    //    @EnvironmentObject var nav: NavigationStateManager
    
    @ObservedObject var currentFolder: Folder
    
    func search() {
        
    }
    
    func editFolder() {
        
    }
    
    func toggleFavorite() {
        currentFolder.isFavorite.toggle()
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack {
                    if currentFolder.parent != nil {
                        HierarchyLabelView(currentFolder: currentFolder)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.leading, Sizes.overallPadding)
                    }
                    
                    SubFolderPageView(shouldHideSubFolderView: $shouldHideSubFolders)
//                        .environmentObject(folderEditVM)
                        .environmentObject(currentFolder)
                        .padding(.bottom, 20)
                    
//                    if !currentFolder.memos.isEmpty {
                    
                    if currentFolder.memos.isEmpty {
                        

                    MemoList(
                            pinViewModel: PinViewModel(
                                memos: currentFolder.memos)
                        )
                    }
                    
                    SubMemoList()
                        .environmentObject(memoEditVM)
                        .environmentObject(folderEditVM)
                    
//                    }
                } // end of main VStack
                .environmentObject(currentFolder)
                // current folder to both SubFolderPageView, MemoList
                
            } // end of ScrollView
//            if currentFolder.memos.isEmpty {
//                Button(action: {
////                    shouldAddMemo = true
//                    memoEditVM.shouldAddMemo = true
//                }) {
//                    Text("Press ") + Text(Image(systemName: "plus.circle")) + Text(" to make a new memo")
//                }
//            }
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    if memoEditVM.selectedMemos.count == 0 {
                        // show plus button
                        VStack(spacing: Sizes.minimalSpacing) {
                            
                            
                            Button(action: {
                                memoEditVM.shouldAddMemo = true
                                // navigate to MemoView
                            }) {
                                ChangeableImage(imageSystemName: "plus.circle", width: 40, height: 40)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                            }
                        }
                    } else {
                        // Do handler actions here
//                        MemosToolBarView(pinnedAction: { selMemos in
//                            // TODO : if all is pinned -> unpin
//                            // else : pin all
//
//                            var allPinned = true
//                            for each in selMemos {
//                                if each.pinned == false {
//                                    allPinned = false
//                                    break
//                                }
//                            }
//
//                            if !allPinned {
//                                for each in selMemos {
//                                    each.pinned = true
//                                }
//                            }
//                            context.saveCoreData()
//
//                        }, cutAction: { selMemos in
//
//
//                        }, copyAction: { selMemos in
//                            // TODO : .sheet(FolderMindMap)
//
//                        }, changeColorAcion: {selMemos in
//                            // Change backgroundColor
//                            //                            for eachMemo in selMemos {
//                            //                                        eachMemo.bgColor = bgColor
//                            //                            }
//                        }, removeAction: { selMemos in
//                            for eachMemo in selMemos {
////                                selectedViewModel.memos.remove(eachMemo)
//                                memoEditVM.selectedMemos.remove(eachMemo)
//                                Memo.delete(eachMemo)
//                            }
//                            context.saveCoreData()
//                        })
                        MemosToolBarView()
                            .padding([.trailing], Sizes.largePadding)
                            .padding(.bottom,Sizes.overallPadding )
                    }
                    
                    //                    }
                    
                } // end of HStack
            } // end of VStack
            
            // When add folder pressed
            // overlay white background when Alert show up
//            if shouldAddSubFolder {
            if folderEditVM.shouldAddFolder {
                Color(.white)
                    .opacity(0.8)
            }
            
            // When add folder pressed
            // Present TextFieldAlert
            TextFieldAlert(
//                isPresented: $shouldAddSubFolder,
                isPresented: $folderEditVM.shouldAddFolder,
                text: $newSubFolderName) { subfolderName in
                    currentFolder.add(
                        subfolder: Folder(title: newSubFolderName, context: context)
                    )
                    // setup initial name empty
                    newSubFolderName = ""
                }
            
            NavigationLink(destination: MemoView(memo: Memo(title: "", contents: "", context: context), parent: currentFolder, isNewMemo: true), isActive: $memoEditVM.shouldAddMemo) {}
            
            
        } // end of ZStack
        .frame(maxHeight: .infinity)
        
        .navigationTitle(currentFolder.title)
        .navigationBarItems(trailing:
                                HStack {
            Button(action: {
                toggleFavorite()
            }, label: {
                if currentFolder.isFavorite {
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tint(.yellow)
                } else {
                    ChangeableImage(imageSystemName: "star")
                }
            })
            
            Button(action: {
                
            }, label: {
                ChangeableImage(imageSystemName: "magnifyingglass")
            })
            
            
            
            
        }
        )
        
        .onAppear {
            print("folderView has appeared!")
        }
        .onDisappear {
            print("folderView has disappered!")
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




