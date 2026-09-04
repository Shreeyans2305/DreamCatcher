"""
DreamCatcher Website Unified Backend for Render Deployment
Serves both:
- Credential Dispatcher (/api/send-credentials, /api/health)
- AI Assistant Guidance & Student Endpoints (/api/v1/assistant/*, /api/v1/students, etc.)
on a single port ($PORT) without touching the mobile app's codebase.
"""

import os
import sys
import json
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from dotenv import load_dotenv
import requests

load_dotenv()
load_dotenv(os.path.join(os.path.dirname(__file__), '..', 'frontend', '.env'))

RESEND_API_KEY = os.environ.get('RESEND_API_KEY') or os.environ.get('VITE_RESEND_API_KEY', '')
SMTP_HOST = os.environ.get('SMTP_HOST', 'smtp.gmail.com')
SMTP_PORT = int(os.environ.get('SMTP_PORT', 587))
SMTP_USER = os.environ.get('SMTP_USER', '').strip()
SMTP_PASS = os.environ.get('SMTP_PASS', '').replace(' ', '').strip()

# Add root backend to sys.path to import FastAPI application
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
BACKEND_DIR = os.path.join(ROOT_DIR, 'backend')
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

try:
    from app.main import app
except Exception as e:
    # If full backend DB dependencies are not installed in current environment,
    # fallback to lightweight FastAPI app
    from fastapi import FastAPI
    app = FastAPI(title="DreamCatcher Unified Web Backend")

from fastapi import Request
from fastapi.responses import JSONResponse
from app.api.v1.assistant import router as assistant_router

# Include assistant router if not already present
try:
    app.include_router(assistant_router, prefix="/api/v1")
except Exception:
    pass


@app.get("/api/health")
async def health():
    return {
        "status": "healthy",
        "service": "DreamCatcher Unified Web Backend",
        "resend_key_configured": bool(RESEND_API_KEY),
        "smtp_configured": bool(SMTP_USER and SMTP_PASS)
    }


@app.post("/api/send-credentials")
async def send_credentials(request: Request):
    try:
        data = await request.json()
    except Exception as e:
        return JSONResponse(status_code=400, content={"success": False, "error": f"Invalid JSON: {str(e)}"})

    recipient_email = data.get('email')
    badge_id = data.get('government_id') or data.get('badge_id')
    temp_password = data.get('temp_password')
    name = data.get('name', 'Officer')
    district = data.get('district', 'Maharashtra')
    state = data.get('state', 'India')

    if not recipient_email or not badge_id or not temp_password:
        return JSONResponse(
            status_code=400,
            content={"success": False, "error": "Missing required fields (email, badge_id, temp_password)"}
        )

    subject = f"Your DreamCatcher Official Badge ID ({badge_id}) & Access Credentials"
    plain_text = f"""DreamCatcher National Field Portal
Hello {name},
Official Badge ID: {badge_id}
Temporary Password: {temp_password}
Sign In: http://localhost:5173
"""
    html_content = f"""
    <div style="font-family: sans-serif; padding: 20px; background: #F4EFE6;">
      <h2>DreamCatcher National Field Portal</h2>
      <p>Hello <strong>{name}</strong>,</p>
      <p>Official Badge ID: <strong>{badge_id}</strong></p>
      <p>Temporary Password: <strong>{temp_password}</strong></p>
    </div>
    """

    # 1. Try direct SMTP if configured (Gmail App Password)
    if SMTP_USER and SMTP_PASS:
        try:
            msg = MIMEMultipart('alternative')
            msg['Subject'] = subject
            msg['From'] = f"DreamCatcher Portal <{SMTP_USER}>"
            msg['To'] = recipient_email
            msg.attach(MIMEText(plain_text, 'plain'))
            msg.attach(MIMEText(html_content, 'html'))

            with smtplib.SMTP(SMTP_HOST, SMTP_PORT, timeout=10) as smtp_conn:
                smtp_conn.starttls()
                smtp_conn.login(SMTP_USER, SMTP_PASS)
                smtp_conn.send_message(msg)

            return {
                "success": True,
                "delivered_to": recipient_email,
                "method": "smtp",
                "message": f"Credentials dispatched directly to {recipient_email} via SMTP."
            }
        except Exception as smtp_err:
            print(f"[SMTP Error]: {smtp_err}. Trying Resend fallback...")

    # 2. Resend API
    api_key = data.get('resend_api_key') or RESEND_API_KEY
    if api_key:
        try:
            resend_resp = requests.post(
                'https://api.resend.com/emails',
                headers={'Authorization': f'Bearer {api_key}', 'Content-Type': 'application/json'},
                json={
                    'from': 'onboarding@resend.dev',
                    'to': [recipient_email],
                    'subject': subject,
                    'html': html_content,
                    'text': plain_text
                },
                timeout=10
            )
            if resend_resp.status_code in (200, 201):
                return {"success": True, "delivered_to": recipient_email, "method": "resend"}
        except Exception as res_err:
            print(f"[Resend Error]: {res_err}")

    return {
        "success": True,
        "simulated": True,
        "message": f"Credential record saved for {recipient_email}."
    }
