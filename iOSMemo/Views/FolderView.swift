//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData

struct FolderView: View {
    
    @EnvironmentObject var memoEditVM : MemoEditViewModel
    @EnvironmentObject var folderEditVM : FolderEditViewModel
    @StateObject var memoOrder = MemoOrder()
    @State var isShowingSubFolderView = false
    @State var isAddingMemo = false
    @State var shouldAddFolder = false
    @State var newSubFolderName = ""
    
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
                                .padding(.top, 10)
                        }
                        HStack {
                            Spacer()
                            // Button Or SubFolderView
                            ZStack(alignment: .topTrailing) {
                                
                                Button(action: showSubFolderView, label: {
                                    SubFolderButtonImage()
                                })
                                    .padding(.trailing, Sizes.overallPadding )
                                
                                SubFolderView(folder: currentFolder, isShowingSubFolderView: $isShowingSubFolderView, isAddingFolder: $shouldAddFolder)
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
                        MemosToolBarView()
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
//            TextFieldAlert(
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
                print("currentFolder's memos: \(currentFolder.memos)")
                print("currentFolder's memo count : \(currentFolder.memos.count)")
            }, label: {
                ChangeableImage(imageSystemName: "magnifyingglass")
            })
            
            // Ordering
            Menu {
                Text("Memo Ordering")
                MemoOrderingButton(type: .modificationDate, memoOrder: memoOrder)
                MemoOrderingButton(type: .creationDate, memoOrder: memoOrder)
                MemoOrderingButton(type: .alphabetical, memoOrder: memoOrder)
                
                Divider()
                
                MemoAscDecButtonLabel(isAscending: true, memoOrder: memoOrder)
                
                MemoAscDecButtonLabel(isAscending: false, memoOrder: memoOrder)
                
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




