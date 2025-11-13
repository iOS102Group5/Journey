//
//  JournalDetailView.swift
//  Journey
//
//  Created by Camposm on 11/12/25.
//

import SwiftUI

struct JournalDetailView: View {
  @Environment(\.dismiss) var dismiss
  let journal: Journal
  let onEdit: () -> Void
  let onDelete: () -> Void

  @State private var showDeleteAlert = false

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          /* hero image with title overlay - extends under toolbar */
          ZStack(alignment: .bottomLeading) {
            /* background image */
            Group {
              if let imageUrl = journal.thumbnailImage {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                  switch phase {
                  case .success(let image):
                    image
                      .resizable()
                      .scaledToFill()
                  case .empty:
                    Color(.systemGray5)
                      .overlay(ProgressView())
                  case .failure:
                    Color(.systemGray5)
                      .overlay(
                        Image(systemName: "photo.fill")
                          .font(.system(size: 40))
                          .foregroundColor(.secondary)
                      )
                  @unknown default:
                    Color(.systemGray5)
                  }
                }
              } else {
                LinearGradient(
                  colors: [Color(.systemGray5), Color(.systemGray6)],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
                .overlay(
                  Image(systemName: "photo")
                    .font(.system(size: 100))
                    .foregroundColor(.secondary.opacity(0.3))
                )
              }
            }
            .frame(height: 350)
            .clipped()

            /* gradient overlay for text readability */
            LinearGradient(
              colors: [Color.clear, Color.black.opacity(0.7)],
              startPoint: .top,
              endPoint: .bottom
            )

            /* title and metadata overlay */
            VStack(alignment: .leading, spacing: AppSpacing.small) {
              Text(journal.title ?? "Untitled")
                .font(.system(size: AppFontSize.headerLarge, weight: .bold))
                .foregroundColor(.white)

              HStack(spacing: AppSpacing.medium) {
                if let date = journal.createdAt {
                  HStack(spacing: 4) {
                    Image(systemName: "calendar")
                    Text(date, style: .date)
                  }
                  .font(.system(size: AppFontSize.caption))
                  .foregroundColor(.white.opacity(0.9))
                }

                if let location = journal.location {
                  HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                    Text(location)
                  }
                  .font(.system(size: AppFontSize.caption))
                  .foregroundColor(.white.opacity(0.9))
                }
              }
            }
            .padding(AppSpacing.medium)
          }
          .frame(maxWidth: .infinity)

          VStack(alignment: .leading, spacing: AppSpacing.medium) {

            /* content */
            if let content = journal.content {
              Text(content)
                .font(.system(size: AppFontSize.body))
                .foregroundColor(.primary)
            }

            /* map view */
            if journal.location != nil {
              MapView(locationName: journal.location)
                .padding(.top, AppSpacing.small)
            }

            /* action buttons */
            HStack(spacing: AppSpacing.medium) {
              Button(action: {
                showDeleteAlert = true
              }) {
                HStack {
                  Image(systemName: "trash.fill")
                  Text("Delete")
                    .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(AppSpacing.small)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
              }

              GradientButton(text: "Edit", icon: "pencil", fullWidth: true, action: {
                dismiss()
                onEdit()
              })
            }
          }
          .padding(.horizontal, AppSpacing.medium)
          .padding(.top, AppSpacing.large)
          .padding(.bottom, AppSpacing.medium)
        }
      }
      .ignoresSafeArea(edges: .top)
//      .navigationTitle(journal.title ?? "Journal")
//      .navigationBarTitleDisplayMode(.automatic)
//      .toolbar {
//        ToolbarItem(placement: .navigationBarTrailing) {
//          Button(action: {
//            dismiss()
//          }) {
//            Text("Close").foregroundColor(.red)
////            Image(systemName: "xmark.circle.fill")
////              .font(.system(size: 28))
////              .foregroundColor(.white)
////              .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
//          }
//        }
//      }
      .alert("Delete Journal", isPresented: $showDeleteAlert) {
        Button("Cancel", role: .cancel) { }
        Button("Delete", role: .destructive) {
          dismiss()
          onDelete()
        }
      } message: {
        Text("Are you sure you want to delete this journal? This action cannot be undone.")
      }
    }
  }
}
