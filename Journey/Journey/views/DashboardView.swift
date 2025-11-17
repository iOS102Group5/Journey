//
//  DashboardView.swift
//  Journey
//
//  Created by Camposm on 11/12/25.
//

/**
 * DashboardView - Main view showing all journal entries
 *
 * This is the home screen of the app, displaying:
 * 1. Search bar to filter journals (implemented with debounce)
 * 2. Sort button (TODO: implement sorting)
 * 3. "Create New Journal" button
 * 4. Scrollable list of journal cards
 *
 * TODO Items:
 * - Implement handleSort() for sorting journals by date/title
 * - Add empty state when no journals exist
 */

import SwiftUI

enum JournalSortOption: CaseIterable, Equatable {
  case dateDescending   // Newest first
  case dateAscending    // Oldest first
  case titleAZ          // A → Z
  case titleZA          // Z → A

  var label: String {
    switch self {
    case .dateDescending: return "Date: Newest first"
    case .dateAscending:  return "Date: Oldest first"
    case .titleAZ:        return "Title: A → Z"
    case .titleZA:        return "Title: Z → A"
    }
  }

  var shortLabel: String {
    switch self {
    case .dateDescending: return "Newest"
    case .dateAscending:  return "Oldest"
    case .titleAZ:        return "Title A–Z"
    case .titleZA:        return "Title Z–A"
    }
  }
}



struct DashboardView: View {
  @State private var searchText = ""
  @State private var navigateToEditor = false
  @State private var showDetailSheet = false
  @State private var selectedJournal: Journal?
  @State private var journals: [Journal] = []
  @State private var filteredJournals: [Journal] = []
  @State private var sortOption: JournalSortOption = .dateDescending

  private let dataManager = JournalDataManager.shared


  private func handleNewJournal() {
    selectedJournal = nil
    navigateToEditor = true
  }
  
  /**
   * Load journals from local storage
   */
  private func loadJournals() {
    journals = dataManager.loadJournals()
    filterJournals()
  }

  /**
   * Filters journals based on search text
   */
  private func filterJournals() {
    if searchText.isEmpty {
      /* no search text - show all journals */
      filteredJournals = journals
    } else {
      /* filter journals that match search text */
      let lowercasedSearch = searchText.lowercased()
      filteredJournals = journals.filter { journal in
        /* check if search text appears in title, location, or content */
        let titleMatch = journal.title?.lowercased().contains(lowercasedSearch) ?? false
        let locationMatch = journal.location?.lowercased().contains(lowercasedSearch) ?? false
        let contentMatch = journal.content?.lowercased().contains(lowercasedSearch) ?? false
        return titleMatch || locationMatch || contentMatch
      }
    }
      
    switch sortOption {
    case .dateDescending:
    // newest first
        filteredJournals.sort { $0.createdAt > $1.createdAt }

    case .dateAscending:
    // oldest first
        filteredJournals.sort { $0.createdAt < $1.createdAt }

    case .titleAZ:
        filteredJournals.sort {
          ($0.title ?? "")
            .localizedCaseInsensitiveCompare($1.title ?? "") == .orderedAscending
        }

    case .titleZA:
        filteredJournals.sort {
          ($0.title ?? "")
            .localizedCaseInsensitiveCompare($1.title ?? "") == .orderedDescending
        }
    }

    print("Filtered to \(filteredJournals.count) journals")
  }
  
  private func handleJournalTap(journal: Journal) {
    selectedJournal = journal
    showDetailSheet = true
  }

  private func handleEdit() {
    navigateToEditor = true
  }

  private func handleDelete() {
    if let journal = selectedJournal {
      dataManager.deleteJournal(withId: journal.id)
      loadJournals()
      showDetailSheet = false
    }
  }
  
  var body: some View {
    NavigationStack {
      AppHeader(text: "Journey", showIcon: true, paddingStyle: .both)
      VStack(spacing: AppSpacing.medium) {
        SearchBar(
          searchText: $searchText,
          sortOption: $sortOption,
          onSearchChange: { _ in filterJournals() }
        )

        GradientButton(text: "Create New Journal", icon: "plus", fullWidth: true, action: handleNewJournal)
          .padding(.horizontal, AppSpacing.medium)

        JournalListView(journals: filteredJournals, onTap: handleJournalTap)
      }
      .frame(maxHeight: .infinity)
      .onAppear {
        loadJournals()
      }
      .sheet(isPresented: $showDetailSheet) {
        loadJournals()
      } content: {
        if let journal = selectedJournal {
          JournalDetailView(
            journal: journal,
            onEdit: handleEdit,
            onDelete: handleDelete
          )
        }
      }
      .navigationDestination(isPresented: $navigateToEditor) {
        JournalEditorView(journal: selectedJournal, onSave: { _ in
          loadJournals()
        })
      }
    }
  }
}

#Preview {
  DashboardView()
}
