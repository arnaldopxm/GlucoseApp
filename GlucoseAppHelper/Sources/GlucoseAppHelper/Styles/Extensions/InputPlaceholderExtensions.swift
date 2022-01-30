//
//  InputPlaceholderExtensions.swift
//  
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation
import SwiftUI

extension View {
    func placeholder(_ text: String, when shouldShow: Bool, alignment: Alignment = .leading) -> some View {
        ZStack(alignment: alignment) {
            Text(text).opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
