//
//  AppStorageKeys.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/21.
//

import Foundation

struct AppStorageKeys {
//    AppStorageKeys.fOrderType
    static let fOrderType = "fOrderType"
    static let fOrderAsc = "fOrderAsc"
    
    static let mOrderType = "mOrderType"
    static let mOrderAsc = "mOrderAsc"
}


// Memo

/*
@AppStorage("mOrderType") var mOrderType = OrderType.modificationDate
@AppStorage("mOrderAsc") var mOrderAsc = false

let sortingMethod = Memo.getSortingMethod(type: mOrderType, isAsc: mOrderAsc)

 */

// Folder
/*
 
@AppStorage(AppStorageKeys.fOrderType) var fOrderType = OrderType.creationDate
@AppStorage(AppStorageKeys.fOrderAsc) var fOrderAsc = false

let sortingMethod = Folder.getSortingMethod(type: fOrderType, isAsc: fOrderAsc)
 
*/
