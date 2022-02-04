import SwiftUI

class MemoEditViewModel: ObservableObject {
    
    //    var context: NSManagedObjectContext
    
//    var testMemos: Memo? = nil
    
    @Published var hasNotLongSelected = true
    
//    @Published var shouldAddMemo = false
    @Published var shouldChangeColor = false
    
    @Published var selectedMemos = Set<Memo>()
    
    @Published var navigateToMemo: Memo? = nil
    
//    @Published var didCutMemos: [Memo] = [] // not necessary ..
    
    public var count: Int {
        selectedMemos.count
    }
    
    func add(memo: Memo) {
        self.selectedMemos.update(with: memo)
    }
    
    func erase(memo: Memo) {
        self.selectedMemos.remove(memo)
    }
    
    func initSelectedMemos() {
        self.selectedMemos.removeAll()
        hasNotLongSelected = true
    }
    
    func dealWhenMemoSelected(_ memo: Memo) {
        if selectedMemos.contains(memo) {
            erase(memo: memo)
        } else{
            add(memo: memo)
        }
    }
    
    // after selecting several memos
    
    //    @Published var pinPressed = false {
    //        didSet {
    //            if oldValue == true {
    //                var allPinned = true
    //                for each in selectedMemos {
    //                    if each.pinned == false {
    //                        allPinned = false
    //                        break
    //                    }
    //                }
    //
    //                if !allPinned {
    //                    for each in selectedMemos {
    //                        each.pinned = true
    //                    }
    //                }
    //                context.saveCoreData()
    //            }
    //        }
    //    }
    
    //    init(context: NSManagedObjectContext) {
    //        self.context = context
    //    }
    
    
    
    
    //    var pinnedAction: ([Memo]) -> Void
    //    var cutAction: ([Memo]) -> Void
    //    var copyAction: ([Memo]) -> Void
    //    var changeColorAcion: ([Memo]) -> Void
    //    var removeAction: ([Memo]) -> Void
    
    // initializer 를 먼저 공부하는게 맞다.
    
    
    //    init(
    //        pinnedAction: @escaping ([Memo]) -> Void = { _ in },
    //        cutAction: @escaping ([Memo]) -> Void = { _ in
    ////            self.didCutMemos
    //        },
    //        copyAction: @escaping ([Memo]) -> Void = { _ in },
    //        changeColorAcion: @escaping ([Memo]) -> Void = { _ in },
    //        removeAction: @escaping ([Memo]) -> Void = { _ in }
    //    ) {
    //        self.pinnedAction = pinnedAction
    //        self.cutAction = cutAction
    //        self.copyAction = copyAction
    //        self.changeColorAcion = changeColorAcion
    //        self.removeAction = removeAction
    //    }
    
    
    
    
    
}
