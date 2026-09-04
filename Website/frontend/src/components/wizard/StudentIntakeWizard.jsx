import React, { useState, useEffect } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { useCampOperations } from '../../context/CampOperationsContext';
import { storageEngine } from '../../services/storageEngine';
import Step1BasicInfo from './Step1BasicInfo';
import Step2AcademicCategory from './Step2AcademicCategory';
import Step3AspirationsLanguage from './Step3AspirationsLanguage';
import Step4ReviewAndLaunch from './Step4ReviewAndLaunch';
import { 
  UserPlus, 
  ChevronRight, 
  ChevronLeft, 
  Save, 
  Sparkles, 
  AlertCircle 
} from 'lucide-react';

const INITIAL_FORM = {
  full_name: '',
  age_years: '',
  gender: 'male',
  parent_guardian_phone: '',
  guardian_contact_number: '',
  student_contact_number: '',
  village_location: '',
  education_level: 'grade_10',
  category: 'cat_obc',
  annual_family_income_inr: '',
  aspirations: '',
  preferred_language: 'mr',
  has_smartphone_access: false
};

export default function StudentIntakeWizard({ onLaunchGuidance, onSavedOnly }) {
  const { t } = useLanguage();
  const { activeCamp, enrollStudent, registerNewStudent } = useCampOperations();

  const [currentStep, setCurrentStep] = useState(1);
  const [formData, setFormData] = useState(INITIAL_FORM);
  const [draftNotice, setDraftNotice] = useState(false);

  // Restore draft if available
  useEffect(() => {
    try {
      const getDraft = storageEngine.loadIntakeDraft || storageEngine.getIntakeDraft;
      const draft = typeof getDraft === 'function' ? getDraft.call(storageEngine) : null;
      if (draft && draft.full_name) {
        setFormData(draft);
        setDraftNotice(true);
      }
    } catch (err) {
      console.warn('Could not restore draft:', err);
    }
  }, []);

  // Auto-save draft on step navigation
  const updateFormData = (fields) => {
    setFormData(prev => {
      const updated = { ...prev, ...fields };
      storageEngine.saveIntakeDraft(updated);
      return updated;
    });
  };

  const handleNext = (e) => {
    if (e) e.preventDefault();
    if (currentStep < 4) {
      setCurrentStep(s => s + 1);
    }
  };

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(s => s - 1);
    }
  };

  const finalizeStudent = () => {
    const registerFn = registerNewStudent || enrollStudent;
    let newStudent = null;
    
    if (typeof registerFn === 'function') {
      try {
        newStudent = registerFn({
          ...formData,
          camp_id: activeCamp?.camp_id || 'CAMP-DEFAULT',
          age_years: parseInt(formData.age_years, 10) || 15,
          annual_family_income_inr: parseInt(formData.annual_family_income_inr, 10) || 0
        });
      } catch (err) {
        console.warn('registerFn error:', err);
      }
    }

    if (!newStudent) {
      newStudent = storageEngine.addStudent({
        student_record_id: `stu-${Date.now()}`,
        camp_id: activeCamp?.camp_id || 'CAMP-DEFAULT',
        full_name: formData.full_name,
        age_years: parseInt(formData.age_years, 10) || 15,
        education_level: formData.education_level,
        category: formData.category,
        preferred_language: formData.preferred_language || 'mr',
        aspirations: formData.aspirations,
        village_location: formData.village_location,
        guardian_contact_number: formData.guardian_contact_number || formData.parent_guardian_phone,
        created_at: new Date().toISOString()
      });
    }

    storageEngine.clearIntakeDraft();
    return newStudent;
  };

  const handleSaveOnly = () => {
    finalizeStudent();
    if (onSavedOnly) onSavedOnly();
  };

  const handleSaveAndLaunch = () => {
    const created = finalizeStudent();
    if (onLaunchGuidance) {
      onLaunchGuidance(created);
    }
  };

  const steps = [
    { num: 1, label: t('wizard.step_basic', 'Basic Details') },
    { num: 2, label: t('wizard.step_academic', 'Academic Profile') },
    { num: 3, label: t('wizard.step_aspiration', 'Aspirations & Language') },
    { num: 4, label: t('wizard.step_review', 'Review & Guidance') }
  ];

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-6 space-y-5">
      
      {/* Draft Restored Banner */}
      {draftNotice && (
        <div className="bg-amber-50 border border-amber-200 rounded-[14px] p-3 text-xs text-amber-900 flex items-center justify-between shadow-xs">
          <div className="flex items-center gap-2 font-medium">
            <AlertCircle className="w-4 h-4 text-amber-600 shrink-0" />
            <span>{t('wizard.draft_restored')}</span>
          </div>
          <button
            onClick={() => {
              storageEngine.clearIntakeDraft();
              setFormData(INITIAL_FORM);
              setDraftNotice(false);
            }}
            className="text-xs font-bold text-amber-800 underline cursor-pointer"
          >
            {t('wizard.reset_form', 'Reset Form')}
          </button>
        </div>
      )}

      <div className="card-soft bg-white overflow-hidden shadow-sm">
        
        {/* Header with Active Camp & Wizard Title */}
        <div className="p-5 sm:p-6 border-b border-black/5 bg-white">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-indigo-50 text-indigo-600 flex items-center justify-center font-bold shrink-0">
                <UserPlus className="w-5 h-5" />
              </div>
              <div>
                <h1 className="text-xl font-black text-neutral-900 tracking-tight">{t('wizard.title')}</h1>
                <p className="text-xs text-neutral-500 mt-0.5 font-normal">{t('wizard.subtitle')}</p>
              </div>
            </div>

            <div className="bg-neutral-100 px-3 py-1 rounded-full text-xs font-semibold text-neutral-700 border border-black/4 self-start sm:self-auto">
              {t('nav.camps', 'Camp')}: {activeCamp?.camp_name}
            </div>
          </div>

          {/* Stepper Progress Bar (Solid Black for completed, Neutral for pending) */}
          <div className="grid grid-cols-4 gap-2 mt-6">
            {steps.map((s) => (
              <div key={s.num} className="space-y-1.5">
                <div className={`h-1.5 rounded-full transition-all ${
                  currentStep >= s.num ? 'bg-[#111111]' : 'bg-neutral-200'
                }`} />
                <span className={`text-[11px] font-semibold hidden sm:block ${
                  currentStep === s.num ? 'text-neutral-900 font-bold' : 'text-neutral-400'
                }`}>
                  {s.label}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* Form Body */}
        <form onSubmit={handleNext} className="p-5 sm:p-7">
          {currentStep === 1 && (
            <Step1BasicInfo formData={formData} updateFormData={updateFormData} />
          )}
          {currentStep === 2 && (
            <Step2AcademicCategory formData={formData} updateFormData={updateFormData} />
          )}
          {currentStep === 3 && (
            <Step3AspirationsLanguage formData={formData} updateFormData={updateFormData} />
          )}
          {currentStep === 4 && (
            <Step4ReviewAndLaunch formData={formData} />
          )}

          {/* Bottom Action Area (Pill Buttons) */}
          <div className="mt-8 pt-4 border-t border-black/[0.05] flex flex-col-reverse sm:flex-row sm:items-center sm:justify-between gap-3">
            
            {/* Back Button */}
            {currentStep > 1 ? (
              <button
                type="button"
                onClick={handleBack}
                className="btn-pill-secondary px-5 py-2.5 text-xs font-semibold gap-1.5"
              >
                <ChevronLeft className="w-4 h-4" />
                <span>{t('wizard.back')}</span>
              </button>
            ) : <div />}

            {/* Next / Save Buttons */}
            <div className="flex items-center gap-2 sm:gap-3">
              {currentStep < 4 ? (
                <button
                  type="submit"
                  className="btn-pill-black px-6 py-2.5 text-xs font-semibold gap-1.5"
                >
                  <span>{t('wizard.next')}</span>
                  <ChevronRight className="w-4 h-4 text-white" />
                </button>
              ) : (
                <div className="flex flex-col sm:flex-row items-center gap-2 w-full sm:w-auto">
                  <button
                    type="button"
                    onClick={handleSaveOnly}
                    className="btn-pill-secondary px-5 py-2.5 text-xs font-semibold gap-1.5 w-full sm:w-auto"
                  >
                    <Save className="w-3.5 h-3.5 text-neutral-600" />
                    <span>{t('wizard.save_only')}</span>
                  </button>
                  <button
                    type="button"
                    onClick={handleSaveAndLaunch}
                    className="btn-pill-black px-6 py-2.5 text-xs font-semibold gap-2 w-full sm:w-auto shadow-md"
                  >
                    <Sparkles className="w-3.5 h-3.5 text-white" />
                    <span>{t('wizard.save_launch')}</span>
                  </button>
                </div>
              )}
            </div>

          </div>
        </form>

      </div>
    </div>
  );
}
