# base_clean_architecture

# Clean Architecture Flutter Template

A comprehensive Flutter template implementing Clean Architecture principles with BLoC pattern for state management. This template provides a solid foundation for building scalable, maintainable, and testable Flutter applications.

## 🏗️ Architecture Overview

This project follows Clean Architecture principles with the following layers:

```
lib/
├── core/                    # Core functionality shared across the app
│   ├── constants/          # App-wide constants
│   ├── di/                 # Dependency injection setup
│   ├── error/              # Error handling (failures & exceptions)
│   ├── network/            # Network configuration & utilities
│   ├── router/             # App routing configuration
│   ├── theme/              # App theming
│   ├── utils/              # Utility functions & extensions
│   └── widgets/            # Reusable core widgets
├── features/               # Feature modules
│   └── auth/               # Authentication feature example
│       ├── data/           # Data layer
│       │   ├── datasources/    # Remote & local data sources
│       │   ├── models/         # Data models
│       │   └── repositories/   # Repository implementations
│       ├── domain/         # Domain layer
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository interfaces
│       │   └── usecases/       # Business logic
│       └── presentation/   # Presentation layer
│           ├── bloc/           # BLoC state management
│           ├── pages/          # UI pages
│           └── widgets/        # Feature-specific widgets
├── shared/                 # Shared UI components
│   └── presentation/       # Shared pages & widgets
└── main.dart              # App entry point
```

## 🚀 Features

### Core Features
- ✅ Clean Architecture implementation
- ✅ BLoC pattern for state management
- ✅ Dependency injection with GetIt & Injectable
- ✅ Network layer with Dio & Retrofit
- ✅ Local storage with Hive & SharedPreferences
- ✅ Routing with GoRouter
- ✅ Error handling & validation
- ✅ Theme management (Light/Dark mode)
- ✅ Responsive design utilities
- ✅ Code generation ready

### Authentication Feature (Example)
- ✅ Login/Register functionality
- ✅ Token management
- ✅ User profile management
- ✅ Password reset
- ✅ Local user caching

### Development Tools
- ✅ Linting with very_good_analysis
- ✅ Code generation with build_runner
- ✅ Testing setup with bloc_test & mocktail
- ✅ Environment configuration

## 📦 Dependencies

### Production Dependencies
```yaml
# State Management
flutter_bloc: ^8.1.6
bloc: ^8.1.4

# Dependency Injection
get_it: ^8.0.0
injectable: ^2.4.4

# Network
dio: ^5.7.0
retrofit: ^4.4.1
json_annotation: ^4.9.0

# Storage
shared_preferences: ^2.3.2
hive: ^2.2.3
hive_flutter: ^1.1.0

# Utilities
equatable: ^2.0.5
dartz: ^0.10.1
freezed_annotation: ^2.4.4
connectivity_plus: ^6.0.5
logger: ^2.4.0

# Navigation
go_router: ^14.2.7

# Environment
flutter_dotenv: ^5.1.0
```

### Development Dependencies
```yaml
# Code Generation
build_runner: ^2.4.13
injectable_generator: ^2.6.2
retrofit_generator: ^9.1.2
json_serializable: ^6.8.0
freezed: ^2.5.7
hive_generator: ^2.0.1

# Testing
bloc_test: ^9.1.7
mocktail: ^1.0.4

# Linting
very_good_analysis: ^6.0.0
```

## 🛠️ Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd base_clean_architecture
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4. Environment Configuration (Optional)
Create a `.env` file in the root directory:
```env
BASE_URL=https://your-api-url.com/v1/
API_KEY=your_api_key_here
DEBUG_MODE=true
```

### 5. Run the App
```bash
flutter run
```

## 🏃‍♂️ Getting Started

### Adding a New Feature

1. **Create Feature Structure**
```bash
mkdir -p lib/features/your_feature/{data,domain,presentation}
mkdir -p lib/features/your_feature/data/{datasources,models,repositories}
mkdir -p lib/features/your_feature/domain/{entities,repositories,usecases}
mkdir -p lib/features/your_feature/presentation/{bloc,pages,widgets}
```

2. **Define Domain Layer**
   - Create entities in `domain/entities/`
   - Define repository interfaces in `domain/repositories/`
   - Implement use cases in `domain/usecases/`

3. **Implement Data Layer**
   - Create models in `data/models/`
   - Implement data sources in `data/datasources/`
   - Implement repositories in `data/repositories/`

4. **Build Presentation Layer**
   - Create BLoC in `presentation/bloc/`
   - Build pages in `presentation/pages/`
   - Create widgets in `presentation/widgets/`

5. **Register Dependencies**
   - Add dependencies in `core/di/injection_container.dart`
   - Run code generation: `flutter packages pub run build_runner build`

### Code Generation Commands

```bash
# Generate all files
flutter packages pub run build_runner build --delete-conflicting-outputs

# Watch for changes
flutter packages pub run build_runner watch --delete-conflicting-outputs

# Clean generated files
flutter packages pub run build_runner clean
```

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/auth/domain/usecases/login_usecase_test.dart
```

### Test Structure
```
test/
├── core/                   # Core functionality tests
├── features/               # Feature tests
│   └── auth/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── helpers/                # Test helpers & mocks
```

## 📱 Project Structure Explanation

### Core Layer
- **constants/**: App-wide constants and configuration
- **di/**: Dependency injection setup using GetIt & Injectable
- **error/**: Centralized error handling with custom exceptions and failures
- **network/**: Network configuration, interceptors, and utilities
- **router/**: App navigation setup with GoRouter
- **theme/**: App theming for light and dark modes
- **utils/**: Utility functions, extensions, and validators
- **widgets/**: Reusable UI components

### Feature Layer (Example: Auth)
- **Domain**: Business logic and rules
  - **entities/**: Core business objects
  - **repositories/**: Abstract repository interfaces
  - **usecases/**: Business use cases
- **Data**: Data handling and external APIs
  - **datasources/**: Remote and local data sources
  - **models/**: Data models with JSON serialization
  - **repositories/**: Repository implementations
- **Presentation**: UI and state management
  - **bloc/**: BLoC state management
  - **pages/**: UI screens
  - **widgets/**: Feature-specific widgets

## 🎨 Theming

The app supports both light and dark themes with Material Design 3. Themes are configured in `core/theme/app_theme.dart`.

### Customizing Themes
```dart
// Update colors in AppTheme class
static const Color _primaryColor = Color(0xFF2196F3);
static const Color _secondaryColor = Color(0xFF03DAC6);
```

## 🌐 Network Configuration

Network layer is configured with Dio and includes:
- Request/Response interceptors
- Error handling
- Authentication token management
- Retry logic
- Logging

### API Configuration
```dart
// Update base URL in app_constants.dart
static const String defaultBaseUrl = 'https://your-api.com/';
```

## 📝 Code Generation

This template uses code generation for:
- **Injectable**: Dependency injection
- **Retrofit**: API client generation
- **JSON Serializable**: Model serialization
- **Freezed**: Immutable classes (if needed)
- **Hive**: Local storage models

## 🔧 Customization

### Adding New Dependencies
1. Add to `pubspec.yaml`
2. Run `flutter pub get`
3. If it requires code generation, add to dev_dependencies and run build_runner

### Changing App Name & Package
1. Update `pubspec.yaml`
2. Update Android package in `android/app/build.gradle`
3. Update iOS bundle identifier in `ios/Runner.xcodeproj`

## 📚 Best Practices

1. **Follow Clean Architecture principles**
2. **Use BLoC for state management**
3. **Write tests for business logic**
4. **Use dependency injection**
5. **Handle errors gracefully**
6. **Keep UI logic separate from business logic**
7. **Use code generation for repetitive code**
8. **Follow consistent naming conventions**

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Run linting: `flutter analyze`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

If you have questions or need help:
1. Check the documentation
2. Look at the example implementation in the auth feature
3. Create an issue in the repository

---

**Happy Coding! 🚀**

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
