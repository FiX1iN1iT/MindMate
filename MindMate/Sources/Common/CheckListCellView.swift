//
//  CheckListCellView.swift
//  MindMate
//
//  Created by Alexander on 25.10.2025.
//

import SwiftUI

struct CheckListCellView: View {

    // MARK: Private Properties

    @Binding var item: CheckListItem

    // MARK: Body

    var body: some View {
        HStack {
            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(item.isChecked ? .black : .gray)
                .font(.system(size: 22))
                .onTapGesture {
                    item.isChecked.toggle()
                }
            Text(item.text)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color.secondary)
        }
    }
}
