//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData

struct FolderView: View {


    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var topFolders: FetchedResults<Folder>
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var folderEditVM : FolderEditViewModel
    @EnvironmentObject var memoOrder: MemoOrder
//    @StateObject var memoOrder = MemoOrder()
    

    @State var isShowingSubFolderView = false
    @State var isAddingMemo = false
    @State var shouldAddFolder = false
    @State var newSubFolderName = ""
    

    @State var showSelectingFolderView = false

    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @ObservedObject var currentFolder: Folder
    
    @FocusState var addFolderFocus: Bool
    
    func search() {
        
    }
    
    func editFolder() {
        
    }
    
    func toggleFavorite() {
        currentFolder.isFavorite.toggle()
    }
    
    func showSubFolderView() {
        isShowingSubFolderView = true
    }
    
    func addMemo() {
        isAddingMemo = true
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    if currentFolder.parent != nil {
                        HierarchyLabelView(currentFolder: currentFolder)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(.leading, Sizes.overallPadding)
                    }
                    ZStack {
                        if !currentFolder.memos.isEmpty {
                            MemoList()

                        }
                        HStack {
                            Spacer()
                            
                            // Button Or SubFolderView
                            ZStack(alignment: .topTrailing) {
                                
                                Button(action: {
                                    isShowingSubFolderView = true
                                },
                                       label: {
                                    SubFolderButtonImage()
                                })
                                .padding(.trailing, Sizes.overallPadding )
                                
                                SubFolderView(
                                    folder: currentFolder,
                                    isShowingSubFolderView: $isShowingSubFolderView,
                                    isAddingFolder: $shouldAddFolder)

                                    .frame(width: UIScreen.screenWidth / 2.5)
                                    .background(.yellow)
                                    .cornerRadius(10)
                                // offset x : trailingPadding
                                    .offset(x: isShowingSubFolderView ? -10 : UIScreen.screenWidth)
                                    .animation(.spring(), value: isShowingSubFolderView)
                            } // end of ZStack
                            .padding(.top, 10)

                        }
                    }
                } // end of main VStack
                .environmentObject(currentFolder)
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
            } // end of scrollView
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if memoEditVM.selectedMemos.count == 0 {
                        VStack(spacing: Sizes.minimalSpacing) {
                            Button(action: addMemo) {
                                PlusImage()
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding))
                            }
                        }
                    } else {

                        MemosToolBarView(showSelectingFolderView: $showSelectingFolderView)
//                            .background(Color(.sRGB, red: 50, green: 150, blue: 50, opacity: 1))

                            .padding([.trailing], Sizes.largePadding)
                            .padding(.bottom,Sizes.overallPadding )
                    }
                } // end of HStack
            } // end of VStack
            
            // When add folder pressed
            // overlay white background when Alert show up
            //            if shouldAddSubFolder {
            
//            if folderEditVM.shouldAddFolder {
//                Color(.white)
//                    .opacity(0.8)
//            }
            
            if shouldAddFolder {
                Color(.white)
                    .opacity(0.8)
            }
            
            
            
            //  Present TextFieldAlert when add folder pressed
            PrettyTextFieldAlert(
                placeHolderText: "Enter new folder name",
                type: .newSubFolder,
//                isPresented: $folderEditVM.shouldAddFolder,
                isPresented: $shouldAddFolder,
                text: $newSubFolderName,
                focusState: _addFolderFocus,
                submitAction: { subfolderName in
                    // when adding new subfolder, navigate to mindmapView. why.. ?'
                    // because of updateTopFolder .
                    currentFolder.add(
                        subfolder: Folder(title: newSubFolderName, context: context)
                    )
                    
                    newSubFolderName = ""
                    shouldAddFolder = false
                }, cancelAction: {
                    newSubFolderName = ""
                    shouldAddFolder = false
                })
//                .onReceive(folderEditVM.$shouldAddFolder) {
//                .onReceive($shouldAddFolder) {output in
//                    if output == true {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
//                            print("hi")
//                            self.addFolderFocus = true
//                        }
//                    }
//                }
//                .onChange(of: _addFolderFocus) { newValue in
//                    if newValue == .true {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  /// Anything over 0.5 seems to work
//                            print("hi")
//                            self.addFolderFocus = true
//                        }
//                    }
//                }
                
            
            NavigationLink(
                destination: MemoView(
                    memo: Memo(title: "", contents: "", context: context),
                    parent: currentFolder,
                    isNewMemo: true),
                isActive: $isAddingMemo) {}
        } // end of ZStack

        
        .sheet(isPresented: $showSelectingFolderView,
               content: {
            SelectingFolderView(fastFolderWithLevelGroup: FastFolderWithLevelGroup(targetFolders: topFolders.sorted()))
                .environmentObject(folderEditVM)
                .environmentObject(memoEditVM)
        })

        .onDisappear(perform: {
//            folderEditVM.shouldAddFolder = false
            newSubFolderName = ""
        })
        .frame(maxHeight: .infinity)
        
        .navigationTitle(currentFolder.title)
        
        .navigationBarItems(trailing:
                                HStack {
            // search Button
            Button(action: {

//                print("currentFolder's memos: \(currentFolder.memos)")
//                print("currentFolder's memo count : \(currentFolder.memos.count)")
//                for eachMemo in currentFolder.memos.sorted() {
//                    print("memo Title: \(eachMemo.title)")
//                    print("memo pinned : \(eachMemo.pinned)")
//                }
                currentFolder.title += "" // ;;; how can i change //. ??
//                context.saveCoreData()

            }, label: {
                ChangeableImage(imageSystemName: "magnifyingglass")
            })
            
            // Ordering
            Menu {
                Text("Memo Ordering")

                MemoOrderingButton(type: .modificationDate, memoOrder: memoOrder, parentFolder: currentFolder)
                MemoOrderingButton(type: .creationDate, memoOrder: memoOrder, parentFolder: currentFolder)
                MemoOrderingButton(type: .alphabetical, memoOrder: memoOrder, parentFolder: currentFolder)
                
                Divider()
                
                MemoAscDecButtonLabel(isAscending: true, memoOrder: memoOrder, parentFolder: currentFolder)
                
                MemoAscDecButtonLabel(isAscending: false, memoOrder: memoOrder, parentFolder: currentFolder)

                
            } label: {
                ChangeableImage(imageSystemName: "arrow.up.arrow.down")
            }
            
            // favorite Button
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

            // open talk View
            Button {

            } label: {
                ChangeableImage(imageSystemName: "bubble.right")
            }
            
            
            
        }
        )
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




