import React from 'react';
import { useCampOperations } from '../../context/CampOperationsContext';
import { useLanguage } from '../../context/LanguageContext';
import { WifiOff, AlertCircle, CheckCircle2, RefreshCw } from 'lucide-react';

export default function SyncStatusBar() {
  const { isOnline, syncQueue, triggerSyncFlush, syncNotification } = useCampOperations();
  const { t } = useLanguage();

  if (syncNotification) {
    return (
      <div className="bg-emerald-700 text-white px-4 py-2 text-xs font-semibold flex items-center justify-center gap-2 shadow-inner">
        <CheckCircle2 className="w-4 h-4 text-emerald-200" />
        <span>{syncNotification}</span>
      </div>
    );
  }

  if (!isOnline) {
    return (
      <div className="bg-amber-600 text-slate-950 px-4 py-2 text-xs font-bold flex items-center justify-between shadow-inner">
        <div className="flex items-center gap-2">
          <WifiOff className="w-4 h-4 text-slate-950" />
          <span>Offline Field Mode Active: Student intake forms are saved safely on this device.</span>
        </div>
        {syncQueue.length > 0 && (
          <span className="bg-amber-900 text-amber-100 px-2 py-0.5 rounded text-xs font-semibold">
            {syncQueue.length} record(s) queued for sync
          </span>
        )}
      </div>
    );
  }

  if (syncQueue.length > 0) {
    return (
      <div className="bg-sky-800 text-sky-100 px-4 py-2 text-xs font-medium flex items-center justify-between">
        <div className="flex items-center gap-2">
          <AlertCircle className="w-4 h-4 text-amber-300" />
          <span>You have {syncQueue.length} student record(s) stored locally that need syncing to the server.</span>
        </div>
        <button
          onClick={triggerSyncFlush}
          className="bg-amber-400 hover:bg-amber-500 text-slate-950 px-3 py-1 rounded text-xs font-bold flex items-center gap-1.5 transition-colors"
        >
          <RefreshCw className="w-3.5 h-3.5" />
          <span>{t('header.sync_now')}</span>
        </button>
      </div>
    );
  }

  return null;
}
