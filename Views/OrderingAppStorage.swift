//
//  AppStoragePractice.swift
//  DeeepMemo
//
//  Created by Mac mini on 2022/02/11.
//

import SwiftUI

//struct OrderingAppStorage: View {
//
////    @AppStorage("ordering") private(set) var order: Ordering = Ordering(folderType: "Modification Date", memoType: "Creation Date", folderAsc: true, memoAsc: false)
//    var body: some View {
//        VStack {
//            Text(order.folderOrderType)
//            Text(order.memoOrderType)
////            Text("\String((order.folderAsc))")
//            Text(String(order.memoAsc))
//            Text(String(order.folderAsc))
//
//            Button {
//                order.folderAsc.toggle()
//            } label: {
//                Text("Toggle Folder Asc")
//            }
//        }
//    }
//}

//struct AppStoragePractice_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderingAppStorage()
//    }
//}


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
        
//        do {
//            folderOrderType = try String(values.decode(String.self, forKey: .folderOrderType))
//
//        } catch DecodingError.typeMismatch {
//           id = try String(values.decode(String.self, forKey: .id))
//        }
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
