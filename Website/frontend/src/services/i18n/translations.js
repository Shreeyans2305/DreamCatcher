import en from './en.json';
import hi from './hi.json';
import mr from './mr.json';
import gu from './gu.json';

export const translations = { en, hi, mr, gu };

export const languageOptions = [
  { code: 'en', label: 'English', nativeLabel: 'English', script: 'Latin' },
  { code: 'hi', label: 'Hindi', nativeLabel: 'हिन्दी', script: 'Devanagari' },
  { code: 'mr', label: 'Marathi', nativeLabel: 'मराठी', script: 'Devanagari' },
  { code: 'gu', label: 'Gujarati', nativeLabel: 'ગુજરાતી', script: 'Gujarati' }
];

export function getTranslation(lang, keyPath, fallback = '') {
  const dict = translations[lang] || translations.en;
  const parts = keyPath.split('.');
  let current = dict;
  for (const part of parts) {
    if (current && typeof current === 'object' && part in current) {
      current = current[part];
    } else {
      // fallback to English
      let fallbackCurrent = translations.en;
      for (const fallbackPart of parts) {
        if (fallbackCurrent && typeof fallbackCurrent === 'object' && fallbackPart in fallbackCurrent) {
          fallbackCurrent = fallbackCurrent[fallbackPart];
        } else {
          return fallback || keyPath;
        }
      }
      return fallbackCurrent;
    }
  }
  return typeof current === 'string' ? current : fallback || keyPath;
}
