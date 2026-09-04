import React, { createContext, useContext, useState, useEffect } from 'react';
import { storageEngine } from '../services/storageEngine';
import { useAuth } from './AuthContext';
import { useAdminAuth } from './AdminAuthContext';
import { supabaseService } from '../services/supabaseService';
import { isSupabaseConfigured } from '../services/supabaseClient';
import confetti from 'canvas-confetti';

const CampOperationsContext = createContext(null);

export function CampOperationsProvider({ children }) {
  const { volunteer } = useAuth();
  const { admin } = useAdminAuth();

  const activeBadgeId = admin?.government_id || volunteer?.volunteer_id || 'DC-OFFICER';
  const activeDistrict = admin?.district || volunteer?.district || 'Satara';
  const activeState = admin?.state || volunteer?.state || 'Maharashtra';

  const isDemoUser = !activeBadgeId || activeBadgeId === 'DC-VOL-2026-00042' || activeBadgeId === 'GOV-MH-SAT-2026';

  const [camps, setCamps] = useState(() => {
    const all = storageEngine.getCamps();
    return isDemoUser ? all : all.filter(c => c.volunteer_id === activeBadgeId);
  });
  const [activeCampId, setActiveCampIdState] = useState(() => {
    const all = storageEngine.getCamps();
    const userCamps = isDemoUser ? all : all.filter(c => c.volunteer_id === activeBadgeId);
    return userCamps.find(camp => camp.status !== 'completed')?.camp_id || null;
  });
  const [students, setStudents] = useState(() => {
    const all = storageEngine.getStudents();
    return isDemoUser ? all : all.filter(s => s.volunteer_id === activeBadgeId);
  });
  const [syncQueue, setSyncQueue] = useState(() => storageEngine.getSyncQueue());
  const [isOnline, setIsOnline] = useState(() => navigator.onLine);
  const [selectedStudentForGuidance, setSelectedStudentForGuidance] = useState(null);
  const [isCreateCampModalOpen, setIsCreateCampModalOpen] = useState(false);
  const [syncNotification, setSyncNotification] = useState(null);

  // Sync / isolate data whenever the active officer changes or live events are available
  useEffect(() => {
    const syncOfficerData = async () => {
      if (isSupabaseConfigured()) {
        try {
          const events = await supabaseService.getEvents();
          if (events && events.length > 0) {
            const mapped = events.map(evt => ({
              camp_id: evt.event_id,
              volunteer_id: evt.admin_id,
              camp_name: evt.place,
              village_town: evt.place.includes('(') ? evt.place.split('(')[0].trim() : evt.place,
              district: activeDistrict,
              state: activeState,
              scheduled_date: evt.event_date,
              start_time: evt.event_time?.slice(0, 5) || '09:30',
              end_time: '16:30',
              status: evt.status?.toLowerCase() || 'upcoming',
              students_enrolled: 0,
              created_at: evt.created_at
            }));
            setCamps(mapped);
            setActiveCampIdState(mapped.find(camp => camp.status !== 'completed')?.camp_id || null);
            return;
          }
        } catch (err) {
          console.warn('Live events fetch notice:', err);
        }
      }

      // Local storage scoping
      const allCamps = storageEngine.getCamps();
      const userCamps = isDemoUser ? allCamps : allCamps.filter(c => c.volunteer_id === activeBadgeId);
      setCamps(userCamps);
      setActiveCampIdState(userCamps.find(camp => camp.status !== 'completed')?.camp_id || null);

      const allStudents = storageEngine.getStudents();
      const userStudents = isDemoUser ? allStudents : allStudents.filter(s => s.volunteer_id === activeBadgeId);
      setStudents(userStudents);
    };

    syncOfficerData();
  }, [activeBadgeId, isDemoUser, activeDistrict, activeState]);

  // Monitor network status
  useEffect(() => {
    const handleOnline = () => {
      setIsOnline(true);
      // Auto flush queue if items are pending
      const queue = storageEngine.getSyncQueue();
      if (queue.length > 0) {
        triggerSyncFlush();
      }
    };
    const handleOffline = () => setIsOnline(false);

    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  const activeCamp = camps.find(camp => camp.camp_id === activeCampId && camp.status !== 'completed') || null;

  const setActiveCamp = (campId) => {
    const selectedCamp = camps.find(camp => camp.camp_id === campId);
    if (selectedCamp?.status === 'completed') return;

    storageEngine.setActiveCampId(campId || '');
    setActiveCampIdState(campId || null);
  };

  const endCamp = async (campId) => {
    if (!admin) {
      throw new Error('Only an administrator can end a camp.');
    }

    const completedAt = new Date().toISOString();

    if (isSupabaseConfigured()) {
      await supabaseService.updateEventStatus(campId, 'COMPLETED');
    }

    storageEngine.updateCamp(campId, {
      status: 'completed',
      completed_at: completedAt
    });

    const updatedCamps = camps.map(camp => (
      camp.camp_id === campId
        ? { ...camp, status: 'completed', completed_at: completedAt }
        : camp
    ));
    setCamps(updatedCamps);

    if (activeCampId === campId) {
      const nextActiveCamp = updatedCamps.find(camp => camp.status !== 'completed');
      setActiveCamp(nextActiveCamp?.camp_id || null);
    }
  };

  const createCamp = async (campData) => {
    const newCamp = {
      camp_id: `camp-${Date.now()}`,
      volunteer_id: activeBadgeId,
      camp_name: campData.camp_name,
      village_town: campData.village_town || activeDistrict,
      district: campData.district || activeDistrict,
      state: campData.state || activeState,
      scheduled_date: campData.scheduled_date || new Date().toISOString().split('T')[0],
      start_time: campData.start_time || '09:30',
      end_time: campData.end_time || '16:30',
      status: 'upcoming',
      students_enrolled: 0,
      created_at: new Date().toISOString()
    };

    const updated = storageEngine.addCamp(newCamp);
    const userCamps = isDemoUser ? updated : updated.filter(c => c.volunteer_id === activeBadgeId);
    setCamps(userCamps);
    setActiveCamp(newCamp.camp_id);
    setIsCreateCampModalOpen(false);

    // Sync to Supabase events table if configured
    try {
      if (isSupabaseConfigured()) {
        await supabaseService.createEvent({
          place: `${newCamp.camp_name} (${newCamp.village_town}, ${newCamp.district})`,
          event_date: newCamp.scheduled_date,
          event_time: `${newCamp.start_time}:00`,
          status: 'SCHEDULED'
        });
      }
    } catch (e) {
      console.warn('Supabase event creation skipped:', e);
    }

    return newCamp;
  };

  const enrollStudent = (studentData) => {
    const newStudent = {
      student_record_id: `stu-${Date.now()}`,
      camp_id: activeCamp?.camp_id || 'camp-001',
      camp_name: activeCamp?.camp_name || `${activeDistrict} Field Camp`,
      volunteer_id: activeBadgeId,
      full_name: studentData.full_name,
      age_years: parseInt(studentData.age_years, 10) || 15,
      date_of_birth: studentData.date_of_birth || '',
      student_contact_number: studentData.student_contact_number || '',
      guardian_contact_number: studentData.guardian_contact_number,
      village_location: studentData.village_location || activeDistrict,
      education_level: studentData.education_level,
      education_level_label: studentData.education_level_label || studentData.education_level,
      category: studentData.category,
      category_label: studentData.category_label || studentData.category,
      preferred_language: studentData.preferred_language || 'mr',
      aspirations: studentData.aspirations,
      created_at: new Date().toISOString(),
      case_notes: []
    };

    const committed = storageEngine.addStudent(newStudent, isOnline);
    const allStudents = storageEngine.getStudents();
    const userStudents = isDemoUser ? allStudents : allStudents.filter(s => s.volunteer_id === activeBadgeId);
    setStudents(userStudents);
    setCamps(userCamps => userCamps);
    setSyncQueue(storageEngine.getSyncQueue());

    // Trigger slight confetti celebration for field completion
    try {
      confetti({
        particleCount: 40,
        spread: 60,
        origin: { y: 0.8 }
      });
    } catch (e) {}

    return committed;
  };

  const addCaseNoteToStudent = (studentId, caseNote) => {
    const updated = storageEngine.updateStudentCaseNotes(studentId, caseNote);
    setStudents(updated);
    if (selectedStudentForGuidance?.student_record_id === studentId) {
      setSelectedStudentForGuidance(prev => ({
        ...prev,
        case_notes: [caseNote, ...(prev?.case_notes || [])]
      }));
    }
  };

  const triggerSyncFlush = () => {
    const result = storageEngine.flushSyncQueue();
    setStudents(storageEngine.getStudents());
    setSyncQueue([]);
    setSyncNotification(`Successfully synced ${result.syncedCount} records with central repository.`);
    setTimeout(() => setSyncNotification(null), 4000);
  };

  return (
    <CampOperationsContext.Provider value={{
      camps,
      activeCamp,
      activeCampId,
      setActiveCamp,
      endCamp,
      createCamp,
      students,
      enrollStudent,
      registerNewStudent: enrollStudent,
      addCaseNoteToStudent,
      syncQueue,
      isOnline,
      setIsOnline, // Allowed for testing offline toggles in UI
      triggerSyncFlush,
      selectedStudentForGuidance,
      setSelectedStudentForGuidance,
      isCreateCampModalOpen,
      setIsCreateCampModalOpen,
      syncNotification
    }}>
      {children}
    </CampOperationsContext.Provider>
  );
}

export function useCampOperations() {
  const context = useContext(CampOperationsContext);
  if (!context) {
    throw new Error('useCampOperations must be used within a CampOperationsProvider');
  }
  return context;
}
