import SwiftUI

class MemoEditViewModel: ObservableObject {
    
    var parentFolder: Folder? = nil
    
     var hasNotLongSelected = true

    @Published var isSelectionMode = false
     @Published var selectedMemos = Set<Memo>()
    
     var navigateToMemo: Memo? = nil
    
     var someBool: Bool = false
    
    public var count: Int {
        get { selectedMemos.count }
        set { if newValue == 0 {
            self.parentFolder = nil
//            self.isSelectionMode = false
            
        }}
    }
    
    func add(memo: Memo) {
        self.selectedMemos.update(with: memo)
        self.parentFolder = memo.folder
    }
    
    func add(memos: [Memo]) {
        
//        for eachMemo in memos {
//            self.selectedMemos.update(with: eachMemo)
//        }

        _ = memos.map { self.selectedMemos.update(with: $0)}
        
        if memos.count != 0 {
            self.parentFolder = memos.first!.folder
        }

    }
    
    func erase(memo: Memo) {
        self.selectedMemos.remove(memo)
        if selectedMemos.isEmpty {
            self.isSelectionMode = false
        }
    }
    
    func initSelectedMemos() {
        self.selectedMemos.removeAll()
//        hasNotLongSelected = true
        isSelectionMode = false
        self.parentFolder = nil
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
