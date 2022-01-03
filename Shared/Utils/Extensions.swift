//
//  Extensions.swift
//  DeeepMemo
//
//  Created by Mac mini on 2021/12/29.
//

import Foundation
import SwiftUI

extension Image {
    func setupAdditional(scheme: ColorScheme, size: CGFloat = 20) -> some View {
        self
            .addMode()
            .adjustTintColor(scheme: scheme)
            .frame(width: size , height: size)
    }
}

extension View {
    func adjustTintColor(scheme: ColorScheme) -> some View {
        self
            .tint(scheme == .dark ? .white : .black)
    }
}

extension Image {
    func addMode(contentMode: ContentMode = .fit) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}


// 그래서.. 이 MindMap 은 어디에 어떻게 놓아... ??
