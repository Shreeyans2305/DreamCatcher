import React, { createContext, useContext, useState, useEffect } from 'react';
import { storageEngine } from '../services/storageEngine';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [volunteer, setVolunteer] = useState(() => storageEngine.getVolunteer());
  const [isCredentialModalOpen, setIsCredentialModalOpen] = useState(false);
  
  // Unified Auth Modal State
  const [authModalConfig, setAuthModalConfig] = useState({
    isOpen: false,
    initialMode: 'login'
  });

  useEffect(() => {
    storageEngine.init();
  }, []);

  const openAuthModal = (mode = 'login') => {
    setAuthModalConfig({
      isOpen: true,
      initialMode: mode
    });
  };

  const closeAuthModal = () => {
    setAuthModalConfig(prev => ({ ...prev, isOpen: false }));
  };

  const login = (volunteerId, password) => {
    const current = storageEngine.getVolunteer();
    const updated = {
      ...current,
      volunteer_id: volunteerId || current.volunteer_id,
      is_active: true
    };
    storageEngine.saveVolunteer(updated);
    setVolunteer(updated);
    closeAuthModal();
    return { success: true, volunteer: updated };
  };

  const register = (registrationData) => {
    const randomSeq = Math.floor(10000 + Math.random() * 90000);
    const newVolunteerId = `DC-VOL-2026-${randomSeq}`;

    const newVolunteer = {
      volunteer_id: newVolunteerId,
      full_name: registrationData.full_name,
      role_type: registrationData.role_type,
      role_label: registrationData.role_label || 'Government School Teacher',
      organization_name: registrationData.organization_name,
      phone_number: registrationData.phone_number,
      email: registrationData.email || '',
      preferred_ui_language: registrationData.preferred_ui_language || 'mr',
      district: registrationData.district || 'Satara',
      state: registrationData.state || 'Maharashtra',
      is_active: true,
      created_at: new Date().toISOString()
    };

    storageEngine.saveVolunteer(newVolunteer);
    setVolunteer(newVolunteer);
    closeAuthModal();
    setIsCredentialModalOpen(true); // Open official ID card for review/print
    return { success: true, volunteer: newVolunteer };
  };

  const logout = () => {
    const updated = { ...volunteer, is_active: false };
    storageEngine.saveVolunteer(updated);
    setVolunteer(null);
  };

  return (
    <AuthContext.Provider value={{
      volunteer,
      isAuthenticated: Boolean(volunteer?.is_active),
      login,
      register,
      logout,
      authModalConfig,
      openAuthModal,
      closeAuthModal,
      isCredentialModalOpen,
      setIsCredentialModalOpen,
      // Backward compatibility helpers
      isLoginModalOpen: authModalConfig.isOpen && authModalConfig.initialMode === 'login',
      setIsLoginModalOpen: (open) => open ? openAuthModal('login') : closeAuthModal(),
      isRegisterModalOpen: authModalConfig.isOpen && authModalConfig.initialMode === 'register',
      setIsRegisterModalOpen: (open) => open ? openAuthModal('register') : closeAuthModal()
    }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
