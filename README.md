# Ecommerce Huma Volve

Flutter e-commerce app. **Day 1 task:** implement the Auth feature using the API.

## Auth Feature

- **Login** with email and password
- **Sign Up**: creates the account, then logs in automatically
- **Token storage**: the `access_token` and `refresh_token` are saved with `shared_preferences`
- **Splash screen**: opens the Home screen if a token is saved, otherwise the Login screen
- **Logout**: clears the saved tokens and returns to the Login screen
- Form validation and loading state on the buttons

## API

Base URL: `https://api.escuelajs.co/api/v1` ([docs](https://api.escuelajs.co/docs))

| Action | Method | Endpoint |
|---|---|---|
| Login | POST | `/auth/login` |
| Register | POST | `/users` |
| Profile | GET | `/auth/profile` |

Test account: `john@mail.com` / `changeme`

## Project Structure

```
lib/
├── core/                      # theme, shared widgets
└── features/
    ├── auth/
    │   ├── login/screens/
    │   ├── sign_up/screens/
    │   └── services/auth_service.dart
    ├── splash/
    ├── home/
    └── profile/
```

## Run

```bash
flutter pub get
flutter run -d chrome
```

## Packages

- [http](https://pub.dev/packages/http)
- [shared_preferences](https://pub.dev/packages/shared_preferences)