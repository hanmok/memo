import SwiftUI

class MemoEditViewModel: ObservableObject {
    
//    @Published var hasNotLongSelected = true
//    @Published var shouldChangeColor = false
//
//    @Published var selectedMemos = Set<Memo>()
//
//    @Published var navigateToMemo: Memo? = nil
    
    var parentFolder: Folder? = nil
    
     var hasNotLongSelected = true
     var shouldChangeColor = false
    
    
     @Published var selectedMemos = Set<Memo>()
    
     var navigateToMemo: Memo? = nil
    
     var someBool: Bool = false
    
    public var count: Int {
        get {selectedMemos.count }
        set { if newValue == 0 { self.parentFolder = nil }}
    }
    
    func add(memo: Memo) {
        self.selectedMemos.update(with: memo)
        self.parentFolder = memo.folder
    }
    
    func erase(memo: Memo) {
        self.selectedMemos.remove(memo)
        
    }
    
    func initSelectedMemos() {
        self.selectedMemos.removeAll()
        hasNotLongSelected = true
        self.parentFolder = nil
    }
    
    func dealWhenMemoSelected(_ memo: Memo) {
        if selectedMemos.contains(memo) {
            erase(memo: memo)
        } else{
            add(memo: memo)
        }
    }
}
