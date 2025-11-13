//
//  SortButton.swift
//  Journey
//
//  Created by Camposm on 11/12/25.
//

import SwiftUI

struct SortButton: View {
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: "slider.horizontal.3")
        .font(.system(size: 20))
        .foregroundColor(.blue)
        .padding(AppSpacing.small)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
  }
}

#Preview {
  SortButton(action: {
    print("Sort tapped")
  })
}
