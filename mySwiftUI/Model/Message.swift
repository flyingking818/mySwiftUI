//
//  Message.swift
//  mySwiftUI
//
//  Created by Jeremy Wang on 4/28/25.
//

import Foundation
struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}
