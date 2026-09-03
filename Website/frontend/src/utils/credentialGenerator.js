// Pre-approved Partner NGO Catalog
export const PREAPPROVED_NGOS = [
  { id: 'PRATHAM', name: 'Pratham Education Foundation' },
  { id: 'TFI', name: 'Teach For India' },
  { id: 'AGASTYA', name: 'Agastya International Foundation' },
  { id: 'RYF', name: 'Rural Youth Foundation' },
  { id: 'AKSHAYA', name: 'Akshaya Patra Foundation' },
  { id: 'CUSTOM', name: 'Other Partner NGO' }
];

/**
 * Generates an official Badge ID based on entity type (Govt, NGO, Teacher)
 *
 * Examples:
 * - Govt Officer: GOV-MH-SAT-2026-4892
 * - NGO Volunteer: NGO-PRATHAM-MH-SAT-2026-0842
 * - School Teacher: TCH-MH-SAT-2026-1059
 */
export function generateGovernmentId({ 
  entityType = 'government_officer', 
  ngoCode = 'PRATHAM', 
  customNgoName = '',
  state = 'Maharashtra', 
  district = 'Satara' 
}) {
  const stateMap = {
    'Maharashtra': 'MH',
    'Gujarat': 'GJ',
    'Bihar': 'BR',
    'Madhya Pradesh': 'MP',
    'Delhi': 'DL',
    'Karnataka': 'KA',
    'Tamil Nadu': 'TN',
    'Uttar Pradesh': 'UP'
  };

  const stateCode = stateMap[state] || state.substring(0, 2).toUpperCase();
  const districtCode = district.replace(/\s+/g, '').substring(0, 3).toUpperCase();
  const year = new Date().getFullYear();
  const sequence = Math.floor(1000 + Math.random() * 9000);

  if (entityType === 'ngo_volunteer') {
    let cleanCode = ngoCode;
    if (ngoCode === 'CUSTOM' && customNgoName) {
      cleanCode = customNgoName.replace(/[^A-Za-z]/g, '').substring(0, 7).toUpperCase();
    }
    const finalNgoTag = (cleanCode || 'NGO').toUpperCase().substring(0, 7);
    return `NGO-${finalNgoTag}-${stateCode}-${districtCode}-${year}-${sequence}`;
  }

  if (entityType === 'school_teacher') {
    return `TCH-${stateCode}-${districtCode}-${year}-${sequence}`;
  }

  // Default: Government Officer
  return `GOV-${stateCode}-${districtCode}-${year}-${sequence}`;
}

/**
 * Generates a secure 12-character temporary password
 * Example: Dc@Pass#8429
 */
export function generateTemporaryPassword() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  const nums = '23456789';
  let pass = 'Dc@';
  for (let i = 0; i < 4; i++) pass += chars.charAt(Math.floor(Math.random() * chars.length));
  pass += '#';
  for (let i = 0; i < 4; i++) pass += nums.charAt(Math.floor(Math.random() * nums.length));
  return pass;
}
