//
//  CheckListItem.swift
//  MindMate
//
//  Created by Alexander on 25.10.2025.
//

import Foundation
import SwiftData

@Model
final class CheckListItem {
    var index: Int
    var text: String
    var isChecked: Bool
    var note: Note

    init(index: Int, text: String, note: Note) {
        self.index = index
        self.text = text
        self.isChecked = false
        self.note = note
    }
}
