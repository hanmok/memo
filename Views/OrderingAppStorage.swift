//
//  AppStoragePractice.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/11.
//

import SwiftUI



struct Ordering: Codable {
    var folderOrderType: String
    var memoOrderType: String
    
    var folderAsc: Bool
    var memoAsc: Bool
    
    enum CodingKeys: String, CodingKey {
        case folderOrderType
        case memoOrderType
        
        case folderAsc
        case memoAsc
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.folderOrderType = try values.decode(String.self, forKey: .folderOrderType)
        self.memoOrderType = try values.decode(String.self, forKey: .memoOrderType)
        
        self.folderAsc = try values.decode(Bool.self, forKey: .folderAsc)
        self.memoAsc = try values.decode(Bool.self, forKey: .memoAsc)

    }
    
    init(folderType: String, memoType: String, folderAsc: Bool, memoAsc: Bool) {
        self.folderOrderType = folderType
        self.memoOrderType = memoType
        self.folderAsc = folderAsc
        self.memoAsc = memoAsc
    }
}

extension Ordering: RawRepresentable {
   
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(Ordering.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(folderOrderType, forKey: .folderOrderType)
        try container.encode(memoOrderType, forKey: .memoOrderType)
        try container.encode(memoAsc, forKey: .memoAsc)
        try container.encode(folderAsc, forKey: .folderAsc)
    }
}
