import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { ResponsiveContainer, PieChart, Pie, Cell, Tooltip, Legend } from 'recharts';

export default function RegionalReachChart({ students }) {
  const { t } = useLanguage();

  // Aggregate by education stage
  const countsByGrade = (students || []).reduce((acc, curr) => {
    const key = curr.education_level_label || 'Grade 10th';
    acc[key] = (acc[key] || 0) + 1;
    return acc;
  }, {});

  const data = Object.keys(countsByGrade).map(key => ({
    name: key,
    value: countsByGrade[key]
  }));

  const COLORS = ['#173F6B', '#D97706', '#059669', '#7C3AED', '#DC2626', '#475569'];

  return (
    <div className="bg-white rounded-xl border border-slate-200 p-5 shadow-xs">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="font-bold text-sm text-slate-900 font-indic">
            Student Intake Breakdown
          </h3>
          <p className="text-[11px] text-slate-500 font-indic">
            Distribution by educational stage and aspiration track
          </p>
        </div>
      </div>

      <div className="h-56 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <PieChart>
            <Pie
              data={data.length > 0 ? data : [{ name: 'Class 10th', value: 8 }]}
              cx="50%"
              cy="50%"
              innerRadius={45}
              outerRadius={75}
              paddingAngle={4}
              dataKey="value"
            >
              {data.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
              ))}
            </Pie>
            <Tooltip
              contentStyle={{
                backgroundColor: '#0F172A',
                borderRadius: '8px',
                color: '#FFFFFF',
                fontSize: '12px',
                border: 'none'
              }}
            />
            <Legend
              wrapperStyle={{ fontSize: '11px', paddingTop: '10px' }}
              formatter={(value) => <span className="text-slate-700 font-indic">{value}</span>}
            />
          </PieChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
