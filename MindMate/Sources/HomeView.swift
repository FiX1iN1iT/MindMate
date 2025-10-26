//
//  HomeView.swift
//  MindMate
//
//  Created by Alexander on 25.10.2025.
//

import FoundationModels
import SwiftData
import SwiftUI

struct HomeView: View {

    // MARK: Private Properties

    @State private var date: Date = Date()
    @State private var note: Note?

    @State private var noteManager = NoteManager()
    @State private var navigationPath = NavigationPath()

    @State private var alertMessage = ""
    @State private var isShowingAlert = false

    @Environment(\.modelContext) private var modelContext

    // MARK: Body

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 16) {
                CalendarView(selectedDate: $date)

                if let note {
                    ScrollView {
                        VStack(spacing: 8) {
                            CardView(
                                title: "Reflection",
                                subtitle: "How are you doing today?"
                            ) {
                                Text(note.userInput)
                            }

                            CardView(title: "Inspiration") {
                                Text(note.encouragingText)
                            }

                            CardView(
                                title: "Checklist",
                                subtitle: "How to boost your mood"
                            ) {
                                CheckListView(items: Binding(
                                    get: { note.checkListItems.sorted(by: { $0.index < $1.index }) },
                                    set: {
                                        note.checkListItems = $0
                                        modelContext.saveContext()
                                    }
                                ))
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                } else {
                    ContentUnavailableView {
                        Label("Wrap up the day", systemImage: "heart")
                    } description: {
                        Text("Write how you feel and get recommendations on how to boost your mood.")
                    } actions: {
                        Button(action: didTapReflectButton) {
                            Text("Reflect")
                                .font(.default.bold())
                                .foregroundStyle(Color.primary)
                                .padding(.vertical)
                                .padding(.horizontal, 24)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(Color.secondary)
                                }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                    .navigationDestination(for: String.self) { id in
                        if id == "note" {
                            NoteView(navigationPath: $navigationPath)
                                .environment(noteManager)
                        } else if id == "response" {
                            ResponseView(navigationPath: $navigationPath)
                                .environment(noteManager)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            fetchNote(for: date)
        }
        .onChange(of: date) { _, newValue in
            fetchNote(for: newValue)
        }
        .onChange(of: navigationPath) { _, newValue in
            if !noteManager.isEmpty, newValue.isEmpty {
                fetchNote(for: date)
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Apple Intelligence Unavailable"),
                message: Text(alertMessage),
                dismissButton: .cancel {
                    navigationPath.removeLast(navigationPath.count)
                }
            )
        }
    }

    // MARK: Private Methods

    private func fetchNote(for date: Date) {
        let startOfDate = Calendar.current.startOfDay(for: date)
        let predicate = #Predicate<Note> { note in note.date == startOfDate }
        let descriptor = FetchDescriptor<Note>(predicate: predicate)

        do {
            let notes = try modelContext.fetch(descriptor)
            note = notes.first
        } catch {
            note = nil
        }
    }

    private func didTapReflectButton() {
        switch SystemLanguageModel.default.availability {
        case .available:
            break

        case let .unavailable(reason):
            switch reason {
            case .deviceNotEligible:
                self.alertMessage = "Your device is not eligible for Apple Intelligence."
                self.isShowingAlert = true
                return

            case .appleIntelligenceNotEnabled:
                self.alertMessage = "Enable Apple Intelligence in system settings."
                self.isShowingAlert = true
                return

            case .modelNotReady:
                self.alertMessage = "Check Apple Intelligence model downloading state in system settings."
                self.isShowingAlert = true
                return

            @unknown default:
                self.alertMessage = "Try relaunching app."
                self.isShowingAlert = true
                return
            }
        }

        noteManager.clearNoteData()
        noteManager.date = date
        navigationPath.append("note")
    }
}
