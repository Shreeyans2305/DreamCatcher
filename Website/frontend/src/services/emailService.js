/**
 * Email Dispatch Service
 * Handles sending official login credentials (Government/NGO Badge ID + Temp Password)
 */
export async function sendAdminCredentialEmail({ 
  email, 
  name, 
  government_id, 
  temp_password, 
  district, 
  state,
  entityType = 'government_officer',
  organization_name = 'Education Department'
}) {
  const resendApiKey = import.meta.env.VITE_RESEND_API_KEY;

  const entityTitle = entityType === 'ngo_volunteer' 
    ? `🤝 NGO Field Coordinator Credentials (${organization_name})`
    : entityType === 'school_teacher'
    ? `🏫 ZP / Tribal School Teacher Credentials`
    : `🧭 Government Education Officer Credentials (${organization_name})`;

  const emailHtml = `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background: #F8F1EC; border-radius: 16px; padding: 24px; color: #2A1517;">
      <div style="text-align: center; margin-bottom: 20px;">
        <h2 style="color: #3D2123; margin: 0;">🧭 DreamCatcher National Infrastructure</h2>
        <p style="color: #A83E28; font-weight: bold; margin-top: 4px;">${entityTitle}</p>
      </div>

      <div style="background: #ffffff; border-radius: 12px; padding: 20px; border: 1px solid #EBD1C6;">
        <p>Dear <strong>${name}</strong>,</p>
        <p>Your administrative access for <strong>${organization_name}</strong> operating in <strong>${district}, ${state}</strong> has been provisioned.</p>

        <table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
          <tr style="background: #F8F1EC;">
            <td style="padding: 10px; font-weight: bold;">Official Badge ID:</td>
            <td style="padding: 10px; font-family: monospace; font-size: 16px; color: #A83E28;"><strong>${government_id}</strong></td>
          </tr>
          <tr>
            <td style="padding: 10px; font-weight: bold;">Temporary Password:</td>
            <td style="padding: 10px; font-family: monospace; font-size: 16px; color: #3D2123;"><strong>${temp_password}</strong></td>
          </tr>
          <tr style="background: #F8F1EC;">
            <td style="padding: 10px; font-weight: bold;">Assigned Region:</td>
            <td style="padding: 10px;">${district}, ${state}</td>
          </tr>
        </table>

        <div style="text-align: center; margin-top: 24px;">
          <a href="http://localhost:5173/" style="background: #A83E28; color: #ffffff; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: bold; inline-block;">
            Sign In to Field Portal →
          </a>
        </div>
      </div>

      <p style="font-size: 11px; color: #777; text-align: center; margin-top: 20px;">
        Please change your temporary password upon your first login.
      </p>
    </div>
  `;

  // 1. Try dispatching via Website/backend Python Resend service
  try {
    const backendEndpoints = ['/api/send-credentials', 'http://localhost:8000/api/send-credentials'];
    
    for (const endpoint of backendEndpoints) {
      try {
        const response = await fetch(endpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            email,
            name,
            government_id,
            badge_id: government_id,
            temp_password,
            district,
            state,
            entityType,
            organization_name
          })
        });

        if (response.ok) {
          const resData = await response.json();
          console.log('[EmailService] Dispatched via backend service:', resData);
          return {
            success: true,
            delivered_to: resData.delivered_to || email,
            is_sandbox_fallback: resData.is_sandbox_fallback,
            original_email: resData.original_email || email
          };
        }
      } catch (e) {
        // Try next endpoint
      }
    }
  } catch (err) {
    console.warn('[EmailService] Backend dispatch attempt failed, falling back:', err);
  }

  // 2. Direct Resend API dispatch if key is present in frontend .env
  if (resendApiKey) {
    try {
      const response = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${resendApiKey}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          from: 'DreamCatcher Portal <onboarding@resend.dev>',
          to: [email],
          subject: `Your DreamCatcher Badge ID (${government_id}) & Credentials`,
          html: emailHtml
        })
      });
      return response.ok;
    } catch (err) {
      console.warn('Direct Resend API call failed:', err);
    }
  }

  // 3. Fallback simulation log for local development
  console.log('====================================================');
  console.log('[SIMULATED CREDENTIAL EMAIL DISPATCH]');
  console.log(`TO: ${email}`);
  console.log(`TITLE: ${entityTitle}`);
  console.log(`BADGE ID: ${government_id}`);
  console.log(`TEMP PASSWORD: ${temp_password}`);
  console.log('====================================================');

  return true;
}
