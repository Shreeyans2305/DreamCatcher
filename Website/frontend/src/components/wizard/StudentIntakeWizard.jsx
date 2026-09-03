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
  Sparkles, 
  Save, 
  CheckCircle, 
  AlertCircle 
} from 'lucide-react';

const INITIAL_FORM = {
  full_name: '',
  age_years: '15',
  date_of_birth: '',
  student_contact_number: '',
  guardian_contact_number: '',
  village_location: 'Shindewadi',
  education_level: 'grade_10',
  education_level_label: 'Class 10th (SSC Aspirant)',
  category: 'cat_obc',
  category_label: 'OBC (Other Backward Classes)',
  preferred_language: 'mr',
  aspirations: 'Government ITI Electrician or Polytechnic Computer Diploma',
  consent: true
};

export default function StudentIntakeWizard({ onLaunchGuidance, onSavedOnly }) {
  const { t } = useLanguage();
  const { enrollStudent, activeCamp } = useCampOperations();

  const [currentStep, setCurrentStep] = useState(1);
  const [formData, setFormData] = useState(INITIAL_FORM);
  const [draftNotice, setDraftNotice] = useState(false);

  // Restore draft if exists on mount
  useEffect(() => {
    const savedDraft = storageEngine.getIntakeDraft();
    if (savedDraft?.data?.full_name) {
      setFormData(savedDraft.data);
      setDraftNotice(true);
      setTimeout(() => setDraftNotice(false), 4500);
    }
  }, []);

  const updateFormData = (fields) => {
    setFormData(prev => {
      const updated = { ...prev, ...fields };
      // Debounced draft autosave
      storageEngine.saveIntakeDraft(updated);
      return updated;
    });
  };

  const steps = [
    { num: 1, label: t('wizard.step1') },
    { num: 2, label: t('wizard.step2') },
    { num: 3, label: t('wizard.step3') },
    { num: 4, label: t('wizard.step4') }
  ];

  const handleNext = (e) => {
    e.preventDefault();
    if (currentStep < 4) {
      setCurrentStep(prev => prev + 1);
    }
  };

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(prev => prev - 1);
    }
  };

  const handleSaveAndLaunch = () => {
    const committedStudent = enrollStudent(formData);
    setFormData(INITIAL_FORM);
    setCurrentStep(1);
    onLaunchGuidance(committedStudent);
  };

  const handleSaveOnly = () => {
    enrollStudent(formData);
    setFormData(INITIAL_FORM);
    setCurrentStep(1);
    if (onSavedOnly) onSavedOnly();
  };

  return (
    <div className="max-w-3xl mx-auto py-6 px-4 sm:px-6">
      
      {/* Draft Restored Banner */}
      {draftNotice && (
        <div className="mb-4 bg-amber-50 border border-amber-300 rounded-lg p-3 text-xs text-amber-900 flex items-center justify-between shadow-xs">
          <div className="flex items-center gap-2 font-indic font-medium">
            <AlertCircle className="w-4 h-4 text-amber-600" />
            <span>{t('wizard.draft_restored')}</span>
          </div>
          <button
            onClick={() => {
              storageEngine.clearIntakeDraft();
              setFormData(INITIAL_FORM);
              setDraftNotice(false);
            }}
            className="text-xs font-bold text-amber-800 underline"
          >
            Reset Form
          </button>
        </div>
      )}

      <div className="bg-white rounded-2xl shadow-md border border-slate-200 overflow-hidden">
        
        {/* Header with Active Camp & Wizard Title */}
        <div className="bg-[#173F6B] text-white p-5 sm:p-6 border-b border-[#0D2E50]">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
            <div>
              <div className="flex items-center gap-2">
                <UserPlus className="w-6 h-6 text-amber-400" />
                <h1 className="text-xl font-bold font-indic">{t('wizard.title')}</h1>
              </div>
              <p className="text-xs text-sky-100/90 mt-1 font-indic">{t('wizard.subtitle')}</p>
            </div>
            <div className="bg-[#0D2E50] px-3 py-1 rounded-md text-xs font-semibold text-amber-300 border border-sky-400/30 self-start sm:self-auto font-indic">
              Camp: {activeCamp?.camp_name}
            </div>
          </div>

          {/* Stepper Progress Bar */}
          <div className="grid grid-cols-4 gap-2 mt-6">
            {steps.map((s) => (
              <div key={s.num} className="space-y-1">
                <div className={`h-1.5 rounded-full transition-all ${
                  currentStep >= s.num ? 'bg-amber-400' : 'bg-sky-950/60'
                }`} />
                <span className={`text-[11px] font-bold font-indic hidden sm:block ${
                  currentStep === s.num ? 'text-amber-300' : 'text-sky-200/60'
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

          {/* Bottom Action Area (Sticky / Ergonomic) */}
          <div className="mt-8 pt-4 border-t border-slate-200 flex flex-col-reverse sm:flex-row sm:items-center sm:justify-between gap-3">
            
            {/* Back Button */}
            {currentStep > 1 ? (
              <button
                type="button"
                onClick={handleBack}
                className="px-4 py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 text-sm font-bold rounded-lg flex items-center justify-center gap-1.5 transition-colors touch-target font-indic"
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
                  className="w-full sm:w-auto px-6 py-3 bg-[#173F6B] hover:bg-[#0D2E50] text-white text-sm font-bold rounded-lg shadow flex items-center justify-center gap-1.5 transition-colors touch-target font-indic"
                >
                  <span>{t('wizard.next')}</span>
                  <ChevronRight className="w-4 h-4 text-amber-400" />
                </button>
              ) : (
                <div className="flex flex-col sm:flex-row items-center gap-2 w-full sm:w-auto">
                  <button
                    type="button"
                    onClick={handleSaveOnly}
                    className="w-full sm:w-auto px-4 py-3 bg-slate-200 hover:bg-slate-300 text-slate-800 text-xs font-bold rounded-lg flex items-center justify-center gap-1.5 transition-colors touch-target font-indic"
                  >
                    <Save className="w-4 h-4 text-slate-600" />
                    <span>{t('wizard.save_only')}</span>
                  </button>
                  <button
                    type="button"
                    onClick={handleSaveAndLaunch}
                    className="w-full sm:w-auto px-6 py-3 bg-amber-500 hover:bg-amber-600 text-slate-950 text-sm font-bold rounded-lg shadow-md flex items-center justify-center gap-2 transition-colors touch-target font-indic"
                  >
                    <Sparkles className="w-4 h-4 text-slate-950" />
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
