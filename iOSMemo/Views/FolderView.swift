//
//  FolderView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/21.
//

import SwiftUI
import CoreData

// FolderView should get a Valid Folder.
struct FolderView: View {
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    

    // this one maybe needed to homeView
//    @FetchRequest(fetchRequest: Folder.topFolderFetch()) var folders: FetchedResults<Folder>
        
    let currentFolder : Folder
    var selectedMemos: [Memo]? // handle checked memos according to MemoToolBarView's action
    
    @EnvironmentObject var nav: NavigationStateManager

    @State var memoSelected = false // use it to switch plus button into toolbar


    @State var pinnedFolder: Bool = false
    
    @State var plusButtonPressed: Bool = false
    // if changed, present sheet
    
    func search() {
        
    }
    
    func pinThisFolder() {
        pinnedFolder.toggle()
    }
    
    func editFolder() {
        
    }
    
    var subfolders: [Folder] {
        var folders: [Folder] = []
        for eachFolder in currentFolder.subfolders {
            folders.append(eachFolder)
        }
        return folders
    }
    
    func convertSetToArray(set: Set<Memo>) -> Array<Memo> {
        var emptyMemo: [Memo] = []
        for each in set {
            emptyMemo.append(each)
        }
        print("emptymemo: \(emptyMemo)")
// choose between two
        emptyMemo.sort(by: { $0.order > $1.order})
        emptyMemo.sort(by: { $0.order < $1.order})
        
        return emptyMemo
    }
    
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                Text(currentFolder.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .padding([.bottom, .leading], 30)
                
                SubFolderPageView(folder: currentFolder)
                    
//                MemoList(memosFromFolderView: convertSetToArray(set: currentFolder.memos), folder: currentFolder)
                MemoList2(memosFromFolderView: convertSetToArray(set: currentFolder.memos), folder: currentFolder)
                    .padding(.horizontal, Sizes.overallPadding)
//                    .background(.green)
            } // end of main VStack
        }
        
//        .navigationBarTitle(currentFolder.title)
//        .navigationTitle("hi")
        .navigationBarItems(trailing: Button(action: pinThisFolder, label: {
            ChangeableImage(imageSystemName: pinnedFolder ? "pin.fill" : "pin", width: 24, height: 24)
        }))

        .onAppear(perform: {
            print("FolderView has appeared, folder: \(currentFolder.title)")
        })
//        .sheet(isPresented: $plusButtonPressed, content: {
//                MemoView(memo: Memo(title: "", context: context))
//        })
        
        // MainTabBar, + Icon to add memos
        .overlay {
            VStack {
                Spacer()
                // + Icon
                HStack {
                    Spacer()
                    
                    if !memoSelected {
                        Button(action: {
                            plusButtonPressed.toggle()
                        }) {
                            PlusImage()
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
                        }
                    } else { // if some memos are selected
                        MemosToolBarView()
//                            .onReceive(<#T##publisher: Publisher##Publisher#>, perform: <#T##(Publisher.Output) -> Void#>)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: Sizes.overallPadding, trailing: Sizes.overallPadding * 1.5))
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




