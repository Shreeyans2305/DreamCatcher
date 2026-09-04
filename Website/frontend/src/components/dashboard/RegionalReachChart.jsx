import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { ResponsiveContainer, PieChart, Pie, Cell, Tooltip, Legend } from 'recharts';
import { PieChart as PieIcon } from 'lucide-react';

export default function RegionalReachChart({ students }) {
  const { t } = useLanguage();

  // Aggregate by education stage
  const countsByGrade = (students || []).reduce((acc, curr) => {
    const key = curr.education_level_label || curr.education_level || 'General';
    acc[key] = (acc[key] || 0) + 1;
    return acc;
  }, {});

  const chartData = Object.keys(countsByGrade).map(key => ({
    name: key,
    value: countsByGrade[key]
  }));

  // Curated, warm aesthetic palette matching DreamCatcher
  const COLORS = ['#161616', '#DE482B', '#4A6B53', '#B87333', '#5E5246', '#8A6E53'];

  return (
    <div className="glass-card rounded-3xl p-6 sm:p-7 shadow-xs">
      <div className="flex items-center justify-between mb-5">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <h3 className="font-display font-black text-base text-[#141414]">
              {t('dashboard.regional_reach', 'Student Intake Breakdown')}
            </h3>
            <span className="inline-flex items-center gap-1 text-[10px] font-black uppercase tracking-wider text-[#554E44] bg-black/[0.05] px-2 py-0.5 rounded-full">
              <PieIcon className="w-3 h-3 text-[#DE482B]" />
              Education Stage
            </span>
          </div>
          <p className="text-xs text-[#6B6256] font-medium">
            Distribution by educational stage and aspiration track
          </p>
        </div>
      </div>

      <div className="h-60 w-full flex items-center justify-center">
        {chartData.length === 0 ? (
          <div className="text-center p-6 space-y-2">
            <div className="w-10 h-10 rounded-2xl bg-black/[0.04] text-[#8A7E72] flex items-center justify-center mx-auto">
              <PieIcon className="w-5 h-5 text-[#8A7E72]" />
            </div>
            <p className="text-xs font-bold text-[#554E44]">Awaiting Student Intakes</p>
            <p className="text-[11px] text-[#8A7E72] max-w-xs">
              Educational stage distribution will automatically plot as students are enrolled.
            </p>
          </div>
        ) : (
          <ResponsiveContainer width="100%" height="100%">
            <PieChart>
              <Pie
                data={chartData}
                cx="50%"
                cy="48%"
                innerRadius={50}
                outerRadius={80}
                paddingAngle={4}
                dataKey="value"
                stroke="rgba(255,255,255,0.7)"
                strokeWidth={2}
              >
                {chartData.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <Tooltip
                contentStyle={{
                  backgroundColor: 'rgba(20, 20, 20, 0.95)',
                  backdropFilter: 'blur(12px)',
                  borderRadius: '16px',
                  color: '#FFFFFF',
                  fontSize: '12px',
                  fontWeight: 600,
                  border: '1px solid rgba(255,255,255,0.15)',
                  boxShadow: '0 12px 32px rgba(0,0,0,0.25)'
                }}
              />
              <Legend
                wrapperStyle={{ fontSize: '11px', fontWeight: 600, paddingTop: '10px' }}
                formatter={(value) => <span className="text-[#3A332C]">{value}</span>}
              />
            </PieChart>
          </ResponsiveContainer>
        )}
      </div>
    </div>
  );
}
