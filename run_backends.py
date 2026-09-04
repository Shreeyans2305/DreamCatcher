"""
DreamCatcher Unified Backend Runner
Runs both the FastAPI AI Assistant backend and the Credential Dispatcher service locally
with a single command:
    python run_backends.py
"""

import os
import sys
import subprocess
import signal
import time

ROOT_DIR = os.path.abspath(os.path.dirname(__file__))
FASTAPI_DIR = os.path.join(ROOT_DIR, 'backend')
DISPATCHER_DIR = os.path.join(ROOT_DIR, 'Website', 'backend')

processes = []

def cleanup(signum=None, frame=None):
    print("\n[DreamCatcher] Shutting down backend processes gracefully...")
    for p in processes:
        try:
            p.terminate()
        except Exception:
            pass
    sys.exit(0)

signal.signal(signal.SIGINT, cleanup)
signal.signal(signal.SIGTERM, cleanup)

def main():
    print("=" * 65)
    print(">> DreamCatcher Unified Local Backends Orchestrator")
    print("   1. Credential Dispatcher (Resend + Gmail SMTP) -> Port 8000")
    print("   2. AI Assistant & Guidance Engine (FastAPI)     -> Port 8001")
    print("=" * 65)

    # 1. Start Credential Dispatcher
    print("[1/2] Launching Credential Dispatcher (Website/backend)...")
    p_disp = subprocess.Popen(
        [sys.executable, 'server.py'],
        cwd=DISPATCHER_DIR,
        env=dict(os.environ, PORT='8000')
    )
    processes.append(p_disp)

    # 2. Check if uvicorn is available for FastAPI backend
    try:
        import uvicorn
        print("[2/2] Launching FastAPI AI Assistant Service (backend)...")
        p_fastapi = subprocess.Popen(
            [sys.executable, '-m', 'uvicorn', 'app.main:app', '--host', '0.0.0.0', '--port', '8001', '--reload'],
            cwd=FASTAPI_DIR,
            env=dict(os.environ, PORT='8001', APP_PORT='8001')
        )
        processes.append(p_fastapi)
    except ImportError:
        print("[2/2] Note: 'uvicorn' not found in current Python environment.")
        print("      To run FastAPI alongside, run: pip install uvicorn fastapi in backend.")

    print("\n[OK] Backends are running. Press Ctrl+C to terminate both.\n")

    try:
        while True:
            time.sleep(1)
            for p in processes:
                if p.poll() is not None:
                    # One process exited
                    break
    except KeyboardInterrupt:
        cleanup()

if __name__ == '__main__':
    main()
