# My Eyes App

My Eyes is a Flutter application designed to assist vision-impaired individuals in understanding their surroundings using Gemini AI. The app utilizes text-to-speech for voice interactions, Firebase for Crashlytics and Analytics, and Provider for state management.

## Features

- **Vision Assistance**: Uses Gemini AI to provide voiced descriptions of surroundings captured by the camera.
- **Text-to-Speech**: Enables seamless interaction through spoken prompts and responses.
- **Firebase Integration**: Utilizes Firebase Crashlytics for real-time crash monitoring and Firebase Analytics for performance insights.
- **State Management**: Implements Provider for efficient state management across the app.

## Demo

Watch a demo of My Eyes: [My Eyes App Demo](https://youtube.com/shorts/S7HYC4YXEwA)

## Getting Started

To get started with My Eyes, follow these steps:

### Prerequisites

- Flutter installed on your development environment.
- A valid Gemini API key.

### Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd my_eyes
   ```

2. Create a `.env` file in the root of your project and add your Gemini API key:

   ```
   GEMINI_API_KEY=<your-gemini-api-key>
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

### Usage

- Open the app and grant necessary permissions for camera and microphone access.
- Follow the spoken prompts to navigate through the app and capture surroundings.
