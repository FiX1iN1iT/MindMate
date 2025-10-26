//
//  NoteView.swift
//  MindMate
//
//  Created by Alexander on 22.10.2025.
//

import SwiftUI
import FoundationModels

struct NoteView: View {

    // MARK: Public Properties

    @Binding var navigationPath: NavigationPath

    // MARK: Private Properties

    @State private var text = ""
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var isShowingAlert = false

    @Environment(NoteManager.self) private var noteManager

    @FocusState private var isTextFieldFocused: Bool

    // MARK: Body

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("How are you doing today?")
                        .font(.title3.bold())

                    TextField("Start writing...", text: $text, axis: .vertical)
                        .focused($isTextFieldFocused)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 80)
            }
            .disabled(isLoading)

            HStack {
                Spacer()
                Button(action: submitAction) {
                    if isLoading {
                        Image(systemName: "progress.indicator")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .symbolEffect(
                                .variableColor.iterative.hideInactiveLayers,
                                options: .repeating
                            )
                    } else {
                        Image(systemName: "apple.intelligence")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                    }
                }
                .padding()
                .background(Circle().fill(.black))
                .disabled(isLoading || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldFocused = true
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Error Generating Response"),
                message: Text(alertMessage),
                dismissButton: .cancel {
                    navigationPath.removeLast(navigationPath.count)
                }
            )
        }
    }

    // MARK: Private Methods

    private func submitAction() {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        noteManager.userInput = text
        isLoading = true
        Task {
            do {
                let response = try await requestAIResponse(userInput: text)

                guard !navigationPath.isEmpty else { return }

                await MainActor.run {
                    self.noteManager.encouragingText = response.encouragingText
                    self.noteManager.actionPoints = response.actionPoints
                    self.navigationPath.append("response")
                    self.isLoading = false
                }
            } catch {
                guard !navigationPath.isEmpty else { return }

                await MainActor.run {
                    self.alertMessage = error.localizedDescription
                    self.isShowingAlert = true
                    self.isLoading = false
                }
            }
        }
    }

    private func requestAIResponse(userInput: String) async throws -> MentalStateRecommendation {
        let instructions =
        """
        You're an AI assistant to support the mental state.

        Analyze the description of the condition and give:
        1. Short supporting text
        2. Specific actions that can help

        Be empathetic, practical, and avoid cliches.
        """
        let session = LanguageModelSession(instructions: instructions)
        let output = try await session.respond(
            to: userInput,
            generating: MentalStateRecommendation.self
        )
        return output.content
    }
}
