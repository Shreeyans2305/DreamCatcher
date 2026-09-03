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
    <div className="card-soft p-5 bg-white">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="font-bold text-sm text-neutral-900">
            {t('dashboard.monthly_trend')}
          </h3>
          <p className="text-[11px] text-neutral-500 font-normal">
            Students reached across volunteer-organized guidance camps
          </p>
        </div>
      </div>

      <div className="h-56 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={chartData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#F3F4F6" />
            <XAxis dataKey="month" tick={{ fontSize: 11, fill: '#6B7280' }} axisLine={false} tickLine={false} />
            <YAxis tick={{ fontSize: 11, fill: '#6B7280' }} axisLine={false} tickLine={false} />
            <Tooltip
              contentStyle={{
                backgroundColor: '#111111',
                borderRadius: '10px',
                color: '#FFFFFF',
                fontSize: '12px',
                border: 'none',
                boxShadow: '0 8px 24px rgba(0,0,0,0.15)'
              }}
            />
            <Bar dataKey="students" fill="#111111" radius={[6, 6, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
