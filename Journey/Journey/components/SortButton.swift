//
//  SortButton.swift
//  Journey
//
//  Created by Camposm on 11/12/25.
//

import SwiftUI

struct SortButton: View {
  @Binding var sortOption: JournalSortOption
  let onSortChange: () -> Void

  var body: some View {
    Menu {
      ForEach(JournalSortOption.allCases, id: \.self) { option in
        Button {
          sortOption = option
          onSortChange()
        } label: {
          HStack {
            Text(option.label)
            if option == sortOption {
              Image(systemName: "checkmark")
            }
          }
        }
      }
    } label: {
      HStack(spacing: 4) {
        Image(systemName: "slider.horizontal.3")
          .font(.system(size: 20))
        Text(sortOption.shortLabel)
          .font(.subheadline)
      }
      .foregroundColor(.blue)
      .padding(AppSpacing.small)
      .background(Color(.systemGray6))
      .cornerRadius(8)
    }
  }
}

#Preview {
  SortButton(
    sortOption: .constant(.dateDescending),
    onSortChange: { }
  )
}
