import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip, CartesianGrid } from 'recharts';

export default function IntakeTrendChart({ data }) {
  const { t } = useLanguage();

  const chartData = data || [
    { month: 'Jun', students: 12 },
    { month: 'Jul', students: 28 },
    { month: 'Aug', students: 45 },
    { month: 'Sep (Current)', students: 31 }
  ];

  return (
    <div className="bg-white rounded-xl border border-slate-200 p-5 shadow-xs">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="font-bold text-sm text-slate-900 font-indic">
            {t('dashboard.monthly_trend')}
          </h3>
          <p className="text-[11px] text-slate-500 font-indic">
            Students reached across volunteer-organized guidance camps
          </p>
        </div>
      </div>

      <div className="h-56 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={chartData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#E2E8F0" />
            <XAxis dataKey="month" tick={{ fontSize: 11, fill: '#64748B' }} />
            <YAxis tick={{ fontSize: 11, fill: '#64748B' }} />
            <Tooltip
              contentStyle={{
                backgroundColor: '#0F172A',
                borderRadius: '8px',
                color: '#FFFFFF',
                fontSize: '12px',
                border: 'none'
              }}
            />
            <Bar dataKey="students" fill="#173F6B" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
