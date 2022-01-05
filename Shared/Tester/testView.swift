//
//  testView.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/01/05.
//

import SwiftUI
import CoreData

struct testView: View {

    @Environment(\.managedObjectContext) var context
    
    var memo: Memo?
    var folder: Folder?
    
    func addMemo() {
        let memo = Memo(title: "old", context: context)
        memo.title = "new"
        memo.modificationDate = Date(timeIntervalSinceNow: 100)
        
        memo.getMemoInfo()
        print("added!")
    }
    func deleteMemo() {
        let request = Memo.fetch(.all)
        let fetchedMemo = (try! context.fetch(request).first)!
        Memo.delete(fetchedMemo)
        print("deleted!")
    }
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
        print("fetched!")
    }
    
    func updateMemo() {
        let request = Memo.fetch(.all)
        let fetchedMemo = (try! context.fetch(request).first)!
        fetchedMemo.title = "this is my new modified title !"
        fetchedMemo.getMemoInfo()
        print("updateMemo complete!")
    }
    func addFolder() {
        
    }
    func updateFolder() {
        
    }
    
    func deleteFolder() {
        
    }
    func getFolders() {
        
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("Test for Memos")
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
                
            }
            VStack {
                Text("Test for Folders")
                Button(action: addFolder) {
                    Text("add folder")
                }
                Button(action: updateMemo) {
                    Text("update Memo")
                }
                Button(action: deleteFolder) {
                    Text("delete folder")
                }
                Button(action: getFolders) {
                    Text("get Folders")
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
