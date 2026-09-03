import React from 'react';
import { useCampOperations } from '../../context/CampOperationsContext';
import { useLanguage } from '../../context/LanguageContext';
import { WifiOff, AlertCircle, CheckCircle2, RefreshCw } from 'lucide-react';

export default function SyncStatusBar() {
  const { isOnline, syncQueue, triggerSyncFlush, syncNotification } = useCampOperations();
  const { t } = useLanguage();

  if (syncNotification) {
    return (
      <div className="bg-emerald-50 text-emerald-900 border-b border-emerald-200 px-4 py-2 text-xs font-semibold flex items-center justify-center gap-2">
        <CheckCircle2 className="w-4 h-4 text-emerald-600" />
        <span>{syncNotification}</span>
      </div>
    );
  }

  if (!isOnline) {
    return (
      <div className="bg-amber-50 text-amber-900 border-b border-amber-200 px-4 py-2 text-xs font-semibold flex items-center justify-between">
        <div className="flex items-center gap-2">
          <WifiOff className="w-4 h-4 text-amber-600" />
          <span>Offline Field Mode Active: Student intake forms are saved safely on this device.</span>
        </div>
        {syncQueue.length > 0 && (
          <span className="bg-amber-100 text-amber-900 px-2.5 py-0.5 rounded-full text-xs font-bold border border-amber-300">
            {syncQueue.length} record(s) queued
          </span>
        )}
      </div>
    );
  }

  if (syncQueue.length > 0) {
    return (
      <div className="bg-neutral-100 text-neutral-800 border-b border-black/[0.05] px-4 py-2 text-xs font-medium flex items-center justify-between">
        <div className="flex items-center gap-2">
          <AlertCircle className="w-4 h-4 text-neutral-600" />
          <span>You have {syncQueue.length} student record(s) stored locally that need syncing to the server.</span>
        </div>
        <button
          onClick={triggerSyncFlush}
          className="btn-pill-black px-3 py-1 text-xs font-semibold gap-1.5 shadow-xs"
        >
          <RefreshCw className="w-3.5 h-3.5" />
          <span>{t('header.sync_now')}</span>
        </button>
      </div>
    );
  }

  return null;
}
