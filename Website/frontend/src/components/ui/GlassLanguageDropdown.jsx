import React, { useState, useRef, useEffect } from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { Globe, Check, ChevronDown } from 'lucide-react';
import { motion, AnimatePresence } from 'framer-motion';

export default function GlassLanguageDropdown({ compact = false }) {
  const { uiLanguage, setLanguage, languageOptions } = useLanguage();
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef(null);

  // Close when clicked outside
  useEffect(() => {
    function handleClickOutside(event) {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
        setIsOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  const currentOption = languageOptions.find(opt => opt.code === uiLanguage) || languageOptions[0];

  return (
    <div className="relative inline-block text-left" ref={dropdownRef}>
      
      {/* Glassmorphism Trigger Button */}
      <button
        type="button"
        onClick={() => setIsOpen(!isOpen)}
        aria-expanded={isOpen}
        className="flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-white/80 hover:bg-white border border-[#D8CFC2] text-xs text-[#141414] transition-all cursor-pointer shadow-2xs hover:scale-105 active:scale-95"
        title="Change Language / भाषा बदला"
      >
        <Globe className="w-3.5 h-3.5 text-[#7A6F62] shrink-0" />
        <span className="font-display font-bold text-[11px] tracking-tight">
          {currentOption.nativeLabel}
        </span>
        <span className="text-[10px] text-[#7A6F62] font-semibold uppercase opacity-70">
          ({currentOption.code})
        </span>
        <ChevronDown className={`w-3 h-3 text-[#7A6F62] transition-transform duration-200 ${isOpen ? 'rotate-180' : ''}`} />
      </button>

      {/* Glassmorphism Animated Dropdown Menu */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: -8, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -8, scale: 0.95 }}
            transition={{ duration: 0.15, ease: 'easeOut' }}
            className="absolute right-0 mt-2 w-52 bg-[#FCFAF7]/95 backdrop-blur-2xl border border-white/80 shadow-[0_16px_40px_rgba(25,20,15,0.12),0_1px_3px_rgba(0,0,0,0.04)] rounded-2xl p-1.5 z-50 overflow-hidden"
          >
            <div className="px-3 py-1.5 border-b border-[#EAE2D5] mb-1">
              <span className="text-[10px] font-extrabold uppercase tracking-wider text-[#8C8276] block">
                Choose Language / भाषा निवडा
              </span>
            </div>

            <div className="space-y-0.5">
              {languageOptions.map((opt) => {
                const isSelected = opt.code === uiLanguage;
                return (
                  <button
                    key={opt.code}
                    onClick={() => {
                      setLanguage(opt.code);
                      setIsOpen(false);
                    }}
                    className={`w-full flex items-center justify-between px-3 py-2 rounded-xl text-xs font-medium transition-all cursor-pointer ${
                      isSelected
                        ? 'bg-[#141414] text-white shadow-xs font-bold'
                        : 'text-[#2D2823] hover:bg-black/[0.05]'
                    }`}
                  >
                    <div className="flex items-center gap-2">
                      <span className="text-sm font-semibold">{opt.nativeLabel}</span>
                      <span className={`text-[10px] uppercase font-bold px-1.5 py-0.2 rounded-md ${
                        isSelected ? 'bg-white/20 text-white' : 'bg-[#EAE2D5] text-[#555048]'
                      }`}>
                        {opt.code}
                      </span>
                    </div>

                    {isSelected && (
                      <Check className="w-3.5 h-3.5 text-white stroke-[2.5]" />
                    )}
                  </button>
                );
              })}
            </div>
          </motion.div>
        )}
      </AnimatePresence>

    </div>
  );
}
