# DreamCatcher — Team Sync & Handoff Guide

> **Summary for Returning Teammates:**
> This document summarizes everything that changed over the last 2 hours on `master`, all conflicts resolved, how to pull safely, and exact commands to run the mobile app, web app, and backends locally and on Render.

---

## 1. Quick Start (After `git pull`)

Run this first to get up to date:

```bash
# 1. Pull latest master (all conflicts already resolved and pushed)
git pull origin master

# 2. Update Python dependencies (if working on backend/voice)
pip install -r backend/requirements.txt

# 3. Update Website Frontend dependencies (if working on Web)
cd Website/frontend
npm install
```

---

## 2. What Changed in the Repository (Summary of Recent Pushes)

### A. Mobile App & Voice Module (`Call_V1` - Commit `df1c8e6`)
- **Flutter Localizations (`app/lib/l10n/`)**: Added full localization support for 7 Indic languages (`bn`, `gu`, `kn`, `mr`, `or`, `ta`, `te`).
- **Voice Calling Web Module (`call/`)**: Added WebRTC/audio client in `call/` with `CallScreen.jsx`, `audio.js`, and styling.
- **Voice Backend Services**:
  - `backend/app/schemas/voice.py`: Voice session request/response models.
  - `backend/app/services/voice_service.py`: Audio synthesis & recognition hooks.
  - `backend/app/api/v1/assistant.py`: New `/api/v1/assistant/voice/session` endpoint.

---

### B. Merge Conflict Resolution (Commit `e8205e9`)
During synchronization, a conflict occurred in `backend/app/services/ai_service.py` between the new caller interviewer guidelines and the AI card formatting rules.

- **Resolved**: Unified both rule sets seamlessly:
  - **Rule 3**: Instructs Gemini to output structured alert callouts (`🎯 **Recommended Pathway:**`, `⚠️ **Important Eligibility Notice:**`, `💡 **Officer Guidance:**`).
  - **Rule 7**: Strict verification against real opportunities (no hallucinated URLs or deadlines).
  - **Rule 8**: Follow-up suggested questions prefixed with `💡`.
  - **Rule 9**: Phone caller interview loop for callers with incomplete profiles.

---

### C. Website: AI Guidance Studio & Formatted Alert Cards
- **Direct Launch from Step 4**:
  - When saving student profile in the Intake Wizard (e.g. *Neel, Class 10th, Police/Defense*), clicking **"Save Student & Launch AI Guidance"** opens the full-screen **AI Guidance Studio**.
  - **No floating side button**: Removed the side widget per design requirement to keep the interface distraction-free.
- **Rich Indic Zen Alert Cards**:
  - 🎯 **Emerald Card**: Recommended Career Pathway with multi-line roadmap.
  - ⚠️ **Rose Card**: Important Eligibility Criteria (age, physical tests, academic rules).
  - 💡 **Amber Callout**: Counselor Advice & Guidance.
  - **Verified Government Scheme Cards**: Instant links to Maharashtra Police, Agniveer Army, MahaDBT scholarship.
  - **Voice Input & TTS**: Mic button pre-fills spoken queries; "Read Aloud" speaks out advice in Marathi/Hindi/English.

---

### D. Single-Command Backend Runner & Render Deployment
- **Local Single Command Runner**:
  - New root script `run_backends.py` starts both backends simultaneously:
    ```bash
    python run_backends.py
    ```
    - Port `8000`: Website Email Dispatcher & Auth Service (`Website/backend/server.py`)
    - Port `8001`: FastAPI AI Counselor & Student Database (`backend/app/main.py`)
- **Single Render Deployment for Website**:
  - New entrypoint `Website/backend/main.py`.
  - Serves both `/api/send-credentials` and `/api/v1/assistant/*` on Render's single `$PORT` without modifying or affecting the mobile app!
  - **Render Start Command for Website**:
    ```bash
    uvicorn Website.backend.main:app --host 0.0.0.0 --port $PORT
    ```

---

## 3. How to Run Services Locally

### Option 1: Run Both Backends Together (Recommended)
```bash
# At root directory:
python run_backends.py
```

### Option 2: Run Services Individually

| Service | Directory | Command | URL / Port |
| :--- | :--- | :--- | :--- |
| **Website Frontend** | `Website/frontend` | `npm run dev` | `http://localhost:5173/` |
| **Website Backend (Email/Auth)** | `Website/backend` | `python server.py` | `http://localhost:8000` |
| **FastAPI Core Backend** | `backend` | `uvicorn app.main:app --reload --port 8001` | `http://localhost:8001` |
| **Voice Calling App** | `call` | `npm run dev` | `http://localhost:5174/` |
| **Mobile App (Flutter)** | `app` | `flutter run` | Mobile Emulator / Device |

---

## 4. Environment Variables Checklist

If you are testing email credentials dispatch locally, ensure `Website/backend/.env` has:

```env
PORT=8000
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=loginbrand075@gmail.com
SMTP_PASS=kufw fhyi wcfz qfpt   # Gmail App Password (active)
SMTP_FROM=loginbrand075@gmail.com
```

---

## 5. Branch & Git Status
- **Active Branch**: `master`
- **Remote**: Synced with `origin/master` (`e8205e9`)
- **Status**: Clean working tree, zero merge conflicts, all Python and React files syntax-checked and compiling.
