# 🎬 FilmFindr 

**FilmFindr** is a modern iOS application designed for movie enthusiasts to explore trending movies, add personal favorites, and view detailed information about a film. The app was built as a learning experience in swift's and UIKit latest technologies focusing on:
programmatic UI, fluid animations, and local data persistence.


## 🚀 Features

* **Dynamic Home Screen**: A complex layout using `UICollectionViewCompositionalLayout` featuring a Hero section, horizontal carousels for Trending/Popular movies, and vertical lists.
* **Favorites Manager**: A "TableView-style" favorites list implemented with `UICollectionView` and modern **List Configurations**.
* **Swipe to Delete**: Native iOS swipe-to-delete interaction for easy list management.
* **Local Persistence**: Favorites are saved and retrieved using a custom `PersistenceManager` wrapper around `UserDefaults`.
* **Image Loading**: A custom `UIImageView` extension that handles:
    * Asynchronous downloading using **Async/Await**.
    * Task cancellation to prevent flickering during cell reuse.
* **Empty State Handling**: Custom designed `EmptyStateView` to guide users when no favorites are present.

## 🛠 Tech Stack

* **Language**: Swift 5.10+
* **UI Framework**: UIKit (100% Programmatic UI / No Storyboards)
* **Architecture**: MVC
* **Data Management**: `UICollectionViewDiffableDataSource` for thread-safe, animated UI updates.
* **Concurrency**: Swift Concurrency (**Async/Await**) for networking and image processing.
* **API**: [The Movie Database (TMDB) API](https://www.themoviedb.org/documentation/api)

## 🏹 Key Technical Highlights

### 1. Programmatic Layouts
The app avoids Storyboards entirely to ensure version control and full control over the view hierarchy. It uses **Auto Layout** with anchors to build responsive interfaces.

### 2. Diffable Data Sources
Instead of `UICollectionViewDataSource` methods, I've opted to use `NSDiffableDataSourceSnapshot`. This ensures smooth, crash-free animations when favorites are added or removed.

### 3. DRY Principles (Don't Repeat Yourself)
**Swift Extensions** (for `UIImageView` and `UIView`) and reusable components, avoiding duplication of code.

## 📸 Screenshots And Gifs

| Home Screen | Movie Details | Favorites List | Empty State |
| :---: | :---: | :---: | :---: |
| <img width="240" alt="Home" src="https://github.com/user-attachments/assets/c169bd1f-10f9-4819-886c-9d345d1c4375" /> | <img width="240" alt="Details" src="https://github.com/user-attachments/assets/b524707d-5fe4-4e0b-84ba-1da68ed8967b" /> | <img width="240" alt="Favorites" src="https://github.com/user-attachments/assets/ffdf547e-b046-4c5a-8df7-cddf988e7f47" /> | <img width="240" alt="EmptyState" src="https://github.com/user-attachments/assets/ca0760f6-716d-4bdc-a598-6165155317d6" /> |


| Home Screen | Movie Details | Favorites List | Empty State |
| :---: | :---: | :---: | :---: |
| ![homeGif](https://github.com/user-attachments/assets/d639b361-7c29-49a1-9423-bb5873252929) |![moviedetailgif](https://github.com/user-attachments/assets/943e737b-01e8-4586-bd8a-3153f4c351ab) | ![favoritesgif](https://github.com/user-attachments/assets/039b3f97-2df0-4e76-aaf4-175763233531) | ![emptygif](https://github.com/user-attachments/assets/760aaadc-f36c-4e2d-a391-77aad7fe67c9)

## 🏁 Getting Started

### Prerequisites
* Xcode 15.0+
* iOS 17.0+
* A TMDB API Key

### Installation
1. Clone the repository
2. Create a Secrets.plist file in project scope folder
* Add a pair Key called `TMDB_BEARER_TOKEN`
* The value to be added is your TMDB API Key
3. Build and run the app.
