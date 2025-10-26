//
//  NoteManager.swift
//  MindMate
//
//  Created by Alexander on 26.10.2025.
//

import SwiftUI

@Observable final class NoteManager {

    // MARK: Public Properties

    var date: Date = Date()
    var userInput: String = ""
    var encouragingText: String = ""
    var actionPoints: [String] = []

    var isEmpty: Bool {
        userInput.isEmpty && encouragingText.isEmpty && actionPoints.isEmpty
    }

    // MARK: Public Methods

    func clearNoteData() {
        userInput = ""
        encouragingText = ""
        actionPoints = []
    }
}
