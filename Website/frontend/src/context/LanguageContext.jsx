import React, { createContext, useContext, useState, useEffect } from 'react';
import { getTranslation, languageOptions } from '../services/i18n/translations';
import { storageEngine } from '../services/storageEngine';

const LanguageContext = createContext(null);

export function LanguageProvider({ children }) {
  const [uiLanguage, setUiLanguageState] = useState(() => storageEngine.getUiLanguage());

  const setLanguage = (langCode) => {
    storageEngine.setUiLanguage(langCode);
    setUiLanguageState(langCode);
  };

  const t = (keyPath, fallback = '') => {
    return getTranslation(uiLanguage, keyPath, fallback);
  };

  return (
    <LanguageContext.Provider value={{ uiLanguage, setLanguage, languageOptions, t }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (!context) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
}
