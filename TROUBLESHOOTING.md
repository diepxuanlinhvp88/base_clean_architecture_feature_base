# Troubleshooting Guide

## Common Issues and Solutions

### 1. Kotlin Compilation Error (Android)

**Error:**
```
e: Daemon compilation failed: null
java.lang.Exception
Could not close incremental caches...
```

**Solution:**
```bash
# Clean build cache
flutter clean

# Remove Android build folder
rm -rf android/.gradle
rm -rf android/app/build

# Rebuild
flutter pub get
flutter run
```

**Alternative for Windows:**
```cmd
flutter clean
rmdir /s android\.gradle
rmdir /s android\app\build
flutter pub get
flutter run
```

### 2. DotEnv NotInitializedError

**Error:**
```
Error initializing app: Instance of 'NotInitializedError'
DotEnv.env (package:flutter_dotenv/src/dotenv.dart:41:7)
```

**Solution:**
1. Create `.env` file in project root:
```env
# Environment Configuration
BASE_URL=https://api.example.com/v1/
API_KEY=your_api_key_here
DEBUG_MODE=true
```

2. Or run setup script:
```bash
# Linux/Mac
./scripts/setup.sh

# Windows
scripts\setup.bat
```

### 3. Build Runner Issues

**Error:**
```
[SEVERE] Failed after X.Xs
```

**Solution:**
```bash
# Clean generated files
flutter packages pub run build_runner clean

# Regenerate
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 4. Dependency Conflicts

**Error:**
```
version solving failed
```

**Solution:**
```bash
# Clean dependencies
flutter clean
rm pubspec.lock

# Reinstall
flutter pub get
```

### 5. FVM Issues

If using FVM (Flutter Version Management):

```bash
# Use FVM commands instead of flutter
fvm flutter clean
fvm flutter pub get
fvm flutter run
```

### 6. Android Gradle Issues

**Error:**
```
Gradle build failed
```

**Solutions:**

1. **Update Gradle Wrapper:**
```bash
cd android
./gradlew wrapper --gradle-version=8.0
```

2. **Clean Gradle Cache:**
```bash
cd android
./gradlew clean
```

3. **Check Java Version:**
```bash
java -version
# Should be Java 11 or higher
```

### 7. iOS Build Issues

**Error:**
```
CocoaPods related errors
```

**Solution:**
```bash
cd ios
rm Podfile.lock
rm -rf Pods
pod install --repo-update
```

### 8. Web Build Issues

**Error:**
```
Web compilation failed
```

**Solution:**
```bash
# Clean web build
flutter clean
flutter pub get

# Build for web
flutter build web
```

### 9. Hot Reload Not Working

**Solutions:**

1. **Restart Hot Reload:**
   - Press `r` in terminal
   - Or `R` for hot restart

2. **Check File Watchers:**
```bash
# Increase file watchers (Linux)
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### 10. IDE Issues

**VS Code:**
1. Install Flutter extension
2. Run `Flutter: Reload Window`
3. Check Flutter SDK path in settings

**Android Studio:**
1. Invalidate Caches and Restart
2. Check Flutter and Dart plugins
3. Sync Project with Gradle Files

## Performance Issues

### 1. Slow Build Times

**Solutions:**
```bash
# Enable parallel builds (Android)
# Add to android/gradle.properties:
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configureondemand=true

# Use build cache
flutter build apk --build-shared-library
```

### 2. Large App Size

**Solutions:**
```bash
# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=debug-info/

# Enable R8 (Android)
# Add to android/app/build.gradle:
android {
    buildTypes {
        release {
            minifyEnabled true
            useProguard true
        }
    }
}
```

## Development Tips

### 1. Debugging

```bash
# Run with verbose logging
flutter run --verbose

# Debug specific device
flutter run -d <device-id>

# Profile mode
flutter run --profile
```

### 2. Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### 3. Code Quality

```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Fix common issues
dart fix --apply
```

## Environment Setup

### 1. Flutter Doctor

```bash
flutter doctor -v
```

Check all items are ✓ (green checkmarks)

### 2. Required Tools

- **Flutter SDK:** Latest stable version
- **Dart SDK:** Comes with Flutter
- **Android Studio:** For Android development
- **Xcode:** For iOS development (Mac only)
- **VS Code:** Recommended editor

### 3. Environment Variables

Add to your shell profile (`.bashrc`, `.zshrc`, etc.):

```bash
export FLUTTER_ROOT=/path/to/flutter
export PATH=$PATH:$FLUTTER_ROOT/bin
export ANDROID_HOME=/path/to/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

## Getting Help

1. **Check Flutter Documentation:** https://flutter.dev/docs
2. **Search Flutter Issues:** https://github.com/flutter/flutter/issues
3. **Stack Overflow:** Tag with `flutter` and `dart`
4. **Flutter Community:** https://flutter.dev/community

## Project-Specific Issues

### 1. Clean Architecture Setup

If you encounter issues with the architecture setup:

```bash
# Regenerate dependency injection
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check all @Injectable annotations are correct
# Verify import statements in injection_container.dart
```

### 2. BLoC State Issues

```bash
# Make sure bloc_test is in dev_dependencies
# Check event and state classes extend Equatable
# Verify BlocProvider is wrapping widgets correctly
```

### 3. Navigation Issues

```bash
# Check GoRouter configuration
# Verify route names and paths
# Ensure context.go() and context.push() are used correctly
```

Remember: When in doubt, `flutter clean` and `flutter pub get` solve many issues!
