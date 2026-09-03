import React, { createContext, useContext, useState, useEffect } from 'react';
import { supabaseService } from '../services/supabaseService';
import { supabase, isSupabaseConfigured } from '../services/supabaseClient';

const AdminAuthContext = createContext(null);

export const AdminAuthProvider = ({ children }) => {
  const [admin, setAdmin] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Initialize auth state & listen for changes
  useEffect(() => {
    let subscription = null;

    const initAuth = async () => {
      try {
        setLoading(true);
        const currentAdmin = await supabaseService.getCurrentAdmin();
        setAdmin(currentAdmin);
      } catch (err) {
        console.error('Failed to load admin auth profile:', err);
        setError(err.message);
      } finally {
        setLoading(false);
      }

      // Set up real-time listener if live Supabase is configured
      if (isSupabaseConfigured()) {
        const { data } = supabase.auth.onAuthStateChange(async (event, session) => {
          if (session?.user) {
            const profile = await supabaseService.getCurrentAdmin();
            setAdmin(profile);
          } else {
            setAdmin(null);
          }
          setLoading(false);
        });
        subscription = data.subscription;
      }
    };

    initAuth();

    return () => {
      if (subscription) subscription.unsubscribe();
    };
  }, []);

  const signIn = async (email, password) => {
    setError(null);
    try {
      const res = await supabaseService.signInAdmin({ email, password });
      const profile = await supabaseService.getCurrentAdmin();
      setAdmin(profile);
      return res;
    } catch (err) {
      setError(err.message || 'Authentication failed');
      throw err;
    }
  };

  const signUp = async (adminData) => {
    setError(null);
    try {
      const res = await supabaseService.signUpAdmin(adminData);
      return res;
    } catch (err) {
      setError(err.message || 'Registration failed');
      throw err;
    }
  };

  const signOut = async () => {
    try {
      await supabaseService.signOutAdmin();
      setAdmin(null);
    } catch (err) {
      console.error('Sign out error:', err);
    }
  };

  return (
    <AdminAuthContext.Provider
      value={{
        admin,
        isAuthenticated: Boolean(admin),
        loading,
        error,
        signIn,
        signUp,
        signOut
      }}
    >
      {children}
    </AdminAuthContext.Provider>
  );
};

export const useAdminAuth = () => {
  const context = useContext(AdminAuthContext);
  if (!context) {
    throw new Error('useAdminAuth must be used within an AdminAuthProvider');
  }
  return context;
};
