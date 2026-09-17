# DreamCatcher Volunteer Portal

<p align="center">
  <img src="../../DreamCatcherLogo.png" alt="DreamCatcher" width="160">
</p>

<p align="center">
  <img src="../../RuralEducation.png" alt="Rural education" width="720">
</p>

The volunteer portal is a React/Vite web client for field teams supporting students through onboarding, opportunity discovery, and credential workflows. It uses the companion service in `Website/backend/` for credential dispatch and can be developed independently from the Flutter student app.

## Quick start

Run these commands from the `Website/frontend` directory:

```bash
npm install
npm run dev
```

Vite prints the local development URL, normally `http://localhost:5173`.

## Available commands

```bash
npm run dev       # Start Vite with hot reload
npm run build     # Create a production build
npm run lint      # Run ESLint
npm run preview   # Preview the production build locally
```

## Backend services

The credential dispatcher is in [`Website/backend/server.py`](../backend/server.py). Start it from the repository root with:

```bash
python Website/backend/server.py
```

To start the credential dispatcher and FastAPI guidance service together, use [`run_backends.py`](../../run_backends.py) from the repository root. The dispatcher listens on port `8000` and FastAPI listens on port `8001`.

## Project layout

```text
src/       React entrypoint, components, hooks, and utilities
public/    Static images and other browser assets
```

The root [README](../../README.md) documents the database, FastAPI API, Docker services, and other DreamCatcher clients.
