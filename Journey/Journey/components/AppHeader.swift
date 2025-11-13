//
//  AppHeader.swift
//  Journey
//
//  Created by Camposm on 11/12/25.
//

import SwiftUI

enum HeaderPaddingStyle {
  case both
  case bottom
  case none
}

struct AppHeader: View {
  let text: String
  let showIcon: Bool
  let paddingStyle: HeaderPaddingStyle

  init(text: String, showIcon: Bool = false, paddingStyle: HeaderPaddingStyle = .both) {
    self.text = text
    self.showIcon = showIcon
    self.paddingStyle = paddingStyle
  }

  var body: some View {
    HStack(spacing: AppSpacing.small) {
      if showIcon {
        /* app icon */
        Image("favicon")
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      Text("\(text)")
//        .font(AppFonts.headerLarge)
        .font(.system(size: AppFontSize.headerLarge))
        .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity)
    .padding(.top, paddingStyle == .both ? AppSpacing.headerPaddingVertical : 0)
    .padding(.bottom, paddingStyle != .none ? AppSpacing.headerPaddingVertical : 0)
    .background(AppGradients.primary)
  }
}

#Preview {
  AppHeader(text: "Journey", showIcon: true)
}
