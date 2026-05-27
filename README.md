# HealingYuk Mobile App

A professional travel and open-trip marketplace mobile application built with Flutter. HealingYuk allows users to discover, search, and book exciting travel packages from various destinations across Indonesia.

## Overview

HealingYuk is a modern Flutter application developed by PT Karya Developer Indonesia. The app provides a comprehensive platform for travelers to browse travel packages, manage bookings, and access personalized travel recommendations. Built with a clean architecture pattern and following Flutter best practices, the application ensures scalability, maintainability, and optimal performance.

## Features

- User Authentication: Secure login and registration with JWT token management
- Trip Discovery: Browse featured trips and explore destinations
- Advanced Search: Filter trips by destination, date, and price range
- Trip Details: View comprehensive trip information, itineraries, and pricing
- Booking Management: Create, view, and manage travel bookings
- User Profile: Manage user information and preferences
- Real-time Synchronization: Auto-refresh token and session management
- Responsive UI: Adaptive design for all device sizes
- Offline Support: Cached data for improved user experience
- App Information: About section with developer information

## Architecture

HealingYuk follows the Clean Architecture pattern with feature-based folder structure:

```
lib/
├── core/
│   ├── constants/           # App-wide constants (colors, spacing, strings)
│   ├── errors/              # Error classes and exceptions
│   ├── network/             # API client, interceptors, and network setup
│   ├── router/              # GoRouter configuration and route definitions
│   ├── services/            # Service layer (session, dependency injection)
│   └── widgets/             # Reusable UI components (buttons, dialogs, etc.)
├── features/
│   ├── auth/                # Authentication feature (domain/data/presentation)
│   ├── home/                # Home feature
│   ├── trip/                # Trip listing and details feature
│   ├── search/              # Search feature
│   ├── booking/             # Booking management feature
│   └── profile/             # User profile feature
└── main.dart                # Application entry point
```

Each feature follows the MVVM/Domain-Driven pattern:
- Domain: Business logic and entities
- Data: Data sources and repository implementations
- Presentation: UI screens and providers

## API Endpoints

The application integrates with a native PHP backend API at https://api-trip.karyadeveloperindonesia.com/api/v1

### Authentication Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| POST | /auth/login | User login |
| POST | /auth/register | User registration |
| POST | /auth/refresh | Refresh JWT token |

### Trip Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | /trips | Get all trips (paginated) |
| GET | /trips/{id} | Get trip details |
| GET | /trips/featured | Get featured trips |
| GET | /trips/search | Search trips with filters |
| GET | /categories | Get trip categories |
| GET | /destinations | Get all destinations |

### Booking Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | /bookings | Get user bookings |
| POST | /bookings | Create new booking |
| DELETE | /bookings/{id} | Cancel booking |

### User Endpoints

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET | /me | Get current user profile |
| PUT | /me | Update user profile |

## Dependencies

### State Management
- provider (^6.1.2): ChangeNotifier-based state management for reactive UI updates

### HTTP & Networking
- dio (^5.4.3+1): Robust HTTP client with interceptor support for request/response handling
- Custom ApiClient wrapper for centralized API management
- AuthInterceptor for automatic JWT token refresh
- LoggingInterceptor for debugging

### Dependency Injection
- get_it (^7.7.0): Service locator pattern for dependency injection throughout the app

### Local Storage
- shared_preferences (^2.2.3): Key-value storage for app preferences
- flutter_secure_storage (^9.2.2): Secure storage for sensitive data (tokens, credentials)

### Navigation
- go_router (^14.2.7): Modern declarative routing with nested navigation and deep linking support

### UI & Styling
- google_fonts (^6.2.1): Google Fonts integration (using Poppins)
- icons_plus (^5.0.0): Comprehensive icon library
- cached_network_image (^3.3.1): Network image caching and lazy loading
- shimmer (^3.0.0): Shimmer loading placeholders for smooth UX

### Utilities
- dartz (^0.10.1): Functional programming utilities (Either type for error handling)
- equatable (^2.0.5): Simplified equality comparison for model objects
- intl (^0.19.0): Internationalization and date/time formatting

### Development
- flutter_lints (^4.0.0): Recommended linter rules for Flutter
- flutter_launcher_icons (^0.13.1): Automated app icon generation for all platform densities

## Project Structure Detail

### Core Module

Constants (core/constants/)
- app_colors.dart: Primary, secondary, and semantic colors
- app_spacing.dart: Consistent spacing scale
- app_strings.dart: Localized and static strings

Network (core/network/)
- api_client.dart: Centralized HTTP client using Dio
- interceptors/: Custom request/response interceptors

Services (core/services/)
- service_locator.dart: GetIt configuration and dependency registration
- session_service.dart: User session and token management

Router (core/router/)
- app_router.dart: GoRouter configuration with authentication guards

Widgets (core/widgets/)
- primary_button.dart: Reusable primary button
- custom_text_field.dart: Enhanced text input
- app_dialog.dart: Customizable dialog widget
- trip_card.dart: Trip list item component
- main_shell.dart: Bottom navigation shell layout

### Features

Each feature is organized as:
- domain/entities/: Data models and business logic contracts
- domain/usecases/: Feature-specific use cases
- data/datasources/: API and local data sources
- data/repositories/: Repository implementations
- presentation/providers/: State management (ChangeNotifier)
- presentation/screens/: UI screens
- presentation/widgets/: Feature-specific components

## Installation & Setup

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart 3.0.0 or higher
- iOS 12.0+ (for iOS deployment)
- Android SDK 21+ (for Android deployment)

### Steps

1. Clone the repository:
```bash
git clone <repository-url>
cd HealingYuk/mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate app launcher icons:
```bash
flutter pub run flutter_launcher_icons
```

4. Run code generation (if using build_runner):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Running the App

### Development

Run on default device:
```bash
flutter run
```

Run on specific device:
```bash
flutter run -d <device-id>
```

### Release Build

Build for Android:
```bash
flutter build apk --release
```

Build for iOS:
```bash
flutter build ios --release
```

## Authentication Flow

The app implements JWT-based authentication with automatic token refresh:

1. User logs in with email and password
2. Backend returns access token and refresh token
3. Access token is securely stored in flutter_secure_storage
4. AuthInterceptor automatically includes token in API requests
5. On token expiration, AuthInterceptor calls refresh endpoint
6. New token is obtained and request is retried
7. User is redirected to login only if refresh fails

## Error Handling

The application uses the Either type from dartz package for robust error handling:

- All data operations return Either<Failure, Success>
- Failures contain error type and message
- UI layer handles failures with appropriate user feedback
- AppDialog widget provides consistent error/warning/success messages

## State Management Pattern

The app uses Provider (ChangeNotifier) for state management:

- Each feature has a dedicated Provider
- Providers handle business logic and state updates
- Consumers listen to state changes and rebuild UI
- AuthProvider manages global authentication state
- GoRouter watches AuthProvider for navigation guards

## Build & Distribution

The app includes automated launcher icon generation supporting:
- All Android densities (hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi)
- All iOS sizes (from 29x29 to 1024x1024)
- Adaptive icons for Android 8.0+

## Performance Considerations

- Lazy loading of images with cached_network_image
- Shimmer loading placeholders prevent layout jank
- Efficient list rendering with proper key usage
- Minimal rebuilds through Provider widget optimization
- Secure token storage with flutter_secure_storage

## Testing

Run all tests:
```bash
flutter test
```

Generate coverage report:
```bash
flutter test --coverage
```

## Troubleshooting

Common Issues

1. API Connection Error
   - Verify backend server is running
   - Check internet connectivity
   - Review API base URL in api_client.dart

2. Authentication Failing
   - Ensure credentials are correct
   - Check token expiration
   - Review SessionService configuration

3. UI Layout Issues
   - Clear flutter build cache: flutter clean
   - Rebuild: flutter pub get && flutter run

## Developer Information

Developed by PT Karya Developer Indonesia

- Website: https://karyadeveloperindonesia.com
- Email: support@karyadeveloperindonesia.com

## Version

Current Version: 1.0.0 (Build 1)

## License

Proprietary. All rights reserved by PT Karya Developer Indonesia.

## Support

For technical support or bug reports, please contact:
- Email: support@karyadeveloperindonesia.com

---

Last Updated: May 2026
