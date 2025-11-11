# Journey
 
Original App Design Project - README Template

===



## Journey



## Table of Contents



1. [Overview](#Overview)

2. [Product Spec](#Product-Spec)

3. [Wireframes](#Wireframes)

4. [Schema](#Schema)



## Overview



### Description

Journey is a travel journal app that allows users to document their travel experiences by combining photos, notes, maps, and location data. Users can create rich journal entries with titles, descriptions, images, dates, and GPS locations. The app provides a dashboard view to browse all journal entries, search functionality, and sorting capabilities. Journey uses Realm/SwiftData for local data storage, making it easy to capture and preserve travel memories.



### App Evaluation

- **Category:** Travel / Personal

- **Mobile:** Yes, iOS mobile application

- **Story:** Journey helps travelers capture and preserve their travel memories through rich multimedia journal entries. It tells the story of adventures, experiences, and moments captured through photos, notes, and locations.

- **Market:** Travelers, adventure seekers, and anyone who wants to document their journeys and experiences

- **Habit:** Occasional use - primarily used during and after travel experiences

- **Scope:** Narrow to medium scope - focused on journal creation, viewing, and organization with core features for travel documentation



## Product Spec



### 1. User Stories (Required and Optional)



**Required Must-have Stories**

* [User can create a journal entry with title, description, image upload, date, location, and GPS location]
* [User can view a dashboard containing a list of journal cards]
* [User can search journals by title]
* [User can sort journals by date]
* [User can view a journal entry with all its details]
* [User can edit an existing journal entry]
* [User can delete a journal entry]



**Optional Nice-to-have Stories**

* [User can sync data to Back4App remote database]
* [User can create and manage user profiles]
* [User can add tags to journal entries]
* [User can sort journals by tags]
* [User can view journals on a map view]
* [User can mark journals as favorites]
* [User can use Apple AI to clean up and improve journal entry text]



### 2. Screen Archetypes

- [ ] [**Dashboard Screen**]
  * Journal Card displaying:
    - Title Text
    - Image
    - Date Created
  * Navigation Bar with:
    - Create Journal Button
    - Search bar
    - Sort Button
  * Required User Features: User can view list of journals, search by title, sort by date, and navigate to create/view journal

- [ ] [**Journal Editor Screen**]
  * Edit functionality
  * View functionality
  * Upload Image button
  * Save Journal button
  * Delete Journal button
  * Required User Features: User can create, edit, view, and delete journal entries with title, description, image, date, location, and GPS location



### 3. Navigation



**Tab Navigation** (Tab to Screen)

- N/A (Single-screen navigation flow)



**Flow Navigation** (Screen to Screen)

- [ ] [**App Logo / Launch Screen**]
  * Leads to [**Dashboard Screen**]

- [ ] [**Dashboard Screen**]
  * Leads to [**Journal Editor Screen**] (when creating new journal or tapping on existing journal)
  * Leads to [**Search/Sort View**] (when using search or sort functionality)

- [ ] [**Journal Editor Screen**]
  * Leads to [**Image Upload/View Screen**] (when uploading or viewing images)
  * Returns to [**Dashboard Screen**] (after saving or canceling) 





## Wireframes

- Dashboard Screen  
  ![Dashboard wireframe](wireframes/dashboard_wireframe.png)

- Journal Editor Screen  
  ![Journal editor wireframe](wireframes/journal_editor_wireframe.png)

- Map View Screen  
  ![Map view wireframe](wireframes/map_view_wireframe.png)

### [BONUS] Digital Wireframes & Mockups

- Generated using Python and Pillow at iPhone 13 resolution (1170×2532) with updated typography and layout for Journey branding.

### [BONUS] Interactive Prototype



## Schema 





### Models

**Journal**

| Property      | Type    | Description                                  |
|---------------|---------|----------------------------------------------|
| id            | String  | unique id for the journal entry (default field) |
| title         | String  | title of the journal entry                   |
| description   | String  | main content/description of the journal      |
| image         | Data    | uploaded image data                          |
| date          | Date    | date when the journal was created            |
| location      | String  | location name/address                        |
| gpsLatitude   | Double  | GPS latitude coordinate                      |
| gpsLongitude  | Double  | GPS longitude coordinate                     |
| createdAt     | Date    | timestamp when entry was created             |
| updatedAt     | Date    | timestamp when entry was last updated        |

**Optional Models (for future features)**

**Tag**

| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| id       | String | unique id for the tag                        |
| name     | String | tag name                                     |

**User** (if Back4App integration is added)

| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| id       | String | unique id for the user                      |
| username | String | user's username                              |
| email    | String | user's email address                         |                          





### Networking

**Local Storage (Primary)**
- Using Realm/SwiftData for local data persistence
- No network requests required for core functionality

**Optional: Back4App Integration (Future Feature)**

- [ ] [**Dashboard Screen**]
  * `[GET] /parse/classes/Journal` - Retrieve all journal entries for the user
  * `[GET] /parse/classes/Journal?where={"title":{"$regex":"SEARCH_TERM"}}` - Search journals by title

- [ ] [**Journal Editor Screen**]
  * `[POST] /parse/classes/Journal` - Create a new journal entry
  * `[PUT] /parse/classes/Journal/{objectId}` - Update an existing journal entry
  * `[DELETE] /parse/classes/Journal/{objectId}` - Delete a journal entry

- [ ] [**User Authentication**] (if profiles are added)
  * `[POST] /parse/users` - Register a new user
  * `[POST] /parse/login` - Login user
  * `[GET] /parse/users/me` - Get current user information