//
//  CardView.swift
//  MindMate
//
//  Created by Alexander on 26.10.2025.
//

import SwiftUI

struct CardView<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: Content
    
    init(title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                Text(cardTitle(from: title))
                    .foregroundStyle(Color.secondary)

                if let subtitle {
                    Text(subtitle)
                        .font(.default.bold())
                }
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.secondary)
        }
    }

    // MARK: Private Methods

    private func cardTitle(from title: String) -> String {
        title
            .uppercased()
            .map { String($0) }
            .joined(separator: " ")
    }
}
