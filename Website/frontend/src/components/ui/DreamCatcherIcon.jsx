import React from 'react';

/**
 * DreamCatcherIcon
 * Vector SVG matching the clean minimalist Dreamcatcher artwork.
 */
export default function DreamCatcherIcon({ className = "w-6 h-6", color = "currentColor" }) {
  return (
    <svg
      viewBox="0 0 100 100"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      {/* Top hanging eyelet & stem */}
      <circle cx="50" cy="8" r="3" fill={color} />
      <path d="M50 11V16" stroke={color} strokeWidth="3" strokeLinecap="round" />
      <path d="M47 16H53" stroke={color} strokeWidth="2.5" strokeLinecap="round" />

      {/* Main outer hoop */}
      <circle cx="50" cy="38" r="22" stroke={color} strokeWidth="4" />

      {/* Sacred geometric webbing (Flower of life petals) */}
      <g stroke={color} strokeWidth="1.4" opacity="0.75">
        <path d="M50 16C50 26 40 38 50 38C60 38 50 26 50 16Z" />
        <path d="M50 60C50 50 40 38 50 38C60 38 50 50 50 60Z" />
        <path d="M28 38C38 38 50 28 50 38C50 48 38 38 28 38Z" />
        <path d="M72 38C62 38 50 28 50 38C50 48 62 38 72 38Z" />
        <path d="M34.4 22.4C41.5 29.5 43 45 50 38C57 31 41.5 15.3 34.4 22.4Z" />
        <path d="M65.6 53.6C58.5 46.5 57 31 50 38C43 45 58.5 60.7 65.6 53.6Z" />
        <path d="M65.6 22.4C58.5 29.5 43 31 50 38C57 45 72.7 29.5 65.6 22.4Z" />
        <path d="M34.4 53.6C41.5 46.5 57 45 50 38C43 31 27.3 46.5 34.4 53.6Z" />
      </g>

      {/* Web boundary connection beads */}
      <circle cx="50" cy="18" r="1.8" fill={color} />
      <circle cx="50" cy="58" r="1.8" fill={color} />
      <circle cx="30" cy="38" r="1.8" fill={color} />
      <circle cx="70" cy="38" r="1.8" fill={color} />
      <circle cx="35.9" cy="23.9" r="1.8" fill={color} />
      <circle cx="64.1" cy="52.1" r="1.8" fill={color} />
      <circle cx="64.1" cy="23.9" r="1.8" fill={color} />
      <circle cx="35.9" cy="52.1" r="1.8" fill={color} />

      {/* Center hub */}
      <circle cx="50" cy="38" r="3.2" fill={color} />

      {/* Hanging connection loops */}
      <circle cx="35" cy="59" r="1.5" fill={color} />
      <circle cx="50" cy="62" r="1.5" fill={color} />
      <circle cx="65" cy="59" r="1.5" fill={color} />

      {/* --- CENTER STRAND & FEATHER --- */}
      <path d="M50 63V76" stroke={color} strokeWidth="1.8" strokeLinecap="round" />
      <circle cx="50" cy="68" r="2.4" fill={color} />
      <circle cx="50" cy="74" r="2.4" fill={color} />
      {/* Center Feather */}
      <path
        d="M50 76C46 80 44 87 47 95C48 93 50 92 50 90C50 92 52 93 53 95C56 87 54 80 50 76Z"
        fill={color}
      />
      <path d="M50 77V91" stroke="#F7F4EE" strokeWidth="1" strokeLinecap="round" />

      {/* --- LEFT STRAND & FEATHER --- */}
      <path d="M35 60V73" stroke={color} strokeWidth="1.8" strokeLinecap="round" />
      <circle cx="35" cy="65" r="2.2" fill={color} />
      <circle cx="35" cy="71" r="2.2" fill={color} />
      {/* Left Feather */}
      <path
        d="M35 73C31 77 29 83 33 89C34 87 35 86 35 85C36 86 37 87 38 89C40 83 39 77 35 73Z"
        fill={color}
      />
      <path d="M35 74V86" stroke="#F7F4EE" strokeWidth="0.8" strokeLinecap="round" />

      {/* --- RIGHT STRAND & FEATHER --- */}
      <path d="M65 60V73" stroke={color} strokeWidth="1.8" strokeLinecap="round" />
      <circle cx="65" cy="65" r="2.2" fill={color} />
      <circle cx="65" cy="71" r="2.2" fill={color} />
      {/* Right Feather */}
      <path
        d="M65 73C61 77 59 83 63 89C64 87 65 86 65 85C66 86 67 87 68 89C70 83 69 77 65 73Z"
        fill={color}
      />
      <path d="M65 74V86" stroke="#F7F4EE" strokeWidth="0.8" strokeLinecap="round" />
    </svg>
  );
}
