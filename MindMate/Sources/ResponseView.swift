//
//  ResponseView.swift
//  MindMate
//
//  Created by Alexander on 25.10.2025.
//

import SwiftData
import SwiftUI

struct ResponseView: View {

    // MARK: Public Properties

    @Binding var navigationPath: NavigationPath

    // MARK: Private Properties

    @Environment(NoteManager.self) private var noteManager
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    // MARK: Lifecycle

    init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.primary)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(.secondary)
    }

    // MARK: Body

    var body: some View {
        TabView {
            ScrollView {
                VStack {
                    Text("Inspiration")
                        .font(.title.bold())
                        .padding(.bottom, 30)

                    Text(noteManager.encouragingText)
                }
                .padding(.top, 20)
                .padding(.horizontal)
            }
            .tag(0)

            ScrollView {
                VStack {
                    Text("Checklist")
                        .font(.title.bold())
                        .padding(.bottom, 30)

                    ForEach(Array(noteManager.actionPoints.enumerated()), id: \.offset) { _, item in
                        HStack {
                            Image(systemName: "circle")
                                .foregroundStyle(.gray)
                                .font(.system(size: 22))
                            Text(item)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(Color.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal)
            }
            .tag(1)
        }
        .tabViewStyle(.page)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    "Done",
                    systemImage: "checkmark",
                    role: .close,
                    action: didTapDoneButton
                )
            }
        }
    }

    // MARK: Private Methods

    private func didTapDoneButton() {
        let createdAtDate = Calendar.current.startOfDay(for: noteManager.date)
        let note = Note(
            date: createdAtDate,
            userInput: noteManager.userInput,
            encouragingText: noteManager.encouragingText
        )
        modelContext.insert(note)

        for i in 1...noteManager.actionPoints.count {
            let checkListItem = CheckListItem(
                index: i,
                text: noteManager.actionPoints[i - 1],
                note: note
            )
            modelContext.insert(checkListItem)
        }

        modelContext.saveContext()

        navigationPath.removeLast(navigationPath.count)
    }
}
