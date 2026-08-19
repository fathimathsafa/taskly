# 🚀 Taskly - Flutter Task Management Application

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State_Management-Provider-blue)](https://pub.dev/packages/provider)
[![Local Storage](https://img.shields.io/badge/Storage-Hive_DB-orange)](https://pub.dev/packages/hive)
[![Tests](https://img.shields.io/badge/Tests-35_Passing-success)](https://flutter.dev/docs/testing)
[![Code Quality](https://img.shields.io/badge/Analysis-0_Issues-brightgreen)](https://flutter.dev)

**Taskly** is a production-grade, feature-rich Flutter Task Management application built using modern clean architecture principles. It provides persistent offline storage via Hive, reactive state management using Provider, multi-criteria task search and filtering, contextual navigation, and an automated testing suite.

---

## ✨ Key Features

### 🔐 Authentication & Session Persistence
- **Modular Sign In Interface**: Secure login screen with real-time email regex and password length validation.
- **Session Persistence**: Automated login state management via `AuthStorageService`.
- **Password Visibility Toggle**: Interactive show/hide password toggle.

### ⚡ Interactive Dashboard
- **Metric Summary Cards**: Live real-time statistics counters for Total, Pending, In Progress, and Completed tasks.
- **Top 5 Recent Tasks Feed**: Exposes strictly the top 5 most recently created tasks on the dashboard.
- **Profile Avatar Sync**: Seamless profile picture synchronization between the AppBar profile button and the user profile screen.
- **Floating Task Creation Action**: Quick floating action button to add new tasks contextually.

### 📋 Advanced Task Listing & Workspace
- **Multi-Criteria Search & Filtering**:
  - **Search**: Case-insensitive keyword search matching task **Title** and **Description**.
  - **Status Filter**: Filter by `All`, `Pending`, `In Progress`, and `Completed`.
  - **Priority Filter**: Filter by `All`, `Low`, `Medium`, and `High`.
  - **Date Filter**: Interactive DatePicker filter targeting task due dates.
  - **Active Filter Chips**: Visual active filter chips bar with a single-click "Clear All" action.

### ➕ Contextual Task Creation
- **Strict Validation Rules**: Validates title (min 3 chars), description (min 5 chars), due date (no past dates), and assigned user.
- **Smart Navigation**: Uses `Navigator.pop` to return contextually back to whichever screen (Dashboard or Task Listing) launched the Add Task form.

### 📝 Task Details, Editing & Lifecycle Management
- **Status Mutation**: Instant status updates (`Pending`, `In Progress`, `Completed`) with non-blocking feedback SnackBars.
- **Stateless Form Editing**: Refactored `EditTaskDialog` (`StatelessWidget`) powered by `EditTaskFormController` for form state management.
- **Cross-Controller Sync**: Reactive cross-controller state updates ensuring Dashboard, Task Listing, and Task Details remain instantly synchronized without manual app reloads.
- **Safe Task Deletion**: Confirmation dialogs preventing accidental deletions.

### 👤 Profile Screen
- **User Profile Overview**: High-resolution user avatar with gold ring accent, camera badge, name, email, role, and quick settings options.

---

## 🏗️ Architecture & Project Structure

The project follows a **Feature-First Clean Architecture** with distinct layer separation (`Controller`, `Service`, `Repository`, `Model`, `View`, `Widget`):

```text
lib/
├── core/
│   ├── constants/       # App strings, task statuses, priorities, constants
│   ├── errors/          # Custom exceptions (ValidationException, StorageException)
│   ├── repository/      # Common repository interfaces & implementations
│   ├── routes/          # Centralized AppRoutes & AppRouter configuration
│   ├── services/        # Hive TaskStorageService & AuthStorageService
│   ├── theme/           # AppColors, AppTextStyles, AppTheme configuration
│   └── widgets/         # Reusable widgets (CustomButton, CustomTextField, AmbientBackground)
│
├── features/
│   ├── splash_screen/   # Centered Taskly splash screen & session router
│   ├── auth/            # Login screen view, controller, and form widgets
│   ├── dashboard_screen/# Dashboard view, controller, service, repository, and widgets
│   ├── task_listing_screen/ # Task workspace view, controller, header filters & cards
│   ├── task_adding_screen/  # Task creation view, controller, service & form validation
│   ├── task_details_screen/ # Task details view, controller, service & EditTaskDialog
│   └── profile_screen/  # User profile view, controller & avatar management
│
└── main.dart            # MultiProvider initialization & app entrypoint
```

---

## 🧪 Testing Suite

Taskly includes **35 automated Unit and Widget tests** ensuring robustness across all feature modules:

| Test Suite | File Location | Coverage / Test Cases |
| :--- | :--- | :--- |
| **Login Validation** | `test/unit/login_validation_test.dart` | Email regex, password length, visibility toggle state |
| **Task Validation** | `test/unit/task_validation_test.dart` | Title, description, due date, assignee validation rules |
| **Search & Filter Logic** | `test/unit/search_filter_logic_test.dart` | Search matching, status, priority, date filtering & reset |
| **Status & Deletion Logic** | `test/unit/status_update_test.dart` | Status mutation, task storage deletion logic |
| **Login Screen Widget** | `test/widget/login_screen_test.dart` | UI rendering, textfields, sign in headers, button actions |
| **Task Listing Widget** | `test/widget/task_list_screen_test.dart` | Search bar, filter buttons, workspace header rendering |
| **Add Task Widget** | `test/widget/add_task_screen_test.dart` | Form title, submit button, validation triggers |

---

## 🛠️ Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (`>=3.0.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>=3.0.0`)
- Android Studio / VS Code with Flutter extension

### Installation
1. **Clone the repository**:
   ```bash
   git clone https://github.com/fathimathsafa/taskly.git
   cd taskly
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

4. **Execute all unit & widget tests**:
   ```bash
   flutter test
   ```

5. **Run static analysis**:
   ```bash
   flutter analyze
   ```

---

## 📦 Main Dependencies

- **[flutter](https://flutter.dev)** - UI Framework
- **[provider](https://pub.dev/packages/provider)** - State Management
- **[hive](https://pub.dev/packages/hive)** & **[hive_flutter](https://pub.dev/packages/hive_flutter)** - Lightweight & fast key-value local database
- **[intl](https://pub.dev/packages/intl)** - Date formatting & parsing
- **[flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)** - Testing framework

---

## 📄 License
This project is created for company assignment evaluation purposes. All rights reserved.
