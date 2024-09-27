# AIPPMSA - AI Powered Mobile Shopping Assistant Application

## Overview

AIPPMSA (AI Powered Personalized Mobile Shopping Assistant) is a Flutter-based mobile application that provides a personalized shopping experience using AI. It offers product recommendations based on user preferences. The application features a sleek UI, secure user authentication, dynamic product categories, and integrates with REST APIs for real-time data fetching.

## Features

- **AI-driven product recommendations** based on user preferences
- **Secure user authentication** using tokens
- **Dynamic product categories** and listings
- **API integration** for fetching products, categories, and user data
- **Custom widgets** for reusable UI components
- **Responsive design** compatible with multiple screen sizes

## Pubspec Requirements

Below are the key dependencies used in this project (as listed in `pubspec.yaml`):

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  flutter_native_splash: ^2.4.0
  dio: ^5.x
  flutter_secure_storage: ^9.2.2
  path: ^1.9.0
  sqflite: ^2.3.3+1
  flutter_stripe: ^11.0.0
  provider: ^6.1.2
  flutter_launcher_icons: ^0.14.1
```

## Installation

Follow these steps to get started with the project:

1. Clone the repository:
   ```bash
   git clone https://github.com/rangana91/aippmsa
   ```
2. Navigate to the project directory:
   ```bash
   cd aippmsa
   ```
3. Install the required dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app on a connected device:
   ```bash
   flutter run
   ```

## Project Structure

```bash
aippmsa/
├── lib/
│   ├── models/             # Data models for the app
│   ├── services/           # API services using Dio for network calls
│   ├── components/         # Reusable components
│   ├── providers/          # App wise providers
│   └── main.dart           # Entry point of the application
├── assets/                 # Images, fonts, and other static assets
└── pubspec.yaml            # Project dependencies and assets configuration
```

## Screenshots

| Login Screen                      | Dashboard                       |
| --------------------------------- | ---------------------------------- |
| ![Home Screen](http://app.novatechlane.net/storage/appendix/mobile/Screenshot_20240913-225545124.jpg)  | ![Product List](http://app.novatechlane.net/storage/appendix/mobile/Screenshot_20240913-225639214.jpg)  |

## Demo Video

Watch the application demo video to see it in action: [Demo Video](http://app.novatechlane.net/storage/videos/application-demo.mp4)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
