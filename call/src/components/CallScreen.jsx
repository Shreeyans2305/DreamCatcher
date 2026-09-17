import { useEffect, useRef, useState } from 'react';
import {
  Battery, ChevronDown, Contact, ExternalLink, Grid3X3, Mic, MicOff,
  Languages, MessageSquareText, Phone, PhoneCall, Plus, Search, Send, Signal, Speaker, Video, Wifi, X, Volume2, VolumeX,
} from 'lucide-react';
import { useCallTimer } from '../hooks/useCallTimer';
import {
  audioFormatToMime, blobToBase64, blobToLinear16Wav,
  playCallTone, playDTMFTone, speakWithBrowserTTS, startBrowserSpeechRecognition, stopBrowserTTS,
} from '../utils/audio';

const controls = [
  { id: 'mute', label: 'mute', icon: Mic },
  { id: 'keypad', label: 'keypad', icon: Grid3X3 },
  { id: 'speaker', label: 'speaker', icon: Speaker },
  { id: 'add_call', label: 'add call', icon: Plus },
  { id: 'facetime', label: 'FaceTime', icon: Video },
  { id: 'contacts', label: 'contacts', icon: Contact },
];

const languages = [
  { code: 'hi', label: 'हिन्दी (Hindi)', speech: 'hi-IN' },
  { code: 'mr', label: 'मराठी (Marathi)', speech: 'mr-IN' },
  { code: 'en', label: 'English', speech: 'en-IN' },
  { code: 'bn', label: 'বাংলা (Bengali)', speech: 'bn-IN' },
  { code: 'gu', label: 'ગુજરાતી (Gujarati)', speech: 'gu-IN' },
  { code: 'or', label: 'ଓଡ଼ିଆ (Odia)', speech: 'or-IN' },
  { code: 'ta', label: 'தமிழ் (Tamil)', speech: 'ta-IN' },
  { code: 'te', label: 'తెలుగు (Telugu)', speech: 'te-IN' },
  { code: 'kn', label: 'ಕನ್ನಡ (Kannada)', speech: 'kn-IN' },
];

const openingPrompts = {
  hi: 'नमस्ते, मैं ड्रीमकैचर से आपकी गाइड प्रगति हूँ। आपका नाम और गांव क्या है?',
  mr: 'नमस्कार, मी ड्रीमकॅचरची तुमची गाईड प्रगती. तुमचे नाव आणि गाव काय आहे?',
  bn: 'নমস্কার, আমি ড্রিমক্যাচারের গাইড প্রগতি। আপনার নাম ও গ্রাম কী?',
  ta: 'வணக்கம், நான் ட்ரீம்கேச்சரின் வழிகாட்டி பிரகதி. உங்கள் பெயர் மற்றும் ஊர் என்ன?',
  te: 'నమస్కారం, నేను డ్రీమ్‌క్యాచర్ గైడ్ ప్రగతిని. మీ పేరు మరియు ఊరు ఏమిటి?',
  kn: 'ನಮಸ್ಕಾರ, ನಾನು ಡ್ರೀಮ್‌ಕ್ಯಾಚರ್ ಮಾರ್ಗದರ್ಶಿ ಪ್ರಗತಿ. ನಿಮ್ಮ ಹೆಸರು ಮತ್ತು ಊರು ಯಾವುದು?',
  or: 'ନମସ୍କାର, ମୁଁ ଡ୍ରିମକ୍ୟାଚରର ଗାଇଡ୍ ପ୍ରଗତି। ଆପଣଙ୍କ ନାମ ଏବଂ ଗାଁ କିମ୍ବା ସହର କଣ?',
  en: 'Namaste, I am Pragati from DreamCatcher. What is your name and village or town?',
};

const KEYPAD_KEYS = [
  { key: '1', sub: '' },
  { key: '2', sub: 'ABC' },
  { key: '3', sub: 'DEF' },
  { key: '4', sub: 'GHI' },
  { key: '5', sub: 'JKL' },
  { key: '6', sub: 'MNO' },
  { key: '7', sub: 'PQRS' },
  { key: '8', sub: 'TUV' },
  { key: '9', sub: 'WXYZ' },
  { key: '*', sub: '' },
  { key: '0', sub: '+' },
  { key: '#', sub: '' },
];

function StatusBar() {
  const [time, setTime] = useState('9:41');

  useEffect(() => {
    const update = () => {
      const now = new Date();
      const h = now.getHours().toString().padStart(2, '0');
      const m = now.getMinutes().toString().padStart(2, '0');
      setTime(`${h}:${m}`);
    };
    update();
    const timer = setInterval(update, 30000);
    return () => clearInterval(timer);
  }, []);

  return (
    <header className="status-bar">
      <span>{time}</span>
      <div className="status-icons">
        <Signal size={14} strokeWidth={2.5} />
        <Wifi size={15} strokeWidth={2.5} />
        <Battery size={20} strokeWidth={2.2} />
      </div>
    </header>
  );
}

function Avatar({ name, avatarUrl, large = false, pulse = false }) {
  const initials = name
    .split(' ')
    .map((part) => part[0])
    .join('')
    .slice(0, 2);

  return (
    <div className={`avatar-container ${large ? 'avatar-large-container' : ''}`}>
      {pulse && <div className="pulse-ring" />}
      {avatarUrl ? (
        <img className={`avatar ${large ? 'avatar-large' : ''}`} src={avatarUrl} alt="" />
      ) : (
        <div className={`avatar avatar-fallback ${large ? 'avatar-large' : ''}`} aria-label={`${name} avatar`}>
          {initials}
        </div>
      )}
    </div>
  );
}

function KeypadModal({ isOpen, onClose, onKeyClick }) {
  const [digits, setDigits] = useState('');

  if (!isOpen) return null;

  const handleKey = (key) => {
    playDTMFTone(key);
    setDigits((prev) => prev + key);
    onKeyClick?.(key);
  };

  return (
    <div className="keypad-overlay" onClick={onClose}>
      <div className="keypad-modal" onClick={(e) => e.stopPropagation()}>
        <div className="keypad-header">
          <div className="keypad-display">{digits || 'Dial Keypad'}</div>
          <button className="keypad-close" onClick={onClose} aria-label="Close keypad">
            <X size={20} />
          </button>
        </div>
        <div className="keypad-grid">
          {KEYPAD_KEYS.map(({ key, sub }) => (
            <button key={key} className="keypad-btn" onClick={() => handleKey(key)}>
              <span className="keypad-num">{key}</span>
              {sub && <span className="keypad-sub">{sub}</span>}
            </button>
          ))}
        </div>
        <div className="keypad-actions">
          {digits && (
            <button className="keypad-clear" onClick={() => setDigits('')}>
              Clear
            </button>
          )}
          <button className="keypad-hide-btn" onClick={onClose}>
            Hide Keypad
          </button>
        </div>
      </div>
    </div>
  );
}

function SpeakingWave({ isRecording, conversationStatus }) {
  const isSpeaking = conversationStatus.includes('speaking');
  const label = isRecording ? 'You are speaking' : isSpeaking ? 'Pragati is speaking' : 'Listening for you';

  return (
    <div className={`speaking-indicator ${isRecording || isSpeaking ? 'active' : ''}`} aria-live="polite">
      <div className="waveform" aria-hidden="true">
        {Array.from({ length: 15 }, (_, index) => <i key={index} style={{ '--bar-index': index }} />)}
      </div>
      <span>{label}</span>
    </div>
  );
}

function TranscriptPanel({ messages, opportunities, messageDraft, setMessageDraft, submitDraft, conversationEndRef, open, onToggle }) {
  return (
    <aside className={`transcript-panel ${open ? 'open' : ''}`}>
      <button className="transcript-toggle" onClick={onToggle} aria-expanded={open}>
        <MessageSquareText size={17} />
        <span>View transcript</span>
        <ChevronDown size={17} className="transcript-chevron" />
      </button>
      <div className="transcript-content">
        <div className="transcript-heading">
          <div>
            <span className="section-kicker">Live conversation</span>
            <h2>Transcript</h2>
          </div>
          <span className="live-dot">Live</span>
        </div>
        <div className="conversation">
          {messages.map((message, index) => (
            <div key={`${message.role}-${index}`} className={`${message.role}-bubble`}>
              <div className="bubble-label">{message.role === 'assistant' ? 'Pragati' : 'You'}</div>
              <div className="bubble-text">{message.text}</div>
            </div>
          ))}
          {opportunities.length > 0 && (
            <div className="opportunity-list">
              <h2>Recommended for You</h2>
              {opportunities.map((opp) => (
                <a href={opp.official_url || '#'} target="_blank" rel="noreferrer" key={opp.id} className="opportunity-card">
                  <div className="opp-info">
                    <span className="opp-title">{opp.title}</span>
                    <small className="opp-meta">{opp.type}{opp.deadline ? ` · Deadline ${opp.deadline}` : ''}</small>
                  </div>
                  <ExternalLink size={16} className="opp-link-icon" />
                </a>
              ))}
            </div>
          )}
          <div ref={conversationEndRef} />
        </div>
        <form className="text-message-form" onSubmit={submitDraft}>
          <input value={messageDraft} onChange={(e) => setMessageDraft(e.target.value)} placeholder="Type a message…" aria-label="Type your message" />
          <button type="submit" disabled={!messageDraft.trim()} aria-label="Send message"><Send size={16} /></button>
        </form>
      </div>
    </aside>
  );
}

export function CallScreen({
  contactName = 'DreamCatcher Counselling',
  contactLabel = 'AI Career Guide · Pragati',
  avatarUrl,
}) {
  const [callState, setCallState] = useState('language');
  const [language, setLanguage] = useState('hi');
  const [languageSearch, setLanguageSearch] = useState('');
  const [messages, setMessages] = useState([]);
  const [messageDraft, setMessageDraft] = useState('');
  const [opportunities, setOpportunities] = useState([]);
  const [conversationStatus, setConversationStatus] = useState('Call connected');
  const [conversationId, setConversationId] = useState(null);
  const [muted, setMuted] = useState(false);
  const [speakerOn, setSpeakerOn] = useState(true);
  const [showKeypad, setShowKeypad] = useState(false);
  const [showTranscript, setShowTranscript] = useState(false);
  const [isRecording, setIsRecording] = useState(false);
  const [recordingSeconds, setRecordingSeconds] = useState(0);
  const [audioError, setAudioError] = useState('');
  const [liveTranscript, setLiveTranscript] = useState('');

  const recorderRef = useRef(null);
  const streamRef = useRef(null);
  const chunksRef = useRef([]);
  const playbackRef = useRef(null);
  const isStartingRef = useRef(false);
  const shouldStopRef = useRef(false);
  const startTimeRef = useRef(0);
  const recordingTimerRef = useRef(null);
  const conversationEndRef = useRef(null);
  const speechRecognizerRef = useRef(null);
  const browserTranscriptRef = useRef('');

  // Base API URL helper guaranteed to include /api/v1
  const getApiBaseUrl = () => {
    const envUrl = import.meta.env.VITE_APP_BACKEND_URL;
    if (envUrl && typeof envUrl === 'string' && envUrl.trim()) {
      let url = envUrl.trim().replace(/\/+$/, '').replace(/\/assistant\/?$/, '').replace(/\/voice\/?$/, '');
      if (url.startsWith('/') && !url.startsWith('/api')) {
        return `/api/v1${url}`;
      }
      if (url.endsWith('/api')) {
        return `${url}/v1`;
      }
      if (!url.endsWith('/api/v1')) {
        return `${url}/api/v1`;
      }
      return url;
    }
    return '/api/v1';
  };

  const apiBaseUrl = getApiBaseUrl();

  const [studentId, setStudentId] = useState(
    () => import.meta.env.VITE_STUDENT_ID || null
  );
  const duration = useCallTimer(callState === 'active');
  const selectedLanguage = languages.find((item) => item.code === language) || languages[0];
  const visibleLanguages = languages.filter((item) => {
    const query = languageSearch.trim().toLowerCase();
    return !query || `${item.label} ${item.speech}`.toLowerCase().includes(query);
  });

  // Auto-scroll chat to bottom
  useEffect(() => {
    if (callState === 'active') {
      conversationEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }
  }, [messages, opportunities, conversationStatus, callState]);

  // Clean up streams & audio on unmount
  useEffect(() => {
    return () => {
      stopTracks();
      if (speechRecognizerRef.current) {
        try { speechRecognizerRef.current.stop(); } catch { /* ignore */ }
      }
      if (playbackRef.current) playbackRef.current.pause();
      stopBrowserTTS();
      if (recordingTimerRef.current) clearInterval(recordingTimerRef.current);
    };
  }, []);

  const stopTracks = () => {
    if (streamRef.current) {
      streamRef.current.getTracks().forEach((track) => track.stop());
      streamRef.current = null;
    }
  };

  const playVoiceResponse = async (audioBase64, audioFormat, textFallback) => {
    if (!speakerOn) {
      setConversationStatus('Call connected');
      return;
    }

    if (playbackRef.current) playbackRef.current.pause();
    stopBrowserTTS();

    if (audioBase64) {
      try {
        setConversationStatus('Pragati speaking…');
        const audio = new Audio(`data:${audioFormatToMime(audioFormat)};base64,${audioBase64}`);
        playbackRef.current = audio;
        audio.onended = () => {
          playbackRef.current = null;
          setConversationStatus('Call connected');
        };
        audio.onerror = () => {
          playbackRef.current = null;
          // Fallback to browser TTS if audio decoding fails
          speakWithBrowserTTS(
            textFallback,
            selectedLanguage.speech,
            () => setConversationStatus('Pragati speaking…'),
            () => setConversationStatus('Call connected'),
            () => setConversationStatus('Call connected')
          );
        };
        await audio.play();
        return;
      } catch (err) {
        console.warn('Audio playback failed, attempting browser TTS fallback', err);
      }
    }

    // Web Speech API fallback if backend TTS was not provided
    if (textFallback) {
      speakWithBrowserTTS(
        textFallback,
        selectedLanguage.speech,
        () => setConversationStatus('Pragati speaking…'),
        () => setConversationStatus('Call connected'),
        () => setConversationStatus('Call connected')
      );
    } else {
      setConversationStatus('Call connected');
    }
  };

  const processRecording = async (blob) => {
    setConversationStatus('Processing…');
    setAudioError('');
    try {
      const wav = await blobToLinear16Wav(blob);
      const token = import.meta.env.VITE_AUTH_TOKEN || localStorage.getItem('auth_token');

      // Attempt server voice query (with Gemini Multimodal backend STT)
      try {
        const response = await fetch(`${apiBaseUrl}/voice/query-base64`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            ...(token ? { Authorization: `Bearer ${token}` } : {}),
          },
          body: JSON.stringify({
            audio_data: await blobToBase64(wav.blob),
            language,
            conversation_id: conversationId,
            ...(studentId ? { student_id: studentId } : {}),
            audio_encoding: 'LINEAR16',
            sample_rate: wav.sampleRate,
          }),
        });

        if (response.status === 401) {
          localStorage.removeItem('auth_token');
          throw new Error('Your session expired. Please sign in again.');
        }

        if (response.ok) {
          const data = await response.json();
          if (data.user_transcript && data.user_transcript.trim()) {
            setMessages((current) => [
              ...current,
              { role: 'user', text: data.user_transcript },
              { role: 'assistant', text: data.ai_response },
            ]);

            if (data.referenced_opportunities && data.referenced_opportunities.length > 0) {
              setOpportunities(data.referenced_opportunities);
            }

            setConversationId(data.conversation_id);
            if (data.student_id) setStudentId(data.student_id);

            await playVoiceResponse(data.audio_response, data.audio_format, data.ai_response);
            return;
          }
        }
      } catch (backendVoiceErr) {
        console.warn('Backend voice query attempt notice:', backendVoiceErr);
      }

      // If backend voice query wasn't available, check if browser speech recognition captured transcript
      const capturedBrowserText = (browserTranscriptRef.current || speechRecognizerRef.current?.getTranscript?.() || '').trim();
      if (capturedBrowserText) {
        await sendMessage(capturedBrowserText);
        return;
      }

      throw new Error('Could not capture speech. Please speak clearly or type your message below.');
    } catch (error) {
      setAudioError(error.message || 'Failed to process voice turn.');
      setConversationStatus('Call connected');
    }
  };

  const startRecording = async () => {
    if (isRecording || isStartingRef.current || conversationStatus === 'Processing…' || conversationStatus === 'Pragati speaking…') {
      return;
    }

    if (muted) {
      setAudioError('Microphone is muted. Tap Mute to unmute.');
      return;
    }

    setAudioError('');
    setLiveTranscript('');
    isStartingRef.current = true;
    shouldStopRef.current = false;
    startTimeRef.current = Date.now();
    browserTranscriptRef.current = '';

    // 1. Start browser streaming STT immediately
    try {
      speechRecognizerRef.current = startBrowserSpeechRecognition(
        selectedLanguage.speech,
        (combined) => {
          if (combined && combined.trim()) {
            browserTranscriptRef.current = combined.trim();
            setLiveTranscript(combined.trim());
            setConversationStatus(`Listening: "${combined.trim()}"`);
          }
        },
        (sttErr) => {
          console.debug('Browser speech notice:', sttErr);
        },
        (finalText) => {
          if (finalText && finalText.trim()) {
            browserTranscriptRef.current = finalText.trim();
            setLiveTranscript(finalText.trim());
          }
        }
      );
    } catch (e) {
      console.debug('Browser recognition init notice:', e);
    }

    // 2. Start audio media recorder
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        audio: {
          echoCancellation: true,
          noiseSuppression: true,
          autoGainControl: true,
        },
      });

      if (shouldStopRef.current) {
        stream.getTracks().forEach((track) => track.stop());
        isStartingRef.current = false;
        return;
      }

      const mimeType = MediaRecorder.isTypeSupported('audio/webm;codecs=opus')
        ? 'audio/webm;codecs=opus'
        : MediaRecorder.isTypeSupported('audio/webm')
        ? 'audio/webm'
        : MediaRecorder.isTypeSupported('audio/mp4')
        ? 'audio/mp4'
        : '';

      const recorder = new MediaRecorder(stream, mimeType ? { mimeType } : undefined);
      chunksRef.current = [];
      streamRef.current = stream;
      recorderRef.current = recorder;

      recorder.ondataavailable = (e) => {
        if (e.data && e.data.size > 0) {
          chunksRef.current.push(e.data);
        }
      };

      recorder.onstop = () => {
        stopTracks();
        if (recordingTimerRef.current) clearInterval(recordingTimerRef.current);
        setIsRecording(false);
        setRecordingSeconds(0);

        const durationMs = Date.now() - startTimeRef.current;
        const capturedText = (browserTranscriptRef.current || speechRecognizerRef.current?.getTranscript?.() || '').trim();

        if (speechRecognizerRef.current) {
          try { speechRecognizerRef.current.stop(); } catch { /* ignore */ }
        }

        // If speech was recognized via browser STT, send it immediately
        if (capturedText) {
          setLiveTranscript('');
          sendMessage(capturedText);
          return;
        }

        if (durationMs < 300 && !capturedText) {
          setAudioError('Speak for a moment before stopping.');
          setConversationStatus('Call connected');
          return;
        }

        const recordedBlob = new Blob(chunksRef.current, { type: recorder.mimeType || 'audio/webm' });
        chunksRef.current = [];

        if (recordedBlob.size > 0) {
          processRecording(recordedBlob);
        } else {
          setConversationStatus('Call connected');
        }
      };

      recorder.start(100);
      setIsRecording(true);
      isStartingRef.current = false;
      setConversationStatus('Listening…');

      setRecordingSeconds(0);
      recordingTimerRef.current = setInterval(() => {
        setRecordingSeconds((s) => s + 1);
      }, 1000);
    } catch (error) {
      isStartingRef.current = false;
      stopTracks();
      if (speechRecognizerRef.current) {
        try { speechRecognizerRef.current.stop(); } catch { /* ignore */ }
      }
      setIsRecording(false);
      setAudioError(
        error.name === 'NotAllowedError'
          ? 'Microphone access is blocked. Allow it in your browser settings and try again.'
          : 'Microphone could not be connected. Please try again.'
      );
    }
  };

  const stopRecording = () => {
    if (isStartingRef.current) {
      shouldStopRef.current = true;
    }
    if (recorderRef.current && recorderRef.current.state === 'recording') {
      try {
        recorderRef.current.stop();
      } catch (err) {
        console.warn('Error stopping recorder', err);
      }
    }
  };

  const toggleRecording = (event) => {
    event?.preventDefault();
    if (isRecording) {
      stopRecording();
    } else {
      startRecording();
    }
  };

  // Ensure student profile exists before chat — register a new caller profile
  const ensureStudentProfile = async () => {
    if (studentId) return studentId;

    try {
      const response = await fetch(`${apiBaseUrl}/students`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: 'New Caller',
          preferred_language: language,
        }),
      });
      if (response.ok) {
        const student = await response.json();
        if (student && student.id) {
          setStudentId(student.id);
          return student.id;
        }
      }
    } catch (err) {
      console.warn('Could not auto-register student profile', err);
    }
    return null;
  };

  const sendMessage = async (message) => {
    setConversationStatus('Processing…');
    setAudioError('');
    try {
      const activeStudentId = await ensureStudentProfile();

      const response = await fetch(`${apiBaseUrl}/assistant/chat`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          student_id: activeStudentId,
          message,
          language,
          session_id: conversationId,
          is_voice_mode: true,
        }),
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.detail || `Assistant error: ${response.status}`);
      }

      const data = await response.json();
      setMessages((current) => [
        ...current,
        { role: 'user', text: message },
        { role: 'assistant', text: data.reply },
      ]);
      setOpportunities(data.referenced_opportunities || []);
      setConversationId(data.session_id || conversationId);

      const synthesized = await synthesizeVoice(data.reply);
      await playVoiceResponse(synthesized?.audio_response, synthesized?.audio_format, data.reply);
    } catch (error) {
      setAudioError(error.message || 'Message could not be sent.');
      setConversationStatus('Call connected');
    }
  };

  const synthesizeVoice = async (text) => {
    try {
      const response = await fetch(`${apiBaseUrl}/voice/synthesize`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text, language }),
      });
      if (!response.ok) return null;
      return await response.json();
    } catch (error) {
      console.warn('Backend TTS unavailable, using browser voice fallback:', error);
      return null;
    }
  };

  const submitDraft = (event) => {
    event.preventDefault();
    const message = messageDraft.trim();
    if (!message) return;
    setMessageDraft('');
    sendMessage(message);
  };

  const acceptCall = async () => {
    playCallTone('connect');
    setCallState('active');
    const opening = openingPrompts[language] || openingPrompts.en;
    setMessages([{ role: 'assistant', text: opening }]);
    setConversationId(null);
    setOpportunities([]);
    setAudioError('');
    setLiveTranscript('');
    setConversationStatus('Call connected');

    // Create fresh student profile for this new voice caller
    try {
      const response = await fetch(`${apiBaseUrl}/students`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: 'New Caller',
          preferred_language: language,
        }),
      });
      if (response.ok) {
        const student = await response.json();
        if (student && student.id) {
          setStudentId(student.id);
        }
      }
    } catch (err) {
      console.warn('Auto-registering new caller profile notice:', err);
    }

    // Speak initial greeting aloud
    if (speakerOn) {
      const synthesized = await synthesizeVoice(opening);
      await playVoiceResponse(synthesized?.audio_response, synthesized?.audio_format, opening);
    }
  };

  const endCall = () => {
    playCallTone('end');
    if (recorderRef.current && recorderRef.current.state === 'recording') {
      try { recorderRef.current.stop(); } catch {}
    }
    stopTracks();
    if (playbackRef.current) playbackRef.current.pause();
    stopBrowserTTS();
    if (recordingTimerRef.current) clearInterval(recordingTimerRef.current);
    setIsRecording(false);
    setStudentId(null);
    setConversationId(null);
    setCallState('ended');
  };

  const toggleMute = () => {
    setMuted((prev) => {
      const next = !prev;
      if (next && isRecording) {
        stopRecording();
      }
      return next;
    });
  };

  const toggleSpeaker = () => {
    setSpeakerOn((prev) => {
      const next = !prev;
      if (!next) {
        if (playbackRef.current) playbackRef.current.pause();
        stopBrowserTTS();
        setConversationStatus('Call connected');
      }
      return next;
    });
  };

  // --- 1. Language Selection Screen ---
  if (callState === 'language') {
    return (
      <main className="app-shell setup-shell">
        <StatusBar />
        <section className="language-view">
          <div className="eyebrow-badge">DREAMCATCHER AI</div>
          <h1>Choose Language</h1>
          <p>We will speak with you in the language you are most comfortable using.</p>

          <label className="language-search">
            <Search size={17} aria-hidden="true" />
            <input
              type="search"
              value={languageSearch}
              onChange={(event) => setLanguageSearch(event.target.value)}
              placeholder="Search language..."
              aria-label="Search languages"
            />
          </label>

          <div className="language-list-wrap">
            <div className="language-list">
              {visibleLanguages.map((item) => (
                <button
                  className={`language-option ${language === item.code ? 'selected' : ''}`}
                  key={item.code}
                  onClick={() => setLanguage(item.code)}
                >
                  <Languages className="lang-icon" size={18} strokeWidth={1.8} aria-hidden="true" />
                  <div className="lang-info">
                    <span className="lang-label">{item.label}</span>
                    <span className="lang-sub">{item.speech}</span>
                  </div>
                  <div className="lang-check" aria-hidden="true">{language === item.code ? '✓' : ''}</div>
                </button>
              ))}
              {visibleLanguages.length === 0 && <p className="language-empty">No languages found</p>}
            </div>
          </div>

          <div className="setup-footer">
            <button className="start-call-button" onClick={() => setCallState('incoming')}>
              <PhoneCall size={19} />
              <span>Connect Voice Call</span>
            </button>
          </div>
        </section>
      </main>
    );
  }

  // --- 2. Call Ended Screen ---
  if (callState === 'ended') {
    return (
      <main className="app-shell ended-shell">
        <StatusBar />
        <section className="ended-state">
          <Avatar name={contactName} avatarUrl={avatarUrl} large />
          <h1>Call Ended</h1>
          <p className="ended-contact">{contactName}</p>
          <span className="ended-duration">Duration: {duration}</span>
          <div className="ended-actions">
            <button className="redial-button" onClick={() => setCallState('incoming')}>
              <PhoneCall size={19} />
              <span>Call Again</span>
            </button>
            <button className="change-lang-button" onClick={() => setCallState('language')}>
              Change Language
            </button>
          </div>
        </section>
      </main>
    );
  }

  // --- 3. Incoming & Active Call Screens ---
  return (
    <main className={`app-shell ${callState === 'active' ? 'active-shell' : 'incoming-shell'}`}>
      <StatusBar />

      {callState === 'incoming' ? (
        <section className="incoming-view">
          <div className="incoming-top">
            <div className="incoming-eyebrow">INCOMING GUIDANCE CALL</div>
            <Avatar name={contactName} avatarUrl={avatarUrl} large pulse />
            <div className="contact-copy">
              <h1>{contactName}</h1>
              <p>{selectedLanguage.label} · {contactLabel}</p>
            </div>
          </div>

          <div className="incoming-actions">
            <div className="action-wrap">
              <button className="call-action decline" onClick={endCall} aria-label="Decline call">
                <Phone size={28} fill="currentColor" />
              </button>
              <span>Decline</span>
            </div>
            <div className="action-wrap">
              <button className="call-action accept" onClick={acceptCall} aria-label="Accept call">
                <Phone size={28} fill="currentColor" />
              </button>
              <span>Accept</span>
            </div>
          </div>
        </section>
      ) : (
        <div className="call-layout">
          <section className="active-view">
            <header className="active-header">
              <div className="active-time">{duration}</div>
              <div className="connected-status"><i /> Connected</div>
              <h1>Pragati</h1>
              <p>DreamCatcher Counselling</p>
            </header>

            <div className="call-center">
              <SpeakingWave isRecording={isRecording} conversationStatus={conversationStatus} />
              {liveTranscript && <p className="live-transcript">“{liveTranscript}”</p>}
              {audioError && <p className="audio-error" role="alert">{audioError}</p>}
              <button
                type="button"
                className={`listen-button ${isRecording ? 'recording' : ''}`}
                onClick={toggleRecording}
                disabled={conversationStatus === 'Processing…' || conversationStatus === 'Pragati speaking…'}
                aria-label={isRecording ? 'Tap to finish speaking and send' : 'Tap to speak'}
              >
                {isRecording ? <MicOff size={25} /> : <Mic size={25} />}
              </button>
              <span className="mic-hint">{isRecording ? `Tap to send · ${recordingSeconds}s` : 'Tap to speak'}</span>
            </div>

            <div className="control-grid">
              <button className={`control ${speakerOn ? 'selected' : ''}`} onClick={toggleSpeaker} title="Toggle speaker">
                <span>{speakerOn ? <Volume2 size={22} /> : <VolumeX size={22} />}</span><small>Audio</small>
              </button>
              <button className="control" onClick={() => setLanguage(language === 'en' ? 'hi' : 'en')} title="Switch language">
                <span><Languages size={22} /></span><small>Language</small>
              </button>
              <button className={`control ${muted ? 'selected active-red' : ''}`} onClick={toggleMute} title="Toggle mute">
                <span>{muted ? <MicOff size={22} /> : <Mic size={22} />}</span><small>{muted ? 'Unmute' : 'Mute'}</small>
              </button>
              <button className="control" onClick={() => setShowKeypad(true)} title="Open keypad">
                <span><Grid3X3 size={22} /></span><small>Keypad</small>
              </button>
              <button className="control end-call-control" onClick={endCall} aria-label="End call">
                <span><Phone size={25} fill="currentColor" /></span><small>End</small>
              </button>
              <button className={`control transcript-control ${showTranscript ? 'selected' : ''}`} onClick={() => setShowTranscript((open) => !open)} title="View transcript">
                <span><MessageSquareText size={22} /></span><small>Messages</small>
              </button>
            </div>
            <KeypadModal isOpen={showKeypad} onClose={() => setShowKeypad(false)} />
          </section>
          <TranscriptPanel
            messages={messages}
            opportunities={opportunities}
            messageDraft={messageDraft}
            setMessageDraft={setMessageDraft}
            submitDraft={submitDraft}
            conversationEndRef={conversationEndRef}
            open={showTranscript}
            onToggle={() => setShowTranscript((open) => !open)}
          />
        </div>
      )}
    </main>
  );
}
