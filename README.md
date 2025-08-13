# News App - Clean Architecture Flutter 🗞️

A modern, feature-rich Flutter news application demonstrating **Clean Architecture**, **SOLID principles**, and **Design Patterns** with offline-first capabilities and beautiful Material Design 3 UI.

![Flutter](https://img.shields.io/badge/Flutter-3.10+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

### Core Functionality
- 📰 **Browse Top Headlines** - Latest news from reliable sources worldwide
- 🔍 **Smart Search** - Search articles by keywords with real-time results
- 📖 **Rich Article Details** - Full content with images, author info, and metadata
- 🌐 **Dual Reading Modes** - In-app WebView or external browser
- 📱 **Pull-to-Refresh** - Effortless content updates

### Advanced Features
- 🔄 **Offline-First Architecture** - Read cached articles without internet
- 💾 **Intelligent Caching** - Automatic article storage with Hive database
- 🖼️ **Smart Image Caching** - Fast loading with cached network images
- ⚡ **Error Recovery** - Graceful fallback to cached content
- 🎨 **Material Design 3** - Modern, accessible UI components
- 📋 **Copy & Share URLs** - Easy article sharing capabilities

### User Experience
- ⏳ **Loading States** - Beautiful loading indicators and shimmer effects
- 🔔 **User Feedback** - Toast messages for actions and errors
- 🎯 **Responsive Design** - Optimized for phones and tablets
- 🌙 **Theme Support** - Ready for dark/light mode implementation

## 🏗️ Clean Architecture Implementation

This project showcases professional-grade architecture following Uncle Bob's Clean Architecture principles:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   News Pages    │    │   News BLoC     │                │
│  │   (UI Widgets)  │◄──►│ (State Mgmt)    │                │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   Use Cases     │    │   Entities      │                │
│  │ (Business Logic)│    │ (Core Models)   │                │
│  └─────────────────┘    └─────────────────┘                │
│  ┌─────────────────┐                                        │
│  │  Repository     │                                        │
│  │  (Interface)    │                                        │
│  └─────────────────┘                                        │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │  Remote Source  │    │  Local Source   │                │
│  │   (News API)    │    │  (Hive Cache)   │                │
│  └─────────────────┘    └─────────────────┘                │
│  ┌─────────────────┐                                        │
│  │   Repository    │                                        │
│  │ (Implementation)│                                        │
│  └─────────────────┘                                        │
└─────────────────────────────────────────────────────────────┘
```

### 📁 Detailed Folder Structure

```
lib/
├── 📂 core/                              # Shared utilities
│   ├── error/
│   │   ├── exceptions.dart               # Custom exceptions
│   │   └── failures.dart                 # Failure classes with Equatable
│   └── usecases/
│       └── usecase.dart                  # Base use case interface
│
├── 📂 data/                              # Data layer implementation
│   ├── datasources/
│   │   ├── news_local_data_source.dart   # Hive local storage
│   │   └── news_remote_data_source.dart  # NewsAPI HTTP client
│   ├── models/
│   │   ├── article_model.dart            # JSON serializable model
│   │   └── article_hive_model.dart       # Hive storage model
│   └── repositories/
│       └── news_repository_impl.dart     # Repository concrete implementation
│
├── 📂 domain/                            # Business logic layer
│   ├── entities/
│   │   └── article.dart                  # Core business entity
│   ├── repositories/
│   │   └── news_repository.dart          # Repository interface
│   └── usecases/
│       ├── get_top_headlines.dart        # Headlines business logic
│       └── search_news.dart              # Search business logic
│
├── 📂 presentation/                      # UI and state management
│   ├── bloc/
│   │   └── news_bloc.dart                # BLoC with events/states
│   └── pages/
│       ├── article_detail_page.dart      # Article details + WebView
│       └── news_list_page.dart           # News list + search
│
├── injection_container.dart              # Dependency injection setup
└── main.dart                            # App entry point
```

## 🎯 SOLID Principles in Action

### 🎯 Single Responsibility Principle (SRP)
```dart
// Each class has ONE reason to change
class GetTopHeadlines implements UseCase<List<Article>, NoParams> {
  // Only responsible for getting headlines
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  // Only responsible for managing news state
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  // Only responsible for API calls
}
```

### 🔓 Open/Closed Principle (OCP)
```dart
// Open for extension, closed for modification
abstract class NewsRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlines();
  Future<Either<Failure, List<Article>>> searchNews(String query);
}

// Can add new implementations without changing existing code
class NewsRepositoryImpl implements NewsRepository { ... }
class MockNewsRepository implements NewsRepository { ... } // For testing
```

### 🔄 Liskov Substitution Principle (LSP)
```dart
// Any implementation can replace the interface
NewsRepository repo = NewsRepositoryImpl(); // Production
NewsRepository repo = MockNewsRepository(); // Testing
// Both work identically from client perspective
```

### 🎛️ Interface Segregation Principle (ISP)
```dart
// Focused, client-specific interfaces
abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines();
  Future<List<ArticleModel>> searchNews(String query);
}

abstract class NewsLocalDataSource {
  Future<List<ArticleHiveModel>> getCachedArticles();
  Future<void> cacheArticles(List<ArticleHiveModel> articles);
}
```

### ⬆️ Dependency Inversion Principle (DIP)
```dart
// High-level modules depend on abstractions
class NewsBloc {
  final GetTopHeadlines getTopHeadlines; // Depends on use case interface
  final SearchNews searchNews;           // Not concrete implementations
}
```

## 🎨 Design Patterns Showcase

### 🏭 Repository Pattern
- **Purpose**: Encapsulates data access logic
- **Implementation**: `NewsRepository` interface with multiple data sources
- **Benefits**: Easy testing, data source flexibility

### 🔧 Factory Method Pattern
```dart
// Creates objects without specifying exact classes
factory ArticleModel.fromJson(Map<String, dynamic> json) { ... }
factory ArticleHiveModel.fromEntity(Article article) { ... }
```

### 🎯 Dependency Injection Pattern
```dart
// Centralizes dependency management
final sl = GetIt.instance;

sl.registerFactory(() => NewsBloc(getTopHeadlines: sl(), searchNews: sl()));
sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(...));
```

### 📋 Mapper Pattern
```dart
// Converts between different representations
class ArticleModel extends Article {
  factory ArticleModel.fromEntity(Article article) { ... }
  Article toEntity() { ... }
}
```

## 🔧 Technical Stack & Dependencies

### 🏗️ Architecture & State Management
```yaml
flutter_bloc: ^8.1.3          # BLoC pattern for state management
equatable: ^2.0.5             # Value equality for clean comparisons
dartz: ^0.10.1                # Functional programming (Either, Option)
get_it: ^7.6.4                # Service locator for dependency injection
```

### 🌐 Networking & Data
```yaml
http: ^1.1.0                  # HTTP client for API calls
json_annotation: ^4.8.1       # JSON serialization annotations
hive: ^2.2.3                  # Fast, lightweight NoSQL database
hive_flutter: ^1.1.0          # Flutter integration for Hive
```

### 🎨 UI & User Experience
```yaml
cached_network_image: ^3.3.0  # Image caching and loading
intl: ^0.18.1                 # Internationalization and date formatting
url_launcher: ^6.2.1          # Launch URLs in external browsers
webview_flutter: ^4.4.2       # In-app web browser
```

### 🛠️ Development Tools
```yaml
build_runner: ^2.4.7          # Code generation runner
json_serializable: ^6.7.1     # JSON serialization code generation
hive_generator: ^2.0.1        # Hive adapter generation
```

## 🚀 Quick Start Guide

### 1️⃣ Prerequisites Setup
```bash
# Check Flutter installation
flutter doctor

# Ensure minimum versions
flutter --version  # Should be 3.10+
dart --version     # Should be 3.0+
```

### 2️⃣ Project Setup
```bash
# Clone and navigate
git clone <your-repo-url>
cd news_app_clean_architecture

# Install dependencies
flutter pub get

# Generate required code
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 3️⃣ API Configuration
1. Visit [NewsAPI.org](https://newsapi.org/register) and create a free account
2. Copy your API key
3. Open `lib/data/datasources/news_remote_data_source.dart`
4. Replace the API key:
```dart
static const String _apiKey = 'YOUR_API_KEY_HERE';
```

### 4️⃣ Run the Application
```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device-id>
```

## 📱 App Usage Guide

### 🏠 Home Screen
- **Headlines Display**: Automatic loading of top US headlines
- **Search Bar**: Tap to search for specific topics
- **Pull to Refresh**: Swipe down to update content
- **Offline Indicator**: Orange banner when using cached data

### 🔍 Search Functionality
- **Real-time Search**: Type and press enter to search
- **Clear Search**: X button to clear and return to headlines
- **Query Validation**: Handles empty and invalid searches

### 📖 Article Details
- **Rich Content**: Title, description, author, publication date
- **Image Display**: High-quality cached images
- **Reading Options**: 
  - "Read in App" - Opens in WebView
  - "Open in Browser" - Opens in external browser
- **Error Handling**: URL validation and fallback options

### 📶 Offline Experience
- **Automatic Caching**: Articles cached on successful fetch
- **Offline Detection**: Visual indicators for cached content
- **Cache Fallback**: Seamless transition when network fails
- **Manual Cache Load**: "Load Cached" button in error states

## 🧪 Testing Strategy

### Unit Tests
```bash
# Test domain layer
flutter test test/domain/

# Test use cases
flutter test test/domain/usecases/

# Test repositories
flutter test test/data/repositories/
```

### Widget Tests
```bash
# Test UI components
flutter test test/presentation/pages/

# Test BLoC
flutter test test/presentation/bloc/
```

### Integration Tests
```bash
# End-to-end testing
flutter test integration_test/app_test.dart
```

## 🔧 Build & Deployment

### 📱 Android
```bash
# Debug build
flutter build apk --debug

# Release build (optimized)
flutter build apk --release --shrink

# App Bundle for Play Store
flutter build appbundle --release
```

### 🍎 iOS
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release --no-codesign
```

### 🌐 Web (if enabled)
```bash
flutter build web --release
```

## 🛠️ Development Workflow

### 🔄 Adding New Features

1. **Domain First**: Add entities and use cases
2. **Data Layer**: Implement data sources and models
3. **Presentation**: Create BLoC events/states and UI
4. **Testing**: Write comprehensive tests
5. **Integration**: Wire up dependency injection

### 📝 Code Generation
```bash
# Watch for changes and auto-generate
flutter packages pub run build_runner watch

# One-time generation
flutter packages pub run build_runner build

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 🚨 Troubleshooting

### Common Issues

#### API Key Problems
```
Error: Failed to load headlines
Solution: Verify API key in news_remote_data_source.dart
```

#### Build Runner Issues
```bash
# Clean and regenerate
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

#### WebView Not Loading
- **Android**: Ensure internet permission in `android/app/src/main/AndroidManifest.xml`
- **iOS**: Check `ios/Runner/Info.plist` for network security settings

#### Hive Box Errors
```bash
# Clear app data or uninstall/reinstall app
flutter clean
# Or programmatically: await Hive.deleteFromDisk();
```

## 🔧 Customization

### 🎨 Theming
```dart
// In main.dart - modify theme
theme: ThemeData(
  primarySwatch: Colors.blue,     // Change primary color
  useMaterial3: true,             # Material Design 3
  fontFamily: 'YourFont',         # Custom fonts
),
```

### 🌍 API Configuration
```dart
// In news_remote_data_source.dart
static const String _baseUrl = 'https://newsapi.org/v2';
static const String _apiKey = 'YOUR_KEY';

// Change country or category
Uri.parse('$_baseUrl/top-headlines?country=eg&category=technology&apiKey=$_apiKey')
```

### 💾 Cache Settings
```dart
// In news_local_data_source.dart
static const String _boxName = 'articles_cache';  // Change cache name
await box.clear(); // Clear cache strategy
```

## 📊 Performance Optimizations

- **Image Caching**: Reduces bandwidth and improves loading
- **Hive Database**: Fast local storage with minimal overhead
- **BLoC Pattern**: Efficient state management with rebuilds only when needed
- **Lazy Loading**: Dependencies created only when needed
- **HTTP Client Reuse**: Single client instance for all requests

## 🏆 Architecture Benefits

### 🧪 **Testability**
- Each layer isolated and mockable
- Business logic independent of UI/data
- Easy unit and integration testing

### 🔧 **Maintainability**
- Clear separation of concerns
- Easy to locate and fix bugs
- Consistent patterns throughout

### 📈 **Scalability**
- Easy to add new features
- Supports multiple data sources
- Modular component design

### 🔄 **Flexibility**
- Swap implementations easily
- Support different platforms
- Adapt to changing requirements

## 🤝 Contributing

### Getting Started
1. **Fork** the repository
2. **Clone** your fork locally
3. **Create** a feature branch
4. **Make** your changes following the architecture
5. **Test** thoroughly
6. **Submit** a pull request

### Code Standards
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` before committing
- Format code with `dart format lib/`
- Write tests for new features
- Update documentation

### Pull Request Guidelines
- Clear, descriptive titles
- Detailed description of changes
- Include screenshots for UI changes
- Ensure all tests pass
- Follow existing code patterns

## 📚 Learning Resources

### Clean Architecture
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture Guide](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

### Flutter Patterns
- [Flutter BLoC Documentation](https://bloclibrary.dev/)
- [SOLID Principles Explained](https://en.wikipedia.org/wiki/SOLID)
- [Design Patterns in Dart](https://refactoring.guru/design-patterns)

### Advanced Topics
- [Dependency Injection in Flutter](https://dart.dev/guides/language/effective-dart)
- [Error Handling Best Practices](https://dart.dev/guides/language/language-tour#exceptions)
- [Testing Flutter Apps](https://docs.flutter.dev/cookbook/testing)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Acknowledgments

- **NewsAPI.org** - Reliable news data provider
- **Flutter Team** - Amazing cross-platform framework  
- **BLoC Library** - Excellent state management solution
- **Hive Team** - Fast, lightweight database
- **Clean Architecture Community** - Architectural guidance
- **Open Source Contributors** - All package maintainers

## 📞 Contact

- 📧 **Email**: mariammansour303@gmail.com
- 💼 **LinkedIn**: [Mariam Mansour](https://www.linkedin.com/in/mariam-mansour-b06967252)
- 🐛 **Issues**: Create an issue for bugs or feature requests
- 💡 **Questions**: Feel free to ask about the architecture or implementation

---

**Built with ❤️ using Flutter • Clean Architecture • SOLID Principles**

> *"The goal of software architecture is to minimize the human resources required to build and maintain the required system."* - Robert C. Martin