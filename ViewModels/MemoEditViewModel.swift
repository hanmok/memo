import SwiftUI

class MemoEditViewModel: ObservableObject {
    
    @Published var isSelectionMode = false
    @Published var selectedMemos = Set<Memo>()
    
    // empty ? or optional empty ? empty would be better.. with Set.
//    var parentFolder: Folder? = nil
    var folderRelated = Set<Folder>()
    
    var hasNotLongSelected = true
    
    var navigateToMemo: Memo? = nil
    
    var someBool: Bool = false
    
    // 이거 없애니까 잘 보이긴 하네 .. ? 아님. 여전히 안보임.
    public var count: Int {
        get { selectedMemos.count }
        set { if newValue == 0 {
//            self.parentFolder = nil
        }}
    }
    
    // 왜 뒤로가?
    
    func add(memo: Memo) {
        print("memo has added!")
        self.selectedMemos.update(with: memo)
//        self.parentFolder = memo.folder
        self.folderRelated.update(with: memo.folder!)
    }
    
    func add(memos: [Memo]) {
        print("memo has added!")
        _ = memos.map { self.selectedMemos.update(with: $0)}
        
        if memos.count != 0 {
//            self.parentFolder = memos.first!.folder
            self.folderRelated.update(with: memos.first!.folder!)
        }
    }
    
    func erase(memo: Memo) {
        print("memo has erased!")
        self.selectedMemos.remove(memo)
        if selectedMemos.isEmpty {
            self.isSelectionMode = false
        }
    }
    
    // not effective.
    func initSelectedMemos() {
        self.selectedMemos.removeAll()
        isSelectionMode = false
//        self.parentFolder = nil
        self.folderRelated.removeAll()
    }
    
    func dealWhenMemoSelected(_ memo: Memo) {
        // already contained -> delete from selected List
        // else -> Add to selected List
        if selectedMemos.contains(memo) {
            erase(memo: memo)
        } else{
            add(memo: memo)
        }
    }
}
