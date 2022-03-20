//
//  MemoOrderingButton.swift
//  DeeepMemo (iOS)
//
//  Created by Mac mini on 2022/03/03.
//

import SwiftUI

struct MemoOrderingButton: View {

    @AppStorage(AppStorageKeys.mOrderType) var mOrderType = OrderType.modificationDate
    
    @ObservedObject var parentFolder: Folder
    
    var type: OrderType
    
    var body: some View {
        
        Button {
            mOrderType = type
            
            parentFolder.title += "" // update parent
        } label: {
            HStack {
                if mOrderType == type {
                    ChangeableImage(imageSystemName: "checkmark")
                }
                Text(LocalizedStringStorage.convertOrderTypeToStorage(type: type))
            }
        }
    }
}
