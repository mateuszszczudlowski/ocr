# 🔍 Allergen Scanner

A mobile application that helps users identify potential allergens in food products by scanning product labels.

## ✨ Features

### Core Functionality
- 📝 Create and manage your personal allergen list
- 📸 Scan product labels using your device's camera
- 🖼️ Import images from gallery
- ⚡️ Real-time allergen detection in scanned text

### Text Recognition
- OCR (Optical Character Recognition) for text extraction from images
- Camera and gallery image support
- Real-time text processing
- Test mode for quick demonstration

### Allergen Management
- Add/Remove allergens from personalized list
- Smart duplicate detection across translations
- Multi-language allergen names support
- Search functionality in allergen selection

### Accessibility & UI
- 🌓 Dark/Light theme support
- 🌍 Multi-language support (English and Polish)
- Adjustable text size for extracted text (16-26px)
- High contrast UI elements
- Clear visual feedback
- Intuitive navigation
- 🔄 Offline functionality

## 🚀 How It Works

1. **📋 Create Your Allergen List**
   - Add allergens you need to avoid
   - Manage your list anytime
   - Automatic duplicate prevention
   - Multi-language allergen names support

2. **📱 Scan Product Labels**
   - Use your camera to scan product ingredients
   - Choose images from your gallery
   - Test mode for quick demonstration

3. **✅ Instant Results**
   - Get immediate feedback if any allergens are detected
   - View the full scanned text with adjustable size
   - See highlighted matches with translations
   - Automatic grouping of related allergen translations

## 🛠 Technical Details

This project is built with:
- 💙 Flutter
- 🤖 Google ML Kit for text recognition
- 📦 Hive for local storage
- 🔄 BLoC pattern for state management

## 🏁 Getting Started

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

## Note
This is a Proof of Concept application. While it can help identify allergens in product labels, it should not be the sole method for determining food safety. Always consult product packaging and manufacturers' information for definitive allergen information.

## Features

- OCR (Optical Character Recognition) for text extraction from images
- Camera and gallery image support
- Allergen detection and highlighting
- Multi-language support (English and Polish)
- Dark/Light theme support
- Accessibility features:
  - Adjustable text size for extracted text (16-32px)
  - High contrast UI elements
- Allergen Management:
  - Add/Remove allergens from personalized list
  - Duplicate allergen prevention
  - Multi-language allergen names support
  - Search functionality in allergen selection