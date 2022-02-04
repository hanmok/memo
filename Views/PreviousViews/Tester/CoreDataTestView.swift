//
//  testView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/05.
//

import SwiftUI
import CoreData

struct CoreDataTestView: View {
    
    @Environment(\.managedObjectContext) var context
    
    //    @State var folders: [Folder] = []
    //    @State var memos: [Memo] = []
    
    var memo: Memo?
    var folder: Folder?
    // initializer..
    
    // MARK: - Memo Handler Functions
    let request = Memo.fetch(.all)
    func addMemo() {
        // what's the parent folder ??
        let oneFolder = returnOneFolder()
        let memo = Memo(title: "\(oneFolder.title)'s \(oneFolder.memos.count) th child", contents: "test contents", context: context) // save
        
        // add to the parent folder,
        // parentFolder: first folder among fetched
        
        
        
        oneFolder.add(memo: memo)
        print("after updating fetchedFolder: \(oneFolder)")
        print("memos of fetchedFolder: \(oneFolder.memos)")
        
        print("added!")
        
    }
    
    func deleteMemo() {
        let request = Memo.fetch(.all)
        let fetchedMemo = (try! context.fetch(request).first)!
        Memo.delete(fetchedMemo)
        print("deleted!")
    }
    // 데이터가 일단.. 잘 안되네 ..  작동이 안됨.
    // 이름이 ViewModel 이어야 하는게 중요한게 아니야.
    // 이미 context 각 Folder, Memo 가 ObservableObject 야.
    // 그리고, context 에 접근하면 모든 Folder, Memo 에 접근 가능해.
    // ㅇㅋ? 음 ... 써보자.
    // Context 가 모든 곳에 전달되는 건 알겠는데,
    // 음.. 만약 하나의 Folder 또는 Memo 만 어떤 View 에 전달하고 싶으면 어떻게 해 ??
    // 음 .. NavigationStateManager 가 그 곳에 쓰이는 것 같은데..
    // 정확히 어떻게 작동하는지를 잘 모르겠네 .. ??
    func fetchMemos() {
        
        let request = Memo.fetch(.all)
        
        let fetchedMemos = try! context.fetch(request)
        print("fetched count: \(fetchedMemos.count)")
        for memo in fetchedMemos {
            memo.getMemoInfo()
        }
        //        memos = fetchedMemos
        
        print("fetched \(fetchedMemos.count) memos! ")
    }
    
    func updateMemo() { // updated !
        let request = Memo.fetch(.all)
        let fetchedMemo = (try! context.fetch(request).first)!
        fetchedMemo.title = "this is my new modified title !"
        try? context.save()
        fetchedMemo.getMemoInfo()
        print("updateMemo complete!")
    }
    
    func returnOneMemo() -> Memo {
        
        let request = Memo.fetch(.all)
        let fetchedMemo = try! context.fetch(request).first!
        return fetchedMemo
    }
    
    
    // MARK: - Folder Handler Functions
    
    func addFolder() {
        //        Folder.createHomeFolder(context: context)
        
        //        let _ = Folder(title: "my home folder", context: context)
        //        try? context.save()
        let _ = Folder.createHomeFolder(context: context)
        print("add Folder!")
    }
    
    func updateFolder() {
        
    }
    
    func deleteFolder() {
        
    }
    
    
    func deleteAllFolders() {
        let request = Folder.fetch(.all)
        if let result = try? context.fetch(request) {
            for r in result {
                context.delete(r)
            }
        }
        context.saveCoreData()
    }
    
    func addSubFolders() {
        let parent = Folder(title: "parent", context: context)
        let child1 = Folder(title: "child1", context: context)
        let child2 = Folder(title: "child2", context: context)
        parent.add(subfolder: child1)
        parent.add(subfolder: child2)
        context.saveCoreData()
        
    }
    
    
    func getFolders() {
        let request = Folder.fetch(.all)
        
        let fetchedFolders = try! context.fetch(request)
        //        print("fetched count: \(fetchedFolders.count)")
        for folder in fetchedFolders {
            folder.getFolderInfo()
        }
        //        folders = fetchedFolders
        
        print("fetched! \(fetchedFolders.count) folders!" )
    }
    
    func returnFolders() -> [Folder]{
        let request = Folder.fetch(.all)
        
        let fetchedFolders = try! context.fetch(request)
        //        print("fetched count: \(fetchedFolders.count)")
        for folder in fetchedFolders {
            folder.getFolderInfo()
        }
        return fetchedFolders
        //        folders = fetchedFolders
        
//        print("fetched! \(fetchedFolders.count) folders!" )
    }
    
    func returnOneFolder() -> Folder {
        let request = Folder.fetch(.all)
        
        let fetchedFolders = try! context.fetch(request)
        //        print("fetched count: \(fetchedFolders.count)")
        //        for folder in fetchedFolders {
        //            folder.getFolderInfo()
        //        }
        //        folders = fetchedFolders
        //        if fetchedFolders.count != 0 {
        //
        //        }
        //        let first = fetchedFolders.first!
        return fetchedFolders.first!
    }
    
    var body: some View {
        NavigationView {
            HStack {
                // MARK: - Memos
                VStack(spacing: 20) {
                    Text("Test for Memos")
                        .padding(.bottom, 50)
                    Button(action: fetchMemos) {
                        Text("get memos")
                    }
                    
                    Button(action: addMemo) {
                        Text("add memo")
                    }
                    Button(action: updateMemo) {
                        Text("update Memo")
                    }
                    Button(action: deleteMemo) {
                        Text("delete memo")
                    }
                    
                    NavigationLink(destination: ChangeMemoVarsTestView(memo: returnOneMemo())) { Text("navigate to TextField")}
                    
                    Spacer()
                }
                // MARK: - Folders
                VStack(spacing: 20) {
                    Text("Test for Folders")
                        .padding(.bottom, 50)
                    Button(action: getFolders) {
                        Text("get Folders")
                    }
                    
                    Button(action: addFolder) {
                        Text("add folder")
                    }
                    Button(action: updateFolder) {
                        Text("update Folder")
                    }
                    Button(action: deleteFolder) {
                        Text("delete folder")
                    }
                    Button(action: deleteAllFolders) {
                        Text("delete All folder")
                    }
                    Button(action: addSubFolders) {
                        Text("add SubFolders")
                    }
                    
                    NavigationLink(destination: ChangeFolderTitleTestView(folder: returnOneFolder())) {
                        Text("navigateToTextField")
                    }
                    
                    
                    Spacer()
                }
            }
        }
    }
}

//struct testView_Previews: PreviewProvider {
//    static var previews: some View {
//        testView()
//    }
//}
