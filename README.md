# MovieApp

A simple iOS movie browsing application built using **Swift**, **Objective-C**, **Storyboard**, **SwiftUI**, **CoreData**, and **MVVM** architecture.  
The app uses the **OMDb API** for fetching movies.

---

## Features

### User Authentication
- Sign Up (Objective-C + Storyboard)
- Sign In (Swift + Storyboard)
- Password hashing using **SHA-256 (CryptoKit)**
- Authentication data stored in **CoreData**

### Movie Browsing
- Movie listing using OMDb API with **URLRequest**
- Image loading using **Kingfisher** (via Swift Package Manager)
- Pagination (10 movies per page)
- Real-time search with loading indicator
- Offline caching using CoreData

### Favorites
- Add/remove movies from favorites  
- When user adds **10 favorites**, show message:  
  **"Wow, you are a movie enthusiast!"**

### Screens & Technologies
| Screen | Technology |
|--------|------------|
| Sign In | Swift + Storyboard |
| Sign Up | Objective-C + Storyboard |
| Home (Tabs) | Swift + SwiftUI |
| Movie List | SwiftUI |
| Favorites | SwiftUI |
| Movie Detail | SwiftUI |

---

## Architecture (MVVM + Repository Pattern)

