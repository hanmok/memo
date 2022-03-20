import SwiftUI

class MemoEditViewModel: ObservableObject {
    
    @Published var isSelectionMode = false
    @Published var selectedMemos = Set<Memo>()
    
    var folderRelated = Set<Folder>()
    
    var hasNotLongSelected = true
    
    var navigateToMemo: Memo? = nil
    
    var someBool: Bool = false
    
    
    public var count: Int {
        get { selectedMemos.count }
        set { if newValue == 0 {
        }}
    }
    
    
    func add(memo: Memo) {
        print("memo has added!")
        self.selectedMemos.update(with: memo)
        self.folderRelated.update(with: memo.folder!)
    }
    
    func add(memos: [Memo]) {
        print("memo has added!")
        memos.forEach { self.selectedMemos.update(with: $0)}
        
        if memos.count != 0 {
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
