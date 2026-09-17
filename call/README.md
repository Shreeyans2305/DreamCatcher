# DreamCatcher voice counselling call

<p align="center">
	<img src="../DreamCatcherLogo.png" alt="DreamCatcher" width="160">
</p>

<p align="center">
	<img src="../RuralEducation.png" alt="Rural education" width="720">
</p>

This is the lightweight voice client for DreamCatcher counselling.

## Run

Run these commands from the `call` directory:

```sh
npm install
VITE_APP_BACKEND_URL=https://dreamcatcher-backend-635980060226.asia-south1.run.app/api/v1 VITE_STUDENT_ID=<optional-existing-student-uuid> npm run dev
```

For the unified local backend runner, use the FastAPI service on port `8001`:

```sh
VITE_APP_BACKEND_URL=http://localhost:8001/api/v1 npm run dev
```

`VITE_STUDENT_ID` is optional. When it is omitted, the first voice turn creates a new minimal caller profile. The returned `student_id` and `conversation_id` are retained for the remaining call.

Use a browser that supports `MediaRecorder` and allow microphone access. Google Cloud Speech-to-Text transcribes the selected Indian language; Google Cloud Text-to-Speech reads the counsellor reply aloud. The assistant response uses the existing profile-aware opportunity matching.

## Turn-by-turn voice conversation architecture

1. Hold `Hold to speak` to open the microphone with `getUserMedia` and `MediaRecorder`.
2. Release to stop recording. The client decodes the blob, resamples it to 16 kHz mono LINEAR16 WAV, and sends base64 bytes to `/api/v1/voice/query-base64`.
3. The backend uses Google Cloud Speech-to-Text, sends the transcript and `conversation_id` through the existing profile-aware assistant service, persists the turn in the database conversation store, and uses Google Cloud Text-to-Speech for the reply.
4. The returned `conversation_id` is reused for every later turn. Ending and starting a new call clears it. The returned audio is played as a data URL while the alternating transcript remains visible if playback fails.

The voice endpoint can receive an existing `student_id`, but new callers do not need one. Authentication can be supplied with `VITE_AUTH_TOKEN` or the `auth_token` local-storage value.

Use a modern browser with `MediaRecorder` support and grant microphone permission. Google Cloud Speech-to-Text and Text-to-Speech credentials must be available to the backend when running locally.
