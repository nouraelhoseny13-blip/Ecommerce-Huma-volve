# Ecommerce Huma Volve

Flutter e-commerce app built step by step with a real REST API.

## Day 1: Auth Feature

- **Login** with email and password
- **Sign Up**: creates the account, then logs in automatically
- **Token storage**: `access_token` and `refresh_token` saved with `shared_preferences`
- **Splash screen**: opens Home if a token is saved, otherwise Login
- **Logout**: clears the saved tokens and returns to Login

## Day 2: Home Feature (API + State Management)

- Products and categories are loaded from the API
- State management with **Cubit** (`flutter_bloc`)
- Three UI states: **Loading**, **Error** (with Retry button), and **Success**
- **Category filter**: tapping a category reloads its products
- **Search**: debounced search by product title
- Image loading and error placeholders
- Empty state ("No products found")

## API

Base URL: `https://api.escuelajs.co/api/v1` ([docs](https://api.escuelajs.co/docs))

| Feature | Method | Endpoint |
|---|---|---|
| Login | POST | `/auth/login` |
| Register | POST | `/users` |
| Profile | GET | `/auth/profile` |
| Categories | GET | `/categories` |
| Products | GET | `/products` (supports `categoryId`, `title`, `offset`, `limit`) |

Test account: `john@mail.com` / `changeme`

## Project Structure

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Packages

- [http](https://pub.dev/packages/http)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- [equatable](https://pub.dev/packages/equatable)

