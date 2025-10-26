//
//  Note.swift
//  MindMate
//
//  Created by Alexander on 25.10.2025.
//

import Foundation
import SwiftData

@Model
final class Note {
    @Attribute(.unique) var date: Date
    var userInput: String
    var encouragingText: String
    @Relationship(deleteRule: .cascade, inverse: \CheckListItem.note) var checkListItems: [CheckListItem]

    init(
        date: Date,
        userInput: String,
        encouragingText: String
    ) {
        self.date = date
        self.userInput = userInput
        self.encouragingText = encouragingText
        self.checkListItems = []
    }
}
