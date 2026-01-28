# Camel Study

A Flutter-based study timer app that implements a progressive study technique with visual bubble animations.

## Overview

Camel Study helps you manage your study sessions using an adaptive scheduling system. Unlike traditional Pomodoro timers with fixed intervals, Camel Study dynamically creates a personalized study schedule based on your available time, alternating between focused study periods and breaks.

## How It Works

### The Camel Study Technique

1. **Select your total study time** - Choose how long you want to study (e.g., 3 hours)
2. **Auto-generated schedule** - The app creates an optimized schedule with:
   - **Hard sessions**: 50-90 minute focused study blocks
   - **Easy sessions**: 25-minute lighter study blocks
   - **Breaks**: 5-10 minute rest periods between sessions
3. **Progressive difficulty** - Longer sessions are scheduled first when your energy is highest
4. **Visual feedback** - Pink bubbles gradually fill the screen as time runs out, creating a gentle visual reminder

### Session Types

| Session Type | Duration | Description |
|--------------|----------|-------------|
| Hard Study   | 50-90 min | Deep focus work |
| Hard Break   | 10 min | Longer rest after intense sessions |
| Easy Study   | 25 min | Lighter focus work |
| Easy Break   | 5 min | Quick rest |

### Schedule Algorithm

The app intelligently distributes your time:
- Sessions of 90+ minutes get split into Hard-Break-Easy-Break cycles
- Remaining time (30-90 min) uses Easy-Break cycles
- Any leftover time is distributed across existing sessions

## Features

- **Adaptive Timer** - Automatically creates study schedules based on your available time
- **State Persistence** - Timer state is saved and restored when you leave/return to the app
- **Bubble Animation** - Animated bubbles that increase as time runs out
- **Physics Engine** - Bubbles bounce off walls and each other with realistic collision detection
- **Dark Theme** - Easy on the eyes with pink accents on a gray background
- **Study/Break Indicator** - Clear display of current session type

## Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform UI framework |
| **Dart** | Programming language |
| **Material Design 3** | UI components and theming |
| **SharedPreferences** | Local storage for timer state persistence |

### Dependencies

```yaml
dependencies:
  flutter: sdk
  shared_preferences: ^2.1.1  # Persistent storage
  cupertino_icons: ^1.0.2     # iOS-style icons
```

### Build Configuration

- **Android Gradle Plugin**: 8.7.0
- **Gradle**: 8.9
- **Kotlin**: 2.1.0
- **Min SDK**: 24 (Android 7.0)
- **Target SDK**: 34 (Android 14)

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── Homepage.dart             # Main page with timer logic
├── models/
│   └── bubble.dart           # Bubble data model
├── theme/
│   └── app_theme.dart        # Colors, text styles, button styles
├── widgets/
│   ├── bubble_layer.dart     # Bubble rendering widget
│   ├── timer_display.dart    # Timer display (MM:SS)
│   ├── timer_controls.dart   # Start/Pause/Cancel buttons
│   └── schedule_list.dart    # Study schedule list
└── controllers/
    └── bubble_controller.dart # Bubble physics & animation
```

## Architecture

### State Management
- Uses Flutter's built-in `StatefulWidget` with mixins
- `WidgetsBindingObserver` for app lifecycle events
- `TickerProviderStateMixin` for animations

### Animation System
- `AnimationController` drives the bubble physics loop at 60fps
- Custom collision detection between bubbles (elastic collision)
- Wall bounce with energy dampening (0.9 coefficient)

### Data Persistence
- Timer state encoded as: `minutes@timestamp@status`
- Stored in SharedPreferences as a string list
- Automatically resumes on app restart

## Getting Started

### Prerequisites

- Flutter SDK (>=2.19.2 <3.0.0)
- Android Studio / VS Code with Flutter extension
- Android device or emulator (SDK 24+)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd camel_study

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build APK

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
```

## Usage

1. **Launch the app**
2. **Tap "Select time"** to choose your total study duration
3. **Review the generated schedule** shown in the list below
4. **Tap "Start"** to begin your study session
5. **Watch the bubbles** gradually fill the screen as time passes
6. **Pause/Resume** as needed - your progress is saved
7. **Complete each session** - the app automatically moves to breaks

## License

This project is private and not published to pub.dev.

## Author

Created by Vanya
