//
//  Journal.swift
//  Journey
//
//  Created by Camposm on 11/12/25.
//

import Foundation
import ParseSwift

/**
 * Journal - Data Model for journal entries
 *
 * This struct represents a journal entry in the app and database.
 */
struct Journal: ParseObject {
  /* required by ParseObject protocol - DO NOT remove these */
  var objectId: String? /* unique ID from database (e.g., "abc123xyz") */
  var createdAt: Date? /* when this journal was created */
  var updatedAt: Date? /* when this journal was last edited */
  var ACL: ParseACL? /* access control - who can read/write this journal */
  var originalData: Data? /* raw server data for tracking changes */

  /* custom properties - your journal data */
  var title: String? /* journal title (e.g., "My Trip to Paris") */
  var location: String? /* where journal was written (e.g., "San Francisco, CA") */
  var content: String? /* full journal text/story */
  var images: [String]? /* array of image URLs or file references */

  /**
   * Computed Property: snippet
   *
   * Computed properties don't store data - they calculate a value on-the-fly.
   * This creates a short preview of the journal content for display in cards.
   *
   */
  var snippet: String {
    guard let content = content else { return "" }
    let maxLength = 100
    if content.count <= maxLength {
      return content
    }
    let trimmed = String(content.prefix(maxLength))
    return trimmed + "..."
  }

  /**
   * Computed Property: thumbnailImage
   *
   * Returns the first image from the images array to display as a thumbnail.
   *
   * Example:
   *   images = ["https://example.com/img1.jpg", "https://example.com/img2.jpg"]
   *   thumbnailImage = "https://example.com/img1.jpg"
   *
   *   images = nil or []
   *   thumbnailImage = nil
   */
  var thumbnailImage: String? {
    return images?.first
  }
}

extension Journal: Identifiable {
  var id: String {
    return objectId ?? UUID().uuidString
  }
}

let SAMPLE_JOURNALS: [Journal] = [
  {
    var journal = Journal()
    journal.title = "Morning Reflections"
    journal.createdAt = Date().addingTimeInterval(-86400) /* 1 day ago */
    journal.location = "San Francisco, CA"
    journal.content = "Woke up early today and spent some time thinking about my goals for this year. I want to focus on personal growth and building meaningful connections."
    journal.images = ["https://i.imgur.com/IdorGF4.png"]
    return journal
  }(),
  {
    var journal = Journal()
    journal.title = "Beach Day Adventures"
    journal.createdAt = Date().addingTimeInterval(-172800) /* 2 days ago */
    journal.location = "Malibu, CA"
    journal.content = "The ocean was so calm today. Spent hours just walking along the shore, collecting shells and watching the sunset. Sometimes the simple moments are the best."
    journal.images = ["https://i.imgur.com/f45Vtup.png"]
    return journal
  }(),
  {
    var journal = Journal()
    journal.title = "Coffee Shop Musings"
    journal.createdAt = Date().addingTimeInterval(-259200) /* 3 days ago */
    journal.location = "Seattle, WA"
    journal.content = "Found this amazing little coffee shop downtown. The atmosphere is perfect for journaling. Met an interesting person who shared their travel stories with me."
    journal.images = ["https://i.imgur.com/HYXlcFI.jpeg"]
    return journal
  }(),
  {
    var journal = Journal()
    journal.title = "My Trip to Paris"
    journal.createdAt = Date()
    journal.location = "Paris, France"
    journal.content = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."
    return journal
  }(),
]
