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

  const COLORS = ['#111111', '#2563EB', '#059669', '#7C3AED', '#D97706', '#E11D48'];

  return (
    <div className="card-soft p-5 bg-white">
      <div className="flex items-center justify-between mb-4">
        <div>
          <h3 className="font-bold text-sm text-neutral-900">
            Student Intake Breakdown
          </h3>
          <p className="text-[11px] text-neutral-500 font-normal">
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
                backgroundColor: '#111111',
                borderRadius: '10px',
                color: '#FFFFFF',
                fontSize: '12px',
                border: 'none',
                boxShadow: '0 8px 24px rgba(0,0,0,0.15)'
              }}
            />
            <Legend
              wrapperStyle={{ fontSize: '11px', paddingTop: '10px' }}
              formatter={(value) => <span className="text-neutral-700">{value}</span>}
            />
          </PieChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
