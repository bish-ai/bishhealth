# BishHealth

A Flutter health app with AI/ML integration for health analysis and recommendations.

## Features

- **Health Metrics Dashboard**: Display heart rate, steps, calories, and sleep data
- **AI Health Analysis**: Get AI-powered insights on health concerns using natural language
- **Real-time Data**: Live health metrics tracking
- **Responsive Design**: Works on web, iOS, and Android
- **Easy Deployment**: One-click deployment to Vercel

## Tech Stack

- **Frontend**: Flutter
- **AI/ML**: OpenRouter API (GPT-3.5 Turbo)
- **State Management**: Provider
- **Deployment**: Vercel

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/bish-ai/bishhealth.git
cd bishhealth
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
```bash
cp .env.example .env
```

4. Add your API keys to `.env`:
```
OPENROUTER_API_KEY=your_key_here
```

5. Run the app:
```bash
flutter run -d web
```

## Deployment to Vercel

### Option 1: Automatic Deployment

1. Push to GitHub:
```bash
git push origin main
```

2. Go to [Vercel Dashboard](https://vercel.com)
3. Click "New Project"
4. Import your GitHub repository
5. Add environment variables in Vercel settings
6. Click "Deploy"

### Option 2: Manual Deployment

1. Build for web:
```bash
flutter build web --release
```

2. Install Vercel CLI:
```bash
npm i -g vercel
```

3. Deploy:
```bash
vercel --prod
```

## Environment Variables

Set these in your Vercel project settings:

- `OPENROUTER_API_KEY`: Your OpenRouter API key for AI features
- `CLAUDE_API_KEY`: (Optional) Claude API key
- `GEMINI_API_KEY`: (Optional) Google Gemini API key

## File Structure

```
bishealth/
├── lib/
│   ├── main.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── health_metrics_screen.dart
│   │   └── ai_analysis_screen.dart
│   ├── providers/
│   │   ├── health_provider.dart
│   │   └── ai_provider.dart
│   └── widgets/
│       └── metric_card.dart
├── web/
│   ├── index.html
│   └── manifest.json
├── pubspec.yaml
├── vercel.json
├── .env.example
└── README.md
```

## API Integration

The app uses OpenRouter API for AI analysis. To use different AI providers:

1. Update the API endpoint in `lib/providers/ai_provider.dart`
2. Adjust the headers and request body as needed
3. Update environment variables accordingly

## Health Metrics

Current metrics tracked:
- Heart Rate (bpm)
- Steps
- Calories (kcal)
- Sleep (hours)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - See LICENSE file for details

## Support

For issues and questions, please open an issue on GitHub.

## Author

Bish AI - AI Health Solutions
