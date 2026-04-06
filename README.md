# Gallery App

## Technologies used:
Swit, UIKit, Combine, CoreData

## Contact Information

**Developer:** Dmitry Divin  
**GitHub:** [[github.com/dmitrydivin](https://github.com/dmitrydivin)](https://github.com/DDivin1)
**Linkedin:** https://www.linkedin.com/in/dmitry-divin-6971203a9/

---

## About the Project

**Gallery App** is an iOS application for browsing images from Unsplash. Users can browse the gallery, like images, and save them to favorites.

### Key Features

| Feature | Description |
|---------|-------------|
| **Infinite Gallery** | Paginated loading (30 photos per page) with automatic loading on scroll |
| **Favorites** | Add/remove photos with persistence using Core Data |
| **Detail View** | View photos with description, likes |
| **Swipe Navigation** | Swipe between photos in detail mode |
| **Visual Indicators** | Heart icon for liked images, star icon for favorites images |
| **Localization** | Russian and English language support |

---

## Architecture

### MVVM + Coordinator

                    ┌─────────────────┐
                    │  AppCoordinator │
                    └────────┬────────┘
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
           ▼                 ▼                 ▼
    ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
    │   Gallery   │   │   Detail    │   │  Favorites  │
    │   Module    │   │   Module    │   │   Module    │
    ├─────────────┤   ├─────────────┤   ├─────────────┤
    │ • View      │   │ • View      │   │ • View      │
    │ • ViewModel │   │ • ViewModel │   │ • ViewModel │
    │ • Assembly  │   │ • Assembly  │   │ • Assembly  │
    └─────────────┘   └─────────────┘   └─────────────┘

### Technology Stack

| Component | Technology |
|-----------|------------|
| **UI** | UIKit |
| **Architecture** | MVVM + Coordinator |
| **Reactivity** | Combine |
| **Persistence** | Core Data |
| **Networking** | URLSession |
| **Caching** | Kingfisher |
| **Localization** | .strings files |
| **Linter** | SwiftLint |
| **Minimum Version** | iOS 17.0 |

### Design Patterns

- **Coordinator** — navigation between screens
- **Factory (Assembly)** — module creation with DI
- **Observer** — Combine publishers
- **Delegate** — UICollectionView, UIScrollView
- **Repository** — IFavoritesStorage abstraction

---

## Project Structure

```text
GalleryApp/
├── App+coordinator/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppCoordinator.swift
│
├── Modules/
│   ├── ImageGallery/
│   │   ├── View/
│   │   ├── ViewModel/
│   │   └── Assembly/
│   │
│   ├── ImageDetail/
│   │   ├── View/
│   │   ├── ViewModel/
│   │   └── Assembly/
│   │
│   └── Favorites/
│       ├── View/
│       ├── ViewModel/
│       └── Assembly/
│
├── Core/
│   ├── Services/
│   │   ├── NetworkService.swift
│   │   └── FavoritesStorage.swift
│   │
│   └── Manager/
│       └── CoreDataManager.swift
│
├── Common/
│   ├── Constants/
│   │   ├── AppConstants.swift
│   │   ├── ImageGalleryViewControllerConstants.swift
│   │   ├── ImageDetailsConstants.swift
│   │   ├── ImageCellConstants.swift
│   │   └── FavoritesScreenConstants.swift
│   │
│   ├── Models/
│   │   └── Images.swift
│   │
│   └── Extensions/
│       └── Strings+extensions.swift
│
├── UI/
│   └── Cells/
│       └── ImageGalleryCell.swift
│
├── Resources/
│   ├── Assets.xcassets
│   ├── Localizable.strings
│   └── GalleryDataModel.xcdatamodeld
│
└── GalleryAppTests/
    ├── Mocks/
    │   ├── NetworkServiceStub.swift
    │   └── FavoritesStorageMock.swift
    └── UnitTests/
        └── GalleryAppTest.swift
```

## Setup & Configuration

### Requirements
- Xcode 15.0+
- iOS 17.0+
- Unsplash API key
