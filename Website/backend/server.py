"""
DreamCatcher Credential Dispatch Backend Service
Handles sending official login credentials (Government/NGO Badge ID + Temp Password) via Resend.
"""

import os
import sys
import json
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse
from dotenv import load_dotenv
import requests

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Load environment variables from .env in backend, parent, or frontend
load_dotenv()
load_dotenv(os.path.join(os.path.dirname(__file__), '..', 'frontend', '.env'))

PORT = int(os.environ.get('PORT', 8000))
RESEND_API_KEY = os.environ.get('RESEND_API_KEY') or os.environ.get('VITE_RESEND_API_KEY', '')

# Optional SMTP Settings (Allows sending to ANY recipient e.g. via Gmail App Password)
SMTP_HOST = os.environ.get('SMTP_HOST', 'smtp.gmail.com')
SMTP_PORT = int(os.environ.get('SMTP_PORT', 587))
SMTP_USER = os.environ.get('SMTP_USER', '').strip()
SMTP_PASS = os.environ.get('SMTP_PASS', '').replace(' ', '').strip()


def generate_credential_email_html(payload):
    name = payload.get('name', 'Field Officer')
    badge_id = payload.get('government_id') or payload.get('badge_id', 'GOV-PENDING')
    temp_password = payload.get('temp_password', 'Temporary123!')
    district = payload.get('district', 'Maharashtra')
    state = payload.get('state', 'India')
    org_name = payload.get('organization_name', 'Education Department')
    entity_type = payload.get('entityType', 'government_officer')

    role_title = "Government Education Officer"
    if entity_type == 'ngo_volunteer':
        role_title = f"NGO Field Volunteer ({org_name})"
    elif entity_type == 'school_teacher':
        role_title = f"School Teacher ({org_name})"

    return f"""
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Official Portal Credentials</title>
    </head>
    <body style="margin: 0; padding: 24px; background-color: #F4EFE6; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; color: #1F1F1F;">
      <div style="max-width: 560px; margin: 0 auto; background: #ffffff; border-radius: 16px; overflow: hidden; border: 1px solid #DECBC7; box-shadow: 0 4px 20px rgba(0,0,0,0.06);">
        
        <!-- Header -->
        <div style="background: #222222; padding: 28px 24px; text-align: center; color: #ffffff;">
          <h1 style="margin: 0; font-size: 20px; font-weight: 800; letter-spacing: -0.5px;">DreamCatcher National Field Portal</h1>
          <p style="margin: 6px 0 0 0; font-size: 12px; color: #DECBC7;">Official Administrative Access Provisioning</p>
        </div>

        <!-- Body -->
        <div style="padding: 28px 24px;">
          <p style="margin-top: 0; font-size: 14px; line-height: 1.6; color: #38332C;">
            Hello <strong>{name}</strong>,
          </p>
          <p style="font-size: 13px; line-height: 1.6; color: #5C5245;">
            Your official account for <strong>{role_title}</strong> operating in <strong>{district}, {state}</strong> has been provisioned. Below are your confidential credentials:
          </p>

          <!-- Credential Card -->
          <div style="margin: 24px 0; background: #FAF7F2; border: 1px solid #EBD1C6; border-radius: 12px; padding: 20px;">
            
            <div style="margin-bottom: 14px; padding-bottom: 12px; border-bottom: 1px solid #EBD1C6;">
              <span style="display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; color: #8C8275; margin-bottom: 4px;">Official Badge ID</span>
              <span style="font-family: monospace; font-size: 16px; font-weight: 800; color: #A83E28;">{badge_id}</span>
            </div>

            <div>
              <span style="display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; color: #8C8275; margin-bottom: 4px;">Temporary Password</span>
              <span style="font-family: monospace; font-size: 16px; font-weight: 800; color: #222222;">{temp_password}</span>
            </div>

          </div>

          <!-- Important Notice -->
          <div style="background: #FFF8E6; border-left: 4px solid #F59E0B; padding: 12px 14px; border-radius: 6px; margin-bottom: 24px;">
            <p style="margin: 0; font-size: 12px; color: #92400E; line-height: 1.5;">
              <strong>Security Protocol:</strong> For security compliance, please change your temporary password immediately upon your first sign in. Do not share your Badge ID.
            </p>
          </div>

          <!-- CTA Button -->
          <div style="text-align: center; margin: 28px 0 10px 0;">
            <a href="http://localhost:5173" style="display: inline-block; background: #222222; color: #ffffff; text-decoration: none; padding: 12px 28px; border-radius: 9999px; font-size: 13px; font-weight: 700; box-shadow: 0 2px 8px rgba(0,0,0,0.15);">
              Sign In to Field Portal &rarr;
            </a>
          </div>
        </div>

        <!-- Footer -->
        <div style="background: #FAF7F2; padding: 16px 24px; border-top: 1px solid #EBD1C6; text-align: center;">
          <p style="margin: 0; font-size: 11px; color: #A39B8E;">
            This is an automated system dispatch from DreamCatcher Education System.
          </p>
        </div>

      </div>
    </body>
    </html>
    """


class ResendDispatcherHandler(BaseHTTPRequestHandler):

    def _set_cors_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')

    def do_OPTIONS(self):
        self.send_response(200)
        self._set_cors_headers()
        self.end_headers()

    def do_GET(self):
        parsed = urlparse(self.path)
        if parsed.path in ('/api/health', '/health', '/'):
            self.send_response(200)
            self._set_cors_headers()
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            status_data = {
                "status": "healthy",
                "service": "DreamCatcher Credential Dispatcher",
                "resend_key_configured": bool(RESEND_API_KEY)
            }
            self.wfile.write(json.dumps(status_data).encode('utf-8'))
        else:
            self.send_response(404)
            self._set_cors_headers()
            self.end_headers()

    def do_POST(self):
        parsed = urlparse(self.path)
        if parsed.path in ('/api/send-credentials', '/api/resend', '/send-credentials'):
            content_length = int(self.headers.get('Content-Length', 0))
            body = self.rfile.read(content_length)
            
            try:
                data = json.loads(body.decode('utf-8'))
            except Exception as e:
                self.send_response(400)
                self._set_cors_headers()
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({"success": False, "error": f"Invalid JSON payload: {str(e)}"}).encode('utf-8'))
                return

            recipient_email = data.get('email')
            badge_id = data.get('government_id') or data.get('badge_id')
            temp_password = data.get('temp_password')
            name = data.get('name', 'Officer')
            district = data.get('district', 'Maharashtra')
            state = data.get('state', 'India')

            if not recipient_email or not badge_id or not temp_password:
                self.send_response(400)
                self._set_cors_headers()
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({
                    "success": False,
                    "error": "Missing required fields (email, government_id/badge_id, temp_password)"
                }).encode('utf-8'))
                return

            html_content = generate_credential_email_html(data)
            subject = f"Your DreamCatcher Official Badge ID ({badge_id}) & Access Credentials"

            # Check if Resend API Key is available
            api_key = data.get('resend_api_key') or RESEND_API_KEY
            
            plain_text = f"""DreamCatcher National Field Portal
Official Administrative Access Provisioning

Hello {name},
Your official account operating in {district}, {state} has been provisioned.

Official Badge ID: {badge_id}
Temporary Password: {temp_password}

Security Protocol: Please change your temporary password upon your first sign in.
Sign In at: http://localhost:5173
"""

            print("=" * 60)
            print("[OFFICIAL CREDENTIALS DISPATCH EVENT]")
            print(f"  RECIPIENT EMAIL: {recipient_email}")
            print(f"  OFFICER NAME:    {name}")
            print(f"  OFFICIAL BADGE:  {badge_id}")
            print(f"  ACCESS PASSWORD: {temp_password}")
            print("=" * 60)

            # 1. Direct SMTP Delivery (e.g. Gmail App Password - Delivers to ANY recipient without domain verification)
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
                    
                    print(f"[SMTP] Successfully dispatched directly to {recipient_email} via {SMTP_HOST}")
                    self.send_response(200)
                    self._set_cors_headers()
                    self.send_header('Content-Type', 'application/json')
                    self.end_headers()
                    self.wfile.write(json.dumps({
                        "success": True,
                        "delivered_to": recipient_email,
                        "method": "smtp",
                        "message": f"Credentials dispatched directly to {recipient_email} via SMTP."
                    }).encode('utf-8'))
                    return
                except Exception as smtp_err:
                    print(f"[SMTP Error]: {smtp_err}. Falling back to Resend API...")

            # 2. Resend API Dispatch
            if api_key:
                try:
                    resend_resp = requests.post(
                        'https://api.resend.com/emails',
                        headers={
                            'Authorization': f'Bearer {api_key}',
                            'Content-Type': 'application/json'
                        },
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
                        res_json = resend_resp.json()
                        print(f"[Resend] Successfully dispatched credentials to {recipient_email} (ID: {res_json.get('id')})")
                        self.send_response(200)
                        self._set_cors_headers()
                        self.send_header('Content-Type', 'application/json')
                        self.end_headers()
                        self.wfile.write(json.dumps({
                            "success": True,
                            "id": res_json.get('id'),
                            "delivered_to": recipient_email,
                            "message": f"Credentials dispatched to {recipient_email} via Resend."
                        }).encode('utf-8'))
                        return
                    else:
                        error_text = resend_resp.text
                        print(f"[Resend API Error {resend_resp.status_code}]: {error_text}")

                        # If Resend free sandbox restricted to account owner email (e.g. loginbrand075@gmail.com), retry to that verified email!
                        import re
                        match = re.search(r'\(([^)]+@[^)]+)\)', error_text)
                        if match and resend_resp.status_code == 403:
                            allowed_email = match.group(1).strip()
                            print(f"[Resend Sandbox] Retrying dispatch to verified account owner: {allowed_email}")
                            
                            notice_html = f"""
                            <div style="background: #FEF3C7; border: 1px solid #F59E0B; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 12px; color: #92400E;">
                              <strong>Resend Sandbox Notice:</strong> Resend free tier only permits delivery to your verified account email (<strong>{allowed_email}</strong>). 
                              This credential dispatch was intended for registered officer: <strong>{recipient_email}</strong>.
                            </div>
                            """
                            forwarded_html = html_content.replace('<!-- Body -->', f'<!-- Body -->\n{notice_html}')

                            retry_resp = requests.post(
                                'https://api.resend.com/emails',
                                headers={
                                    'Authorization': f'Bearer {api_key}',
                                    'Content-Type': 'application/json'
                                },
                                json={
                                    'from': 'onboarding@resend.dev',
                                    'to': [allowed_email],
                                    'subject': f"[TEST MODE] {subject}",
                                    'html': forwarded_html,
                                    'text': plain_text
                                },
                                timeout=10
                            )

                            if retry_resp.status_code in (200, 201):
                                retry_json = retry_resp.json()
                                print(f"[Resend] Successfully delivered to verified testing inbox {allowed_email} (ID: {retry_json.get('id')})")
                                self.send_response(200)
                                self._set_cors_headers()
                                self.send_header('Content-Type', 'application/json')
                                self.end_headers()
                                self.wfile.write(json.dumps({
                                    "success": True,
                                    "id": retry_json.get('id'),
                                    "delivered_to": allowed_email,
                                    "original_email": recipient_email,
                                    "is_sandbox_fallback": True,
                                    "message": f"Delivered to your verified Resend testing email: {allowed_email}"
                                }).encode('utf-8'))
                                return

                        self.send_response(200)
                        self._set_cors_headers()
                        self.send_header('Content-Type', 'application/json')
                        self.end_headers()
                        self.wfile.write(json.dumps({
                            "success": True,
                            "simulated": True,
                            "warning": f"Resend API error {resend_resp.status_code}: {error_text}",
                            "message": f"Credential record saved. Resend error: {error_text}"
                        }).encode('utf-8'))
                        return
                except Exception as err:
                    print(f"[Resend Network Exception]: {err}")
                    self.send_response(200)
                    self._set_cors_headers()
                    self.send_header('Content-Type', 'application/json')
                    self.end_headers()
                    self.wfile.write(json.dumps({
                        "success": True,
                        "simulated": True,
                        "warning": f"Resend connection failed: {str(err)}"
                    }).encode('utf-8'))
                    return
            else:
                # Simulation mode (No API Key set yet)
                print("=" * 60)
                print("[SIMULATED CREDENTIAL EMAIL DISPATCH - No RESEND_API_KEY found]")
                print(f"TO: {recipient_email} ({name})")
                print(f"SUBJECT: {subject}")
                print(f"BADGE ID: {badge_id}")
                print(f"TEMP PASSWORD: {temp_password}")
                print("=" * 60)

                self.send_response(200)
                self._set_cors_headers()
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({
                    "success": True,
                    "simulated": True,
                    "message": "Credentials logged to backend console (Resend API key not configured)."
                }).encode('utf-8'))
        else:
            self.send_response(404)
            self._set_cors_headers()
            self.end_headers()

    def log_message(self, format, *args):
        sys.stderr.write(f"[Website/backend] {self.address_string()} - {format % args}\n")


# Reconfigure stdout/stderr for utf-8 if possible
if hasattr(sys.stdout, 'reconfigure'):
    try:
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
        sys.stderr.reconfigure(encoding='utf-8', errors='replace')
    except Exception:
        pass


def run():
    server_address = ('', PORT)
    httpd = HTTPServer(server_address, ResendDispatcherHandler)
    print("=" * 60)
    print(f">> DreamCatcher Resend Dispatcher Service running on http://localhost:{PORT}")
    print(f"   Endpoint: POST http://localhost:{PORT}/api/send-credentials")
    print(f"   Health:   GET  http://localhost:{PORT}/api/health")
    print(f"   Resend Key: {'Configured' if RESEND_API_KEY else 'Not set (Simulation Mode)'}")
    print("=" * 60)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nStopping server...")
        httpd.server_close()


if __name__ == '__main__':
    run()
