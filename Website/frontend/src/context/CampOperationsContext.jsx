import React, { createContext, useContext, useState, useEffect } from 'react';
import { storageEngine } from '../services/storageEngine';
import confetti from 'canvas-confetti';

const CampOperationsContext = createContext(null);

export function CampOperationsProvider({ children }) {
  const [camps, setCamps] = useState(() => storageEngine.getCamps());
  const [activeCampId, setActiveCampIdState] = useState(() => storageEngine.getActiveCampId());
  const [students, setStudents] = useState(() => storageEngine.getStudents());
  const [syncQueue, setSyncQueue] = useState(() => storageEngine.getSyncQueue());
  const [isOnline, setIsOnline] = useState(() => navigator.onLine);
  const [selectedStudentForGuidance, setSelectedStudentForGuidance] = useState(null);
  const [isCreateCampModalOpen, setIsCreateCampModalOpen] = useState(false);
  const [syncNotification, setSyncNotification] = useState(null);

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

  const activeCamp = camps.find(c => c.camp_id === activeCampId) || camps[0];

  const setActiveCamp = (campId) => {
    storageEngine.setActiveCampId(campId);
    setActiveCampIdState(campId);
  };

  const createCamp = (campData) => {
    const newCamp = {
      camp_id: `camp-${Date.now()}`,
      volunteer_id: 'DC-VOL-2026-00042',
      camp_name: campData.camp_name,
      village_town: campData.village_town,
      district: campData.district,
      state: campData.state || 'Maharashtra',
      scheduled_date: campData.scheduled_date || new Date().toISOString().split('T')[0],
      start_time: campData.start_time || '09:30',
      end_time: campData.end_time || '16:30',
      status: 'upcoming',
      students_enrolled: 0,
      created_at: new Date().toISOString()
    };

    const updated = storageEngine.addCamp(newCamp);
    setCamps(updated);
    setActiveCamp(newCamp.camp_id);
    setIsCreateCampModalOpen(false);
    return newCamp;
  };

  const enrollStudent = (studentData) => {
    const newStudent = {
      student_record_id: `stu-${Date.now()}`,
      camp_id: activeCamp?.camp_id || 'camp-001',
      camp_name: activeCamp?.camp_name || 'General Field Camp',
      volunteer_id: 'DC-VOL-2026-00042',
      full_name: studentData.full_name,
      age_years: parseInt(studentData.age_years, 10) || 15,
      date_of_birth: studentData.date_of_birth || '',
      student_contact_number: studentData.student_contact_number || '',
      guardian_contact_number: studentData.guardian_contact_number,
      village_location: studentData.village_location,
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
    setStudents(storageEngine.getStudents());
    setCamps(storageEngine.getCamps());
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
      createCamp,
      students,
      enrollStudent,
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
