//
//  Ordering.swift
//  DeeepMemo
//
//  Created by 이한목 on 2022/02/05.
//

import Foundation
import SwiftUI

// MARK: - ORDERING BASIC STRUCTURE
enum OrderType: String, CaseIterable, Codable {
    case modificationDate = "Modification Date"
    case creationDate = "Creation Date"
    case alphabetical = "Alphabetical"
}


class FolderOrder: ObservableObject {
    
    @Published var isAscending = true
    
    @Published var orderType: OrderType = .creationDate
}


class MemoOrder: ObservableObject {
    
    @Published var isAscending = false
    
    @Published var orderType: OrderType = .modificationDate
}
