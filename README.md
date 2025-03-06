# Allergen Scanner

A mobile application that helps users identify potential allergens in food products by scanning product labels.

## Features

- Create and manage your personal allergen list
- Scan product labels using your device's camera
- Real-time allergen detection in scanned text
- Dark/Light theme support
- Multi-language support (English and Polish)
- Offline functionality
- User-friendly interface

## How It Works

1. **Create Your Allergen List**
   - Add allergens you need to avoid
   - Manage your list anytime

2. **Scan Product Labels**
   - Use your camera to scan product ingredients
   - Choose images from your gallery

3. **Instant Results**
   - Get immediate feedback if any allergens are detected
   - View the full scanned text
   - See highlighted matches from your allergen list

## Technical Details

This project is a Proof of Concept (POC) built with:
- Flutter
- Google ML Kit for text recognition
- Hive for local storage
- BLoC pattern for state management

## Getting Started

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

## Note
This is a Proof of Concept application. While it can help identify allergens in product labels, it should not be the sole method for determining food safety. Always consult product packaging and manufacturers' information for definitive allergen information.