//
//  CheckListView.swift
//  MindMate
//
//  Created by Alexander on 25.10.2025.
//

import SwiftUI

struct CheckListView: View {

    // MARK: Private Properties

    @Binding var items: [CheckListItem]

    // MARK: Body

    var body: some View {
        ForEach($items) { item in
            CheckListCellView(item: item)
                .frame(maxWidth: .infinity)
        }
    }
}
