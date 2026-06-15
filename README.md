# BishHealth - AI-Powered Health Tracker

A comprehensive Flutter application that integrates system health data and provides personalized health insights powered by AI.

## Features

### 📊 Health Tracking
- **Real-time Health Metrics**: Track heart rate, steps, calories, sleep duration
- **System Integration**: Seamlessly integrates with device health platforms (Apple HealthKit, Google Fit)
- **Manual Data Entry**: Add custom health measurements
- **Data History**: Complete history of all health records

### 🤖 AI-Powered Insights
- **Personalized Insights**: AI-generated health insights based on your data
- **Health Recommendations**: Get personalized recommendations to improve health
- **Trend Analysis**: Analyze health trends over time
- **Anomaly Detection**: Automatic detection of unusual health patterns

### 👤 User Profile
- **Profile Management**: Manage personal health information
- **Medical History**: Track medical conditions and medications
- **BMI Calculation**: Automatic BMI calculation
- **Allergy Management**: Keep track of allergies

### 📈 Analytics
- **Daily Summary**: Quick overview of today's health metrics
- **Weekly Statistics**: Comprehensive weekly health summary
- **Charts & Graphs**: Visual representation of health data
- **Performance Metrics**: Track improvement over time

### 🔔 Notifications
- **Health Reminders**: Get reminders for daily activities
- **Alert System**: Notifications for important health events
- **Customizable Alerts**: Set personalized notification preferences

### 🌙 User Interface
- **Light/Dark Mode**: Support for both light and dark themes
- **Responsive Design**: Optimized for all screen sizes
- **Intuitive Navigation**: Easy-to-use interface
- **Material Design 3**: Modern and clean design language

## Architecture

### Project Structure

```
bishhhealth/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── config/
│   │   └── theme_config.dart     # Theme configuration
│   ├── models/
│   │   └── health_data_model.dart# Data models
│   ├── data/
│   │   └── local/
│   │       └── hive_service.dart # Local storage service
│   ├── services/
│   │   ├── health_service.dart   # Health data service
│   │   └── ai_service.dart       # AI service
│   ├── providers/
│   │   ├── app_state_provider.dart
│   │   ├── health_provider.dart
│   │   └── ai_provider.dart
│   └── ui/
│       ├── screens/
│       │   ├── splash_screen.dart
│       │   ├── home_screen.dart
│       │   ├── onboarding_screen.dart
│       │   └── ...
│       └── widgets/
│           ├── health_card.dart
│           ├── stats_card.dart
│           ├── ai_insight_card.dart
│           └── ...
├── pubspec.yaml
└── README.md
```

### Key Technologies

- **Flutter**: UI framework
- **Provider**: State management
- **Hive**: Local database
- **Google Generative AI**: AI-powered insights
- **Health Package**: System health data integration
- **Permission Handler**: Runtime permissions
- **Firebase**: Backend services (optional)

## Installation

### Prerequisites
- Flutter 3.0+
- Dart 3.0+
- iOS 12+ or Android 21+

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/bish-ai/bishhealth.git
   cd bishhealth
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up API Keys**
   - Replace `YOUR_GOOGLE_API_KEY_HERE` in `lib/services/ai_service.dart` with your actual Google Generative AI API key

4. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### iOS Configuration

In `ios/Podfile`, ensure the platform is set to iOS 12+:

```ruby
platform :ios, '12.0'
```

Add required permissions to `ios/Runner/Info.plist`:

```xml
<key>NSHealthShareUsageDescription</key>
<string>We need access to your health data to provide personalized insights.</string>
<key>NSHealthUpdateUsageDescription</key>
<string>We need permission to save your health data.</string>
```

### Android Configuration

Add required permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
<uses-permission android:name="android.permission.BODY_SENSORS" />
```

## Usage

### First Time Setup
- App presents onboarding screens
- User can set up their profile
- Permissions are requested
- Initial data sync happens

### Daily Usage
- Check health summary on home screen
- View AI-generated insights
- Add manual health data if needed
- Review weekly statistics

### Data Management
- View complete history
- Export data
- Delete old records
- Manage preferences

## API Integration

### Google Generative AI
The app uses Google Generative AI API for:
- Health insight generation
- Recommendation generation
- Trend analysis
- Anomaly detection

### Health Platform Integration
- **iOS**: Apple HealthKit
- **Android**: Google Fit

## Permissions Required

- **Health Data**: Read and write health information
- **Activity Recognition**: Track physical activity
- **Sensors**: Access device sensors
- **Notifications**: Send health reminders

## Data Storage

- **Local Storage**: Hive database for offline access
- **User Preferences**: SharedPreferences
- **Cloud Storage**: Firebase (optional)

## Privacy & Security

- All health data is encrypted locally
- No data is shared without user consent
- Compliant with HIPAA guidelines
- Open-source for transparency

## Performance Optimization

- Lazy loading of data
- Efficient state management
- Optimized database queries
- Image caching and compression
- Background data sync

## Testing

Run tests with:
```bash
flutter test
```

## Troubleshooting

### Health Data Not Syncing
- Ensure health permissions are granted
- Check health app configuration on device
- Verify API credentials

### AI Insights Not Generating
- Check internet connection
- Verify API key is valid
- Check API quota

### App Crashes on Launch
- Clear app cache
- Reinstall dependencies: `flutter clean && flutter pub get`
- Check Flutter version compatibility

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@bishhealth.com or open an issue on GitHub.

## Roadmap

- [ ] Wearable device integration
- [ ] Advanced analytics dashboard
- [ ] Social features
- [ ] Doctor consultation integration
- [ ] Medication reminder system
- [ ] Export to PDF/CSV
- [ ] Multi-language support
- [ ] Cloud sync for multiple devices

## Acknowledgments

- Flutter team for the amazing framework
- Google for Generative AI API
- Health package maintainers
- All contributors and testers

---

Made with ❤️ by BishAI

**Version**: 1.0.0  
**Last Updated**: June 15, 2026