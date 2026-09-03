import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { ResponsiveContainer, PieChart, Pie, Cell, Tooltip, Legend } from 'recharts';
import { PieChart as PieIcon } from 'lucide-react';

export default function RegionalReachChart({ students }) {
  const { t } = useLanguage();

  // Aggregate by education stage
  const countsByGrade = (students || []).reduce((acc, curr) => {
    const key = curr.education_level_label || 'Class 10th';
    acc[key] = (acc[key] || 0) + 1;
    return acc;
  }, {});

  const data = Object.keys(countsByGrade).map(key => ({
    name: key,
    value: countsByGrade[key]
  }));

  const chartData = data.length > 0 ? data : [
    { name: 'Class 10th (SSC)', value: 18 },
    { name: 'ITI Trade Aspirant', value: 9 },
    { name: 'Diploma Poly', value: 7 },
    { name: 'Class 12th', value: 4 }
  ];

  // Curated, warm aesthetic palette matching DreamCatcher
  const COLORS = ['#161616', '#DE482B', '#4A6B53', '#B87333', '#5E5246'];

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

      <div className="h-60 w-full">
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
      </div>
    </div>
  );
}
