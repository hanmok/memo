//
//  OrderingButton.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/01.
//

import SwiftUI

// 재활용 할 것과 재활용 하지 않을 것을 결정해야함.
// FolderMemoOrder 는 ObservableObject . 하지만 이건.. Folder 와 Memo 둘로 나뉘어야함.
enum OrderType: String {
    case modificationDate = "Modification Date"
    case creationDate = "Creation Date"
    case alphabetical = "Alphabetical"
}

class FolderOrder: ObservableObject {
    @Published var isAscending = true
    
    @Published var orderType: OrderType = .modificationDate
}

class MemoOrder: ObservableObject {
    @Published var isAscending = true
    
    @Published var orderType: OrderType = .modificationDate
}




struct FolderOrderingButton: View {
    
    var type: OrderType
    
    @ObservedObject var folderOrder: FolderOrder
    
    var body: some View {
        
        Button {
            folderOrder.orderType = type
        } label: {
            HStack {
                if folderOrder.orderType == type {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(type.rawValue)
            }
        }
    }
}

struct MemoOrderingButton: View {
    
    var type: OrderType
    
    @ObservedObject var memoOrder: MemoOrder
    
    var body: some View {
        
        Button {
            memoOrder.orderType = type
        } label: {
            HStack {
                if memoOrder.orderType == type {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(type.rawValue)
            }
        }
    }
}

struct FolderAscDecButtonLabel: View {
    var isAscending: Bool
    @ObservedObject var folderOrder: FolderOrder
    
    var body: some View {
        Button {
            folderOrder.isAscending = isAscending
        } label: {
            HStack {
                if folderOrder.isAscending == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}

struct MemoAscDecButtonLabel: View {
    var isAscending: Bool
    @ObservedObject var memoOrder: MemoOrder
    
    var body: some View {
        Button {
            memoOrder.isAscending = isAscending
        } label: {
            HStack {
                if memoOrder.isAscending == isAscending {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(isAscending ? "Ascending Order" : "Decending Order")
            }
        }
    }
}

//struct OrderingButton_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderingButton()
//    }
//}
