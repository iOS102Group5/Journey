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
 * - Replace sample journal cards with real data from Parse database
 * - Add loading state while fetching journals from server
 * - Add empty state when no journals exist
 */

import SwiftUI

struct DashboardView: View {
  @State private var searchText = ""
  @State private var navigateToEditor = false
  @State private var showDetailSheet = false
  @State private var selectedJournal: Journal?
  @State private var sampleJournals: [Journal] = SAMPLE_JOURNALS
  @State private var filteredJournals: [Journal] = []

  private func handleSort() {
    /* TODO */
  }

  private func handleNewJournal() {
    selectedJournal = nil
    navigateToEditor = true
  }
  
  /**
   * Filters journals based on search text
   */
  private func filterJournals() {
    if searchText.isEmpty {
      /* no search text - show all journals */
      filteredJournals = sampleJournals
    } else {
      /* filter journals that match search text */
      let lowercasedSearch = searchText.lowercased()
      filteredJournals = sampleJournals.filter { journal in
        /* check if search text appears in title, location, or content */
        let titleMatch = journal.title?.lowercased().contains(lowercasedSearch) ?? false
        let locationMatch = journal.location?.lowercased().contains(lowercasedSearch) ?? false
        let contentMatch = journal.content?.lowercased().contains(lowercasedSearch) ?? false
        return titleMatch || locationMatch || contentMatch
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
      sampleJournals.removeAll { $0.id == journal.id }
      filteredJournals.removeAll { $0.id == journal.id }
    }
  }
  
  var body: some View {
    NavigationStack {
      AppHeader(text: "Journey", showIcon: true, paddingStyle: .both)
      VStack(spacing: AppSpacing.medium) {
        SearchBar(
          searchText: $searchText,
          sortAction: handleSort,
          onSearchChange: { _ in filterJournals() }
        )

        GradientButton(text: "Create New Journal", icon: "plus", fullWidth: true, action: handleNewJournal)
          .padding(.horizontal, AppSpacing.medium)

        JournalListView(journals: filteredJournals, onTap: handleJournalTap)
      }
      .frame(maxHeight: .infinity)
      .onAppear {
        filteredJournals = sampleJournals
      }
      .sheet(isPresented: $showDetailSheet) {
        if let journal = selectedJournal {
          JournalDetailView(
            journal: journal,
            onEdit: handleEdit,
            onDelete: handleDelete
          )
        }
      }
      .navigationDestination(isPresented: $navigateToEditor) {
        JournalEditorView(journal: selectedJournal)
      }
    }
  }
}

#Preview {
  DashboardView()
}
