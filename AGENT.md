# Senthil Flutter App - Agent Instructions

## Commands
- **Build**: `flutter build apk` or `flutter build ios`
- **Run**: `flutter run` (debug), `flutter run --release` (release)
- **Test**: `flutter test` (all tests), `flutter test test/widget_test.dart` (single test)
- **Lint**: `flutter analyze` (static analysis), `dart fix --apply` (auto-fix)
- **Clean**: `flutter clean` && `flutter pub get`

## Architecture
- **Structure**: MVC pattern with Riverpod state management
- **Folders**: `lib/controller/` (business logic), `lib/view/` (UI screens), `lib/model/` (data models), `lib/widgets/` (reusable components)
- **State Management**: Flutter Riverpod for state, GetX for navigation
- **HTTP**: Dio for API calls, http package for basic requests
- **Storage**: SharedPreferences for local data
- **Theme**: Custom light/dark themes with gradient buttons

## Code Style
- **Imports**: Package imports first, then relative imports
- **Naming**: snake_case for files, camelCase for variables, PascalCase for classes
- **Widgets**: StatelessWidget preferred, ConsumerWidget for Riverpod state
- **Error Handling**: Try-catch blocks for async operations
- **Colors**: Use theme colors or predefined `baseColor`/`secoundary` from ThemeController
- **Formatting**: flutter_lints rules applied, 2-space indentation
