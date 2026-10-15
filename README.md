# Ecommerce Huma Volve

Flutter e-commerce app built step by step with a real REST API.

## Day 1: Auth Feature

- Login and Sign Up (the account is created, then logged in automatically)
- Token storage with `shared_preferences`
- Splash screen opens Home if a token exists, otherwise Login
- Logout clears the saved tokens

## Day 2: Home Feature (API + State Management)

- Products and categories loaded from the API
- State management with **Cubit** (`flutter_bloc`)
- Loading, Error (with Retry) and Success states
- Category filter and debounced search

## Day 3: Clean Architecture (Auth and Home)

Each feature is split into three layers, and dependencies only point inward:

- **domain**: entities, abstract repositories, and use cases (pure Dart, no Flutter or http)
- **data**: models, remote/local data sources, and repository implementations
- **presentation**: cubits, screens, and widgets

Other changes:

- Errors are handled with `Either<Failure, T>` (`dartz`)
- Dependency injection with `get_it` (`lib/core/injection.dart`)
- The old `AuthService` and `HomeService` were removed

## API

Base URL: `https://api.escuelajs.co/api/v1` ([docs](https://api.escuelajs.co/docs))

| Feature | Method | Endpoint |
|---|---|---|
| Login | POST | `/auth/login` |
| Register | POST | `/users` |
| Categories | GET | `/categories` |
| Products | GET | `/products` (supports `categoryId`, `title`, `offset`, `limit`) |

Test account: `john@mail.com` / `changeme`

## Project Structure

    lib/
    ├── core/                  # theme, shared widgets, errors, injection.dart
    └── features/
        ├── auth/
        │   ├── data/          # models, datasources, repository impl
        │   ├── domain/        # repository, use cases
        │   └── presentation/  # cubit, screens
        ├── home/
        │   ├── data/
        │   ├── domain/        # entities, repository, use cases
        │   └── presentation/  # cubit, screens, widgets, mappers
        ├── splash/
        └── profile/

## Run

    flutter pub get
    flutter run -d chrome

## Packages

http, shared_preferences, flutter_bloc, equatable, get_it, dartz

## Day 4 – Implement Pagination in the Home Feature

### Task Overview
Implemented pagination in the Home feature to load products incrementally as the user scrolls.

### Features
- Load products in pages.
- Fetch more products when scrolling near the bottom.
- Append new products to the existing list.
- Prevent duplicate pagination requests.
- Handle loading and error states.
- Reload products when searching or selecting a category.

### Technologies Used
- Flutter
- Dart
- Cubit / Flutter Bloc
- REST API

### Git Branch
`day-4-pagination`

### Status
Completed

