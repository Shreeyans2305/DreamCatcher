import React, { useState } from 'react';
import { 
  Volume2, 
  VolumeX, 
  Sparkles, 
  User, 
  Award, 
  ArrowRight,
  Target,
  Lightbulb,
  AlertTriangle,
  CheckCircle2,
  ExternalLink
} from 'lucide-react';

/**
 * Rich Formatter for AI Counselor responses:
 * Converts Markdown headings, bold/italic syntax, links, bullet lists, 
 * and special alert/callout blocks (🎯, 💡, ⚠️, 📌) into beautifully rendered
 * Indic Zen cards and styled typography.
 */
function FormattedMessageBody({ text, isAi }) {
  if (!text) return null;

  // Inline formatting helper for links, bold, italic, and code
  const formatInline = (str) => {
    if (!str) return null;

    // Matches [label](url) | **bold** | *italic* | `code`
    const regex = /(\[[^\]]+\]\([^)]+\)|\*\*[^*]+\*\*|\*[^*]+\*|`[^`]+`)/g;
    const parts = str.split(regex);

    return parts.map((part, idx) => {
      if (!part) return null;

      // 1. Markdown Links [label](url)
      const linkMatch = part.match(/^\[([^\]]+)\]\(([^)]+)\)$/);
      if (linkMatch) {
        const [, label, url] = linkMatch;
        return (
          <a
            key={idx}
            href={url}
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-1 font-bold text-[#A83E28] hover:underline underline-offset-2 transition-colors"
          >
            <span>{label}</span>
            <ExternalLink className="w-3 h-3 shrink-0 inline opacity-80" />
          </a>
        );
      }

      // 2. Bold **text**
      if (part.startsWith('**') && part.endsWith('**') && part.length >= 4) {
        return (
          <strong key={idx} className={isAi ? "font-extrabold text-[#1F1F1F]" : "font-extrabold text-white"}>
            {part.slice(2, -2)}
          </strong>
        );
      }

      // 3. Italic *text*
      if (part.startsWith('*') && part.endsWith('*') && part.length >= 2) {
        return (
          <em key={idx} className={isAi ? "italic text-[#4A4237]" : "italic text-neutral-200"}>
            {part.slice(1, -1)}
          </em>
        );
      }

      // 4. Code `code`
      if (part.startsWith('`') && part.endsWith('`') && part.length >= 2) {
        return (
          <code key={idx} className="px-1.5 py-0.5 bg-black/5 rounded font-mono text-xs text-[#A83E28]">
            {part.slice(1, -1)}
          </code>
        );
      }

      return part;
    });
  };

  // Helper to detect alert type from a line
  const detectAlertType = (line) => {
    if (line.startsWith('🎯') || line.startsWith('> [!TARGET]') || /^(\*\*|#+\s*)?(Recommended Pathway|शिफारस केलेला मार्ग|अनुशंसित करियर मार्ग)/i.test(line)) {
      return 'target';
    }
    if (line.startsWith('💡') || line.startsWith('> [!TIP]') || line.startsWith('> [!NOTE]') || /^(\*\*|#+\s*)?(Officer Guidance|Counselor Advice|Counselor Guidance|सल्ला|मार्गदर्शन|परामर्श)/i.test(line)) {
      return 'guidance';
    }
    if (line.startsWith('⚠️') || line.startsWith('> [!WARNING]') || line.startsWith('> [!CAUTION]') || /^(\*\*|#+\s*)?(Important Criteria|Eligibility Notice|Important Notice|महत्त्वाचे निकष|पात्रता सूचना)/i.test(line)) {
      return 'warning';
    }
    if (line.startsWith('📌') || line.startsWith('📋') || line.startsWith('> [!IMPORTANT]') || /^(\*\*|#+\s*)?(Key Steps|Action Plan|पुढील पायऱ्या|कार्ययोजना)/i.test(line)) {
      return 'action';
    }
    return null;
  };

  // Clean initial line: strip alert prefix and redundant label text
  const cleanAlertLine = (line, type) => {
    let cleaned = line
      .replace(/^🎯\s*/, '')
      .replace(/^💡\s*/, '')
      .replace(/^⚠️\s*/, '')
      .replace(/^[📌📋]\s*/, '')
      .replace(/^>\s*\[!(TARGET|TIP|NOTE|WARNING|CAUTION|IMPORTANT)\]\s*/i, '');

    // Strip redundant leading bold header like "**Recommended Pathway:**" or "**सल्ला:**"
    cleaned = cleaned.replace(/^\*\*(Recommended Pathway|शिफारस केलेला मार्ग|अनुशंसित करियर मार्ग|Officer Guidance|Counselor Advice|Counselor Guidance|सल्ला|सल्ला व मार्गदर्शन|मार्गदर्शन|परामर्श|Important Criteria|Eligibility Notice|Important Notice|महत्त्वाचे निकष|महत्त्वाचे निकष व पात्रता|पात्रता सूचना|Key Steps|Action Plan|पुढील पायऱ्या|कार्ययोजना)[:]?\*\*\s*[:]?\s*/i, '');
    
    return cleaned.trim();
  };

  // Alert titles & metadata
  const alertMeta = {
    target: {
      title: 'Recommended Career Pathway (शिफारस केलेला मार्ग)',
      icon: Target,
      cardClass: 'bg-emerald-50/90 border border-emerald-300/90 text-emerald-950',
      titleClass: 'text-emerald-900',
      iconClass: 'text-emerald-700',
      bodyClass: 'text-emerald-950 font-medium'
    },
    guidance: {
      title: 'Counselor Advice & Guidance (सल्ला व मार्गदर्शन)',
      icon: Lightbulb,
      cardClass: 'bg-[#FFF9EE] border-l-4 border-amber-500 border-t border-r border-b border-amber-200/70 text-amber-950',
      titleClass: 'text-amber-900',
      iconClass: 'text-amber-600',
      bodyClass: 'text-amber-950 font-medium'
    },
    warning: {
      title: 'Important Criteria & Eligibility Notice (महत्त्वाचे निकष)',
      icon: AlertTriangle,
      cardClass: 'bg-rose-50/90 border border-rose-300 text-rose-950',
      titleClass: 'text-rose-900',
      iconClass: 'text-rose-600',
      bodyClass: 'text-rose-950 font-medium'
    },
    action: {
      title: 'Action Plan & Next Steps (कृती आराखडा व पुढील पायऱ्या)',
      icon: CheckCircle2,
      cardClass: 'bg-sky-50/90 border border-sky-300 text-sky-950',
      titleClass: 'text-sky-900',
      iconClass: 'text-sky-600',
      bodyClass: 'text-sky-950 font-medium'
    }
  };

  const lines = text.split('\n');
  const blocks = [];
  let i = 0;

  while (i < lines.length) {
    const rawLine = lines[i];
    const line = rawLine.trim();

    if (!line) {
      i++;
      continue;
    }

    // 1. Alert Block Detection (Handles multi-line alerts seamlessly)
    const alertType = detectAlertType(line);
    if (alertType) {
      const alertLines = [];
      const cleanedInitial = cleanAlertLine(line, alertType);
      if (cleanedInitial) {
        alertLines.push(cleanedInitial);
      }
      i++;

      // Collect all subsequent lines that belong inside this alert card
      while (i < lines.length) {
        const nextRaw = lines[i];
        const nextTrim = nextRaw.trim();

        // Empty line check
        if (!nextTrim) {
          // Lookahead: If followed by another alert or heading, stop this block
          let j = i + 1;
          while (j < lines.length && !lines[j].trim()) j++;
          if (j < lines.length && (detectAlertType(lines[j].trim()) || lines[j].trim().startsWith('#'))) {
            break;
          }
          if (alertLines.length > 0) {
            alertLines.push('');
          }
          i++;
          continue;
        }

        // Stop if another alert or heading is reached
        if (detectAlertType(nextTrim) || nextTrim.startsWith('#')) {
          break;
        }

        alertLines.push(nextTrim);
        i++;
      }

      blocks.push({
        type: 'alert',
        alertType,
        content: alertLines.join('\n').trim()
      });
      continue;
    }

    // 2. Headings (###, ##, #)
    if (line.startsWith('#')) {
      const headingText = line.replace(/^#+\s*/, '');
      blocks.push({
        type: 'heading',
        content: headingText
      });
      i++;
      continue;
    }

    // 3. Lists (Bulleted or Numbered)
    if (line.startsWith('- ') || line.startsWith('* ') || line.startsWith('• ') || /^\d+\.\s/.test(line)) {
      const isNumbered = /^\d+\.\s/.test(line);
      const items = [];
      while (i < lines.length) {
        const itemTrim = lines[i].trim();
        if (!itemTrim) {
          i++;
          break;
        }
        if (itemTrim.startsWith('- ') || itemTrim.startsWith('* ') || itemTrim.startsWith('• ')) {
          items.push(itemTrim.slice(2).trim());
          i++;
          continue;
        } else if (/^\d+\.\s/.test(itemTrim)) {
          items.push(itemTrim.replace(/^\d+\.\s/, '').trim());
          i++;
          continue;
        }
        break;
      }
      blocks.push({
        type: 'list',
        isNumbered,
        items
      });
      continue;
    }

    // 4. Regular Paragraph
    blocks.push({
      type: 'paragraph',
      content: rawLine
    });
    i++;
  }

  return (
    <div className="space-y-2.5">
      {blocks.map((block, idx) => {
        // Render Alert Cards
        if (block.type === 'alert') {
          const config = alertMeta[block.alertType] || alertMeta.guidance;
          const IconComponent = config.icon;
          return (
            <div 
              key={`alert-${idx}`}
              className={`my-3 p-4 rounded-2xl shadow-2xs space-y-1.5 transition-all ${config.cardClass}`}
            >
              <div className={`flex items-center gap-1.5 font-extrabold text-xs sm:text-sm tracking-tight ${config.titleClass}`}>
                <IconComponent className={`w-4 h-4 shrink-0 ${config.iconClass}`} />
                <span>{config.title}</span>
              </div>
              {block.content && (
                <div className={`leading-relaxed pl-5 text-xs sm:text-sm whitespace-pre-line ${config.bodyClass}`}>
                  {formatInline(block.content)}
                </div>
              )}
            </div>
          );
        }

        // Render Headings
        if (block.type === 'heading') {
          return (
            <div key={`h-${idx}`} className="font-extrabold font-serif-zen text-sm sm:text-base text-[#1F1F1F] mt-3.5 mb-1.5">
              {formatInline(block.content)}
            </div>
          );
        }

        // Render Lists
        if (block.type === 'list') {
          if (block.isNumbered) {
            return (
              <ol key={`list-${idx}`} className="my-2.5 space-y-1.5 pl-1">
                {block.items.map((item, itemIdx) => (
                  <li key={itemIdx} className="flex items-start gap-2 text-xs sm:text-sm leading-relaxed">
                    <span className="w-5 h-5 rounded-full bg-[#FAF7F2] border border-[#DECBC7] text-[#A83E28] font-bold text-[10px] flex items-center justify-center shrink-0 mt-0.5">
                      {itemIdx + 1}
                    </span>
                    <span className="pt-0.5">{formatInline(item)}</span>
                  </li>
                ))}
              </ol>
            );
          }
          return (
            <ul key={`list-${idx}`} className="my-2.5 space-y-1.5 pl-1">
              {block.items.map((item, itemIdx) => (
                <li key={itemIdx} className="flex items-start gap-2 text-xs sm:text-sm leading-relaxed">
                  <span className="w-1.5 h-1.5 rounded-full bg-[#A83E28] shrink-0 mt-2" />
                  <span>{formatInline(item)}</span>
                </li>
              ))}
            </ul>
          );
        }

        // Render Paragraph
        return (
          <p key={`p-${idx}`} className="leading-relaxed text-xs sm:text-sm">
            {formatInline(block.content)}
          </p>
        );
      })}
    </div>
  );
}

export default function GuidanceMessage({ message, student, onSelectChip }) {
  const [isPlayingAudio, setIsPlayingAudio] = useState(false);
  const isAi = message.sender === 'ai';

  const handleAudioPlayback = () => {
    if ('speechSynthesis' in window) {
      if (isPlayingAudio) {
        window.speechSynthesis.cancel();
        setIsPlayingAudio(false);
      } else {
        const cleanText = message.text.replace(/[*#🎯💡⚠️]/g, '');
        const utterance = new SpeechSynthesisUtterance(cleanText);
        const langCode = student?.preferred_language || 'mr';
        if (langCode === 'hi') utterance.lang = 'hi-IN';
        else if (langCode === 'mr') utterance.lang = 'mr-IN';
        else if (langCode === 'gu') utterance.lang = 'gu-IN';
        else utterance.lang = 'en-IN';

        utterance.onend = () => setIsPlayingAudio(false);
        utterance.onerror = () => setIsPlayingAudio(false);

        setIsPlayingAudio(true);
        window.speechSynthesis.speak(utterance);
      }
    } else {
      alert('Text-to-speech audio simulation not supported on this browser.');
    }
  };

  return (
    <div className={`flex gap-3 ${isAi ? 'justify-start' : 'justify-end'} animate-in fade-in duration-200`}>
      
      {/* AI Avatar */}
      {isAi && (
        <div className="w-8 h-8 rounded-xl bg-[#222222] text-amber-300 flex items-center justify-center shrink-0 mt-1 shadow-xs border border-amber-400/20">
          <Sparkles className="w-4 h-4" />
        </div>
      )}

      {/* Message Bubble */}
      <div className={`max-w-2xl rounded-2xl p-4 sm:p-5 shadow-xs transition-all ${
        isAi 
          ? 'bg-white border border-[#DECBC7] text-[#1F1F1F]' 
          : 'bg-[#222222] text-white rounded-tr-xs shadow-sm'
      }`}>
        
        {/* Content with Markdown & Alert Callout Box rendering */}
        <FormattedMessageBody text={message.text} isAi={isAi} />

        {/* AI Pathway & Scheme Highlights */}
        {isAi && (
          <>
            {/* Real Government Opportunity Cards */}
            {message.opportunities && message.opportunities.length > 0 && (
              <div className="mt-3.5 pt-3.5 border-t border-[#DECBC7]/60 space-y-2.5">
                <span className="text-[10px] uppercase tracking-wider font-extrabold text-[#8C8275] block flex items-center gap-1.5">
                  <Award className="w-3.5 h-3.5 text-[#A83E28]" />
                  <span>Verified Government Opportunities & Recruitment:</span>
                </span>
                <div className="space-y-2">
                  {message.opportunities.map((opp, idx) => (
                    <div 
                      key={idx}
                      className="bg-[#FAF7F2] border border-[#DECBC7] rounded-xl p-3.5 text-xs space-y-1.5 transition-all hover:border-[#A83E28]/50 hover:shadow-xs"
                    >
                      <div className="flex items-start justify-between gap-2">
                        <div>
                          <div className="flex items-center gap-1.5 flex-wrap">
                            <span className="font-extrabold text-[#1F1F1F] text-xs sm:text-sm">{opp.title}</span>
                            <span className="bg-[#A83E28]/10 text-[#A83E28] text-[9px] font-bold px-2 py-0.5 rounded-full border border-[#A83E28]/20">
                              {opp.type}
                            </span>
                          </div>
                          {opp.match_reason && (
                            <p className="text-[11px] text-[#5C5245] mt-1 leading-snug">
                              {opp.match_reason}
                            </p>
                          )}
                        </div>
                        {opp.official_url && (
                          <a
                            href={opp.official_url}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="p-1.5 bg-white border border-[#D5CCBD] hover:bg-[#222222] hover:text-white rounded-lg text-neutral-700 shrink-0 transition-colors shadow-2xs flex items-center gap-1"
                            title="Open Official Portal"
                          >
                            <ExternalLink className="w-3.5 h-3.5" />
                          </a>
                        )}
                      </div>
                      {opp.deadline && (
                        <div className="flex items-center gap-1 text-[10px] text-amber-900 font-semibold bg-amber-50/90 px-2 py-0.5 rounded-md w-fit border border-amber-200/60">
                          <span>Deadline: {opp.deadline}</span>
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Suggested Action Chips below message */}
            {message.suggested_actions && message.suggested_actions.length > 0 && onSelectChip && (
              <div className="mt-3.5 pt-3 border-t border-[#DECBC7]/60">
                <span className="text-[10px] font-extrabold text-[#8C8275] uppercase tracking-wider block mb-1.5 flex items-center gap-1">
                  <Sparkles className="w-3 h-3 text-[#A83E28]" />
                  <span>Suggested Questions (Tap to ask):</span>
                </span>
                <div className="flex flex-wrap gap-1.5">
                  {message.suggested_actions.map((chip, idx) => (
                    <button
                      key={idx}
                      type="button"
                      onClick={() => onSelectChip(chip)}
                      className="text-xs bg-[#FAF7F2] hover:bg-[#222222] hover:text-white text-[#38332C] border border-[#DECBC7] px-3 py-1.5 rounded-full font-semibold transition-all cursor-pointer shadow-2xs flex items-center gap-1.5 active:scale-95"
                    >
                      <Sparkles className="w-3 h-3 text-[#A83E28]" />
                      <span>{chip}</span>
                    </button>
                  ))}
                </div>
              </div>
            )}
          </>
        )}

        {/* Footer: Audio Read-aloud & Timestamp */}
        {isAi && (
          <div className="mt-2.5 pt-2 flex items-center justify-between border-t border-black/5 text-[10px] text-neutral-400">
            <button
              onClick={handleAudioPlayback}
              className={`flex items-center gap-1 font-semibold px-2.5 py-1 rounded-full transition-colors cursor-pointer ${
                isPlayingAudio ? 'bg-amber-100 text-amber-900' : 'hover:bg-neutral-100 text-neutral-700'
              }`}
            >
              {isPlayingAudio ? <VolumeX className="w-3.5 h-3.5 text-amber-700" /> : <Volume2 className="w-3.5 h-3.5 text-neutral-800" />}
              <span>{isPlayingAudio ? 'Stop Audio' : 'Read Aloud (ऑडिओ ऐका)'}</span>
            </button>
            <span>{new Date(message.timestamp).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
          </div>
        )}

      </div>

      {/* User Avatar */}
      {!isAi && (
        <div className="w-8 h-8 rounded-xl bg-neutral-200 text-neutral-800 flex items-center justify-center shrink-0 mt-1 shadow-xs font-bold text-xs">
          <User className="w-4 h-4" />
        </div>
      )}

    </div>
  );
}
