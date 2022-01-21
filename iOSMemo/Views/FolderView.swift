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
    @StateObject var folderViewModel = FolderViewModel()
    
    @StateObject var memoEditVM = MemoEditVM()
    @StateObject var folderEditVM = FolderEditVM()
    
    @State var shouldAddSubFolder = false
    @State var shouldHideSubFolders = false
    
    @State var newSubFolderName = ""
    
    @State var isAddingMemo = false
    //    @State var shouldHideSubFolders = false
    
    //    @EnvironmentObject var nav: NavigationStateManager
    
    //    @State var testToggler = false
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @State var presentMindMapView = false
    @State var isSpeading = false
    //    @EnvironmentObject var nav: NavigationStateManager
    
    @ObservedObject var currentFolder: Folder
    //    func presentFolderOverview
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
//                    Text("subNavigation")
                    
//                    Text("root for this folder")
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                        .padding(.leading, Sizes.overallPadding)
                    HierarchyLabelView(currentFolder: currentFolder)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.leading, Sizes.overallPadding)
                        
                    
                    SubFolderPageView(
                        shouldAddSubFolder: $shouldAddSubFolder,
                        shouldHideSubFolderView: $shouldHideSubFolders
                    )
                    //                            .environmentObject(currentFolder)
                    if !currentFolder.memos.isEmpty {
//                    Spacer()
//                    }
                        MemoList(
                            isAddingMemo: $isAddingMemo,
                            isSpeading: $isSpeading,
                            pinViewModel: PinViewModel(
                                memos: currentFolder.memos)
                        )
                        //                            .environmentObject(currentFolder)
                            .environmentObject(selectedViewModel)
                    }
                    
                } // end of main VStack
                .environmentObject(currentFolder)
                // current folder to both SubFolderPageView, MemoList
                
            } // end of ScrollView
            if currentFolder.memos.isEmpty {
                Button(action: {
                    isAddingMemo = true
                }) {
                    Text("Press ") + Text(Image(systemName: "plus.circle")) + Text(" to make a new memo")
                }
            }
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    //                    if !presentFolderOverview {
                    
                    if selectedViewModel.count == 0 {
                        // show plus button
                        VStack(spacing: Sizes.minimalSpacing) {
                            
                            if !currentFolder.subfolders.isEmpty{
                            Button(action: {
                                isSpeading.toggle()
                            }) {
                                //                                ChangeableImage(imageSystemName: isSpeading ? "rays" : "timelapse", width: 32, height: 32)
                                
                                ZStack {
                                    ChangeableImage(imageSystemName: "circle", width: 40, height: 40)
                                    
                                    if isSpeading {
//                                        ChangeableImage(imageSystemName:  "smallcircle.fill.circle", width: 40, height: 40)
                                        ChangeableImage(imageSystemName: "circle.fill", width: 10, height: 10)
                                    }
                                    else {
                                    ChangeableImage(imageSystemName:  "circles.hexagongrid.fill", width: 24, height: 24)
                                    }
                                    
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                                
                                
                            }
                            }
                            
                            
                            Button(action: {
                                isAddingMemo = true
                                // navigate to MemoView
                            }) {
                                ChangeableImage(imageSystemName: "plus.circle", width: 40, height: 40)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                            }
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
                            //                            for eachMemo in selMemos {
                            //                                        eachMemo.bgColor = bgColor
                            //                            }
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
                    
                    //                    }
                    
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
            
            NavigationLink(destination: MemoView(memo: Memo(title: "", contents: " ", context: context), parent: currentFolder, isNewMemo: true), isActive: $isAddingMemo) {}
            
            //            NavigationLink(destination: <#T##() -> _#>, label: <#T##() -> _#>)
            
        } // end of ZStack
        .frame(maxHeight: .infinity)
        .fullScreenCover(isPresented: $presentMindMapView, content: {
            MindMapView()
                .environmentObject(folderViewModel)
        })
        
        .navigationTitle(currentFolder.title)
//        .navigationTitle(Text(currentFolder.title) + Text("\nguys"))
//        .navigationBarTitleDisplayMode(.automatic)
//        .toolbar {
//            ToolbarItem(placement: .principal) {
//                Text("Title").font(.headline)
//                Text("Subtitle").font(.subheadline)
//            }
//        }
        
        .navigationBarItems(trailing:
                                HStack {
            Button(action: {
                presentMindMapView = true
            }) {
                ChangeableImage(imageSystemName: "icloud")
            }
            
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




