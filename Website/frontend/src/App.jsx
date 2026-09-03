import React, { useState } from 'react';
import { LanguageProvider } from './context/LanguageContext';
import { AuthProvider, useAuth } from './context/AuthContext';
import { CampOperationsProvider, useCampOperations } from './context/CampOperationsContext';
import AppHeader from './components/layout/AppHeader';
import SyncStatusBar from './components/layout/SyncStatusBar';
import LandingPageView from './views/LandingPageView';
import AuthPageView from './views/AuthPageView';
import DashboardView from './views/DashboardView';
import CampsView from './views/CampsView';
import DirectoryView from './views/DirectoryView';
import StudentIntakeWizard from './components/wizard/StudentIntakeWizard';
import CounselingStudio from './components/guidance/CounselingStudio';
import StudentCaseDrawer from './components/students/StudentCaseDrawer';
import VolunteerCredentialModal from './components/auth/VolunteerCredentialModal';

function AppContent() {
  // Top-level View Router: 'landing' (Default Home) | 'auth' (Full-screen Login/Signup) | 'portal' (Authenticated App)
  const [viewMode, setViewMode] = useState('landing');
  const [activeTab, setActiveTab] = useState('dashboard');
  const [drawerStudent, setDrawerStudent] = useState(null);

  const { isAuthenticated } = useAuth();
  const { 
    selectedStudentForGuidance, 
    setSelectedStudentForGuidance,
    setActiveCamp 
  } = useCampOperations();

  // 1. Landing Page View (Default Root Starting Page)
  if (viewMode === 'landing') {
    return (
      <LandingPageView
        onEnterAuth={() => setViewMode('auth')}
        onEnterPortal={() => setViewMode('portal')}
      />
    );
  }

  // 2. Full-Screen Auth View (Login / Register)
  if (viewMode === 'auth' || !isAuthenticated) {
    return (
      <div className="relative">
        <button
          onClick={() => setViewMode('landing')}
          className="fixed top-4 left-4 z-50 bg-[#F4EFE6]/90 backdrop-blur-xs hover:bg-white text-[#2B2520] border border-[#DECBC7] px-4 py-2 rounded-full text-xs font-medium shadow-sm flex items-center gap-1.5 cursor-pointer transition-all hover:scale-105"
        >
          <span>← Back to Home</span>
        </button>
        <AuthPageView onLoginSuccess={() => setViewMode('portal')} />
      </div>
    );
  }

  // 3. Authenticated Volunteer Field Portal
  const handleLaunchGuidance = (student) => {
    setSelectedStudentForGuidance(student);
    setActiveTab('guidance');
    setDrawerStudent(null);
  };

  const handleSelectIntakeForCamp = (camp) => {
    setActiveCamp(camp.camp_id);
    setActiveTab('intake');
  };

  return (
    <div className="min-h-screen flex flex-col bg-[#F7F4EE] text-[#1C1C1C]">
      
      {/* Single Unified Floating iOS Glass Navbar */}
      <AppHeader
        activeTab={activeTab}
        onSelectTab={setActiveTab}
        onNavigateHome={() => setViewMode('landing')}
      />

      {/* Sync Warning / Offline Banner */}
      <SyncStatusBar />

      {/* Main View Area */}
      <main className="flex-1 pb-16">
        {activeTab === 'dashboard' && (
          <DashboardView
            onNavigateTab={setActiveTab}
            onSelectStudentForCase={(stu) => setDrawerStudent(stu)}
            onLaunchGuidance={handleLaunchGuidance}
          />
        )}

        {activeTab === 'camps' && (
          <CampsView
            onSelectIntakeForCamp={handleSelectIntakeForCamp}
          />
        )}

        {activeTab === 'intake' && (
          <StudentIntakeWizard
            onLaunchGuidance={handleLaunchGuidance}
            onSavedOnly={() => setActiveTab('directory')}
          />
        )}

        {activeTab === 'directory' && (
          <DirectoryView
            onSelectStudentForCase={(stu) => setDrawerStudent(stu)}
            onLaunchGuidance={handleLaunchGuidance}
          />
        )}

        {activeTab === 'guidance' && (
          <CounselingStudio
            student={selectedStudentForGuidance}
            onBackToDirectory={() => setActiveTab('directory')}
            onNewStudentIntake={() => setActiveTab('intake')}
          />
        )}
      </main>

      {/* Longitudinal Case History Slide-over Drawer */}
      {drawerStudent && (
        <StudentCaseDrawer
          student={drawerStudent}
          onClose={() => setDrawerStudent(null)}
          onLaunchGuidance={handleLaunchGuidance}
        />
      )}

      {/* Official Volunteer ID Card Modal */}
      <VolunteerCredentialModal />

      {/* Field Footer */}
      <footer className="bg-white border-t border-black/[0.04] py-4 text-center text-xs text-neutral-400">
        <div className="max-w-7xl mx-auto px-4 flex flex-col sm:flex-row items-center justify-between gap-2">
          <span>DreamCatcher — Multilingual Public AI Career Guidance Field Platform</span>
          <span className="text-neutral-400">Offline-Ready PWA • UX4G Indic Design Standard</span>
        </div>
      </footer>

    </div>
  );
}

export default function App() {
  return (
    <LanguageProvider>
      <AuthProvider>
        <CampOperationsProvider>
          <AppContent />
        </CampOperationsProvider>
      </AuthProvider>
    </LanguageProvider>
  );
}
