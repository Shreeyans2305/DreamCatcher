# DreamCatcher Student Mobile App (Flutter)

<p align="center">
   <img src="../DreamCatcherLogo.png" alt="DreamCatcher" width="160">
</p>

<p align="center">
   <img src="../RuralEducation.png" alt="Rural education" width="720">
</p>

An AI-powered opportunity discovery platform for students in rural and underserved regions of India. The application integrates directly with the live FastAPI backend on GCP Cloud Run.

---

## 🚀 Quick Start

### 1. Prerequisites
- Flutter 3.41+ / Dart 3.11+
- Connected device (Android, iOS, macOS, or Chrome)
- A running DreamCatcher backend, or access to the configured Cloud Run API

### 2. Running the App
Navigate into the `app` directory:

```bash
cd app
flutter pub get
```

Run on Chrome or connected simulator/device:

```bash
# Against default live Cloud Run backend
flutter run -d chrome

# Or on macOS desktop
flutter run -d macos
```

---

## 🌐 Connecting to the Backend

The app is preconfigured to communicate with the deployed live GCP Cloud Run backend:
`https://dreamcatcher-backend-635980060226.asia-south1.run.app/api/v1`

To point the app to a local FastAPI backend instance during development or testing, pass `--dart-define=API_BASE_URL`:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000/api/v1
```

> **Note on Cloud Run Cold Starts:**
> GCP Cloud Run instances scale down to 0 when idle. The first request after a period of inactivity may experience a latency of 3–5 seconds. The app includes generous timeout configurations (35 seconds) and displays user-friendly loading indicators rather than treating cold starts as connection failures.

For local development, start PostgreSQL with `docker compose up -d db`, then follow the backend setup in the [root README](../README.md). The unified local backend runner exposes FastAPI on port `8001`:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8001/api/v1
```

---

## 📱 Implemented Screens & Features

1. **Onboarding / Multi-Step Profile Builder** (`lib/screens/onboarding/onboarding_screen.dart`):
   - Multi-step flow: Name & language preference, Location & demographics (rural/urban, caste category, annual income), Education (formal education levels + free-text hands-on learning description), Skills & Interests multi-select from `/references`, Career Aspirations.
   - Animated `ProgressRing` tracking completion.
   - Submits student record and links education, skills, interests, and aspirations.
2. **Home Dashboard** (`lib/screens/dashboard/dashboard_screen.dart`):
   - Greeting headline ("Hello, `<name>` 👋").
   - `StatBlock` row showing profile completeness percentage and matched opportunities count.
   - `AvatarStack` social proof indicator ("24 students from your district applied this week").
   - Top-matched opportunities list with category badges and eligibility status.
3. **Opportunity Finder** (`lib/screens/opportunities/opportunity_finder_screen.dart`):
   - Search bar with real-time text query.
   - `FilterChipRow` for opportunity type (Scholarships, Courses, Exams, Internships) and "Eligible Only" toggle.
   - Tapping any card opens `OpportunityDetailSheet` displaying plain-language eligibility breakdown (passed/failed rules with clear descriptions).
4. **Chat Assistant** (`lib/screens/chat/chat_screen.dart`):
   - Conversational counselor interface with suggestion chips.
   - Profile-aware responses tailored to the student's name, skills, location, and career goals.
5. **Profile / Update Screen** (`lib/screens/profile/profile_screen.dart`):
   - View student details, education, and linked skills/interests.
   - "+ Add Skill" and "+ Add Interest" modals connecting to the backend catalogue.
   - Update education and hands-on learning descriptions with instant completeness recalculation.

---

## 🎨 Design System & Widgets

All shared widgets are built in `lib/core/widgets/` to ensure zero inline styling duplication:
- `RoundedCard`: Soft shadow, 22px corner radius.
- `StatBlock`: Flat pastel cards (mustard, mint, lavender) with bold metrics.
- `AvatarStack`: Overlapping circular avatars for social proof.
- `FloatingBottomNav`: Floating pill navigation bar (`#1A1A1A`) with accessible icon + text pairing.
- `AppSearchBar`: Rounded pill input with an attached accent filter button.
- `FilterChipRow`: Horizontally scrollable pill chips with dark selected state.
- `ProgressRing`: Circular percentage indicators with smooth animations.
- **Accessibility**: Minimum 48dp touch targets, layout tested for up to 130% font scale, single primary action per screen.

---

## 🧩 Mocked / Stubbed Components & Fastest Next Steps to De-Mock

| Component | Current Prototype State | Fastest Next Steps to De-Mock |
|-----------|-------------------------|------------------------------|
| **Authentication** | Mock onboarding (Name + Phone stored locally via `shared_preferences`) | Wire to OTP / SMS provider (e.g. Firebase Auth or Twilio) or DigiLocker / Aadhaar verification API. |
| **Chat Assistant** | Profile-aware counselor stub in `lib/providers/chat_provider.dart` marked with `// TODO: replace with real LLM endpoint` | Swap `_generateProfileAwareResponse` with an HTTP stream call to a Vertex AI Gemini endpoint or the backend RAG pipeline. |
| **Offline Model Sync** | Online API client with cold-start tolerance | Implement SQLite / Drift caching for offline catalogue reads and queue sync requests for student actions when offline. |
