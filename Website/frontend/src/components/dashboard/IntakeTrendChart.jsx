import React from 'react';
import { useLanguage } from '../../context/LanguageContext';
import { ResponsiveContainer, BarChart, Bar, XAxis, YAxis, Tooltip, CartesianGrid } from 'recharts';
import { TrendingUp } from 'lucide-react';

export default function IntakeTrendChart({ data, students = [] }) {
  const { t } = useLanguage();

  const chartData = React.useMemo(() => {
    if (data && data.length > 0) return data;
    if (!students || students.length === 0) {
      return [
        { month: 'Prior', students: 0 },
        { month: 'Current', students: 0 }
      ];
    }

    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const currentMonthIdx = new Date().getMonth();
    const countsByMonth = {};

    // Populate last 3 months
    for (let i = 2; i >= 0; i--) {
      const idx = (currentMonthIdx - i + 12) % 12;
      countsByMonth[monthNames[idx]] = 0;
    }

    students.forEach(s => {
      const d = s.created_at ? new Date(s.created_at) : new Date();
      const m = monthNames[d.getMonth()];
      if (countsByMonth[m] !== undefined) {
        countsByMonth[m] += 1;
      } else {
        countsByMonth[m] = 1;
      }
    });

    return Object.keys(countsByMonth).map(m => ({
      month: m === monthNames[currentMonthIdx] ? `${m} (Current)` : m,
      students: countsByMonth[m]
    }));
  }, [data, students]);

  const totalStudents = students.length;
  const badgeLabel = totalStudents > 0 ? `${totalStudents} Intakes Recorded` : 'Intake Ready';

  return (
    <div className="glass-card rounded-3xl p-6 sm:p-7 shadow-xs">
      <div className="flex items-center justify-between mb-5">
        <div>
          <div className="flex items-center gap-2 mb-1">
            <h3 className="font-display font-black text-base text-[#141414]">
              {t('dashboard.monthly_trend', 'Student Intake Velocity')}
            </h3>
            <span className="inline-flex items-center gap-1 text-[10px] font-black uppercase tracking-wider text-emerald-700 bg-emerald-50 border border-emerald-200 px-2 py-0.5 rounded-full">
              <TrendingUp className="w-3 h-3" />
              {badgeLabel}
            </span>
          </div>
          <p className="text-xs text-[#6B6256] font-medium">
            Active counseling registrations across field camps
          </p>
        </div>
      </div>

      <div className="h-60 w-full">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={chartData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
            <defs>
              <linearGradient id="barGradient" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#181818" stopOpacity={1} />
                <stop offset="100%" stopColor="#383838" stopOpacity={0.85} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#EAE3D7" />
            <XAxis dataKey="month" tick={{ fontSize: 11, fill: '#7A6F62', fontWeight: 600 }} axisLine={false} tickLine={false} />
            <YAxis tick={{ fontSize: 11, fill: '#7A6F62', fontWeight: 600 }} axisLine={false} tickLine={false} />
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
            <Bar dataKey="students" fill="url(#barGradient)" radius={[8, 8, 2, 2]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
