//
//  ModelContext+Ext.swift
//  MindMate
//
//  Created by Alexander on 25.10.2025.
//

import Foundation
import SwiftData

extension ModelContext {
    func saveContext() {
        if self.hasChanges {
            do {
                try self.save()
            } catch {
                if let nsError = error as NSError? {
                    fatalError("Error saving ModelContext: \(nsError), \(nsError.userInfo)")
                } else {
                    fatalError("Error saving ModelContext: \(error)")
                }
            }
        }
    }
}
