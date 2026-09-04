import { useEffect, useRef, useState } from 'react';
import {
  Battery, ChevronDown, Contact, ExternalLink, Grid3X3, Mic, MicOff, Phone,
  PhoneCall, Plus, Signal, Speaker, Video, Wifi, X,
} from 'lucide-react';
import { useCallTimer } from '../hooks/useCallTimer';
import { audioFormatToMime, blobToBase64, blobToLinear16Wav } from '../utils/audio';

const controls = [
  { label: 'mute', icon: Mic },
  { label: 'keypad', icon: Grid3X3 },
  { label: 'speaker', icon: Speaker },
  { label: 'add call', icon: Plus },
  { label: 'FaceTime', icon: Video },
  { label: 'contacts', icon: Contact },
];

const languages = [
  { code: 'hi', label: 'Hindi', speech: 'hi-IN' },
  { code: 'mr', label: 'Marathi', speech: 'mr-IN' },
  { code: 'bn', label: 'Bengali', speech: 'bn-IN' },
  { code: 'ta', label: 'Tamil', speech: 'ta-IN' },
  { code: 'te', label: 'Telugu', speech: 'te-IN' },
  { code: 'kn', label: 'Kannada', speech: 'kn-IN' },
  { code: 'en', label: 'English', speech: 'en-IN' },
];

const openingPrompts = {
  hi: 'नमस्ते, मैं ड्रीमकैचर काउंसलिंग से आपका मार्गदर्शक हूँ। पहले अपना नाम और अपने गांव या शहर के बारे में बताइए।',
  mr: 'नमस्कार, मी ड्रीमकॅचर काउन्सेलिंगचा तुमचा मार्गदर्शक आहे. आधी तुमचे नाव आणि गाव किंवा शहर सांगा.',
  bn: 'নমস্কার, আমি ড্রিমক্যাচার কাউন্সেলিং-এর আপনার গাইড। প্রথমে আপনার নাম এবং গ্রাম বা শহর সম্পর্কে বলুন।',
  ta: 'வணக்கம், நான் ட்ரீம்கேச்சர் கவுன்சிலிங்கின் வழிகாட்டி. முதலில் உங்கள் பெயர் மற்றும் கிராமம் அல்லது நகரத்தைப் பற்றி சொல்லுங்கள்.',
  te: 'నమస్కారం, నేను డ్రీమ్‌క్యాచర్ కౌన్సెలింగ్ గైడ్‌ను. ముందుగా మీ పేరు మరియు గ్రామం లేదా పట్టణం గురించి చెప్పండి.',
  kn: 'ನಮಸ್ಕಾರ, ನಾನು ಡ್ರೀಮ್‌ಕ್ಯಾಚರ್ ಕೌನ್ಸೆಲಿಂಗ್ ಮಾರ್ಗದರ್ಶಿ. ಮೊದಲು ನಿಮ್ಮ ಹೆಸರು ಮತ್ತು ಊರು ಅಥವಾ ನಗರದ ಬಗ್ಗೆ ತಿಳಿಸಿ.',
  en: 'Namaste, I am your DreamCatcher counselling guide. Please tell me your name and the village or town you live in.',
};

function StatusBar() {
  return <div className="status-bar"><span>9:41</span><div className="status-icons"><Signal size={15} strokeWidth={2.5} /><Wifi size={16} strokeWidth={2.5} /><Battery size={21} strokeWidth={2.2} /></div></div>;
}

function Avatar({ name, avatarUrl, large = false }) {
  const initials = name.split(' ').map((part) => part[0]).join('').slice(0, 2);
  return avatarUrl
    ? <img className={`avatar ${large ? 'avatar-large' : ''}`} src={avatarUrl} alt="" />
    : <div className={`avatar avatar-fallback ${large ? 'avatar-large' : ''}`} aria-label={`${name} avatar`}>{initials}</div>;
}

function PermissionAlert({ message, onClose }) {
  if (!message) return null;
  return <div className="permission-alert" role="alert"><div><strong>Microphone Unavailable</strong><p>{message}</p></div><button onClick={onClose} aria-label="Dismiss"><X size={18} /></button></div>;
}

export function CallScreen({ contactName = 'DreamCatcher Counselling', contactLabel = 'career guidance', avatarUrl }) {
  const [callState, setCallState] = useState('language');
  const [language, setLanguage] = useState('hi');
  const [messages, setMessages] = useState([]);
  const [messageDraft, setMessageDraft] = useState('');
  const [opportunities, setOpportunities] = useState([]);
  const [conversationStatus, setConversationStatus] = useState('Call connected');
  const [conversationId, setConversationId] = useState(null);
  const [muted, setMuted] = useState(false);
  const [speakerOn, setSpeakerOn] = useState(true);
  const [permissionDismissed, setPermissionDismissed] = useState(false);
  const recorderRef = useRef(null);
  const streamRef = useRef(null);
  const chunksRef = useRef([]);
  const playbackRef = useRef(null);
  const [isRecording, setIsRecording] = useState(false);
  const [audioError, setAudioError] = useState('');
  const selectedLanguage = languages.find((item) => item.code === language) || languages[0];
  const apiUrl = import.meta.env.VITE_APP_BACKEND_URL || 'https://dreamcatcher-backend-635980060226.asia-south1.run.app/api/v1';
  const [studentId, setStudentId] = useState(import.meta.env.VITE_STUDENT_ID || null);
  const duration = useCallTimer(callState === 'active');

  const stopTracks = () => { streamRef.current?.getTracks().forEach((track) => track.stop()); streamRef.current = null; };

  const processRecording = async (blob) => {
    setConversationStatus('Processing...');
    try {
      const wav = await blobToLinear16Wav(blob);
      const token = import.meta.env.VITE_AUTH_TOKEN || localStorage.getItem('auth_token');
      const response = await fetch(`${apiUrl.replace(/\/assistant\/?$/, '')}/voice/query-base64`, {
        method: 'POST', headers: { 'Content-Type': 'application/json', ...(token ? { Authorization: `Bearer ${token}` } : {}) },
        body: JSON.stringify({ audio_data: await blobToBase64(wav.blob), language, conversation_id: conversationId, ...(studentId ? { student_id: studentId } : {}), audio_encoding: 'LINEAR16', sample_rate: wav.sampleRate }),
      });
      if (response.status === 401) { localStorage.removeItem('auth_token'); throw new Error('Your session expired. Please sign in again.'); }
      if (!response.ok) throw new Error((await response.json()).detail || 'The counselling service is unavailable.');
      const data = await response.json();
      if (!data.user_transcript) throw new Error('I could not hear that. Please try again.');
      setMessages((current) => [...current, { role: 'user', text: data.user_transcript }, { role: 'assistant', text: data.ai_response }]);
      setConversationId(data.conversation_id);
      setStudentId(data.student_id);
      setConversationStatus('Pragati speaking…');
      if (data.audio_response && speakerOn) {
        playbackRef.current?.pause();
        const audio = new Audio(`data:${audioFormatToMime(data.audio_format)};base64,${data.audio_response}`);
        playbackRef.current = audio;
        audio.onended = () => setConversationStatus('Call connected');
        audio.onerror = () => setConversationStatus('Call connected');
        await audio.play();
      } else setConversationStatus('Call connected');
    } catch (error) {
      setAudioError(error.message);
      setConversationStatus('Call connected');
    }
  };

  const startRecording = async (event) => {
    event?.preventDefault();
    if (isRecording || conversationStatus === 'Processing...' || conversationStatus === 'Pragati speaking…') return;
    setAudioError('');
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mimeType = MediaRecorder.isTypeSupported('audio/webm;codecs=opus') ? 'audio/webm;codecs=opus' : '';
      const recorder = new MediaRecorder(stream, mimeType ? { mimeType } : undefined);
      chunksRef.current = [];
      streamRef.current = stream;
      recorderRef.current = recorder;
      recorder.ondataavailable = (event) => { if (event.data.size) chunksRef.current.push(event.data); };
      recorder.onstop = () => { stopTracks(); setIsRecording(false); const blob = new Blob(chunksRef.current, { type: recorder.mimeType }); chunksRef.current = []; if (blob.size) processRecording(blob); };
      recorder.start();
      setIsRecording(true);
      setConversationStatus('Listening…');
    } catch (error) {
      setAudioError(error.name === 'NotAllowedError' ? 'Microphone access is blocked. Allow it in your browser settings and try again.' : 'Microphone could not be connected.');
    }
  };

  const stopRecording = (event) => {
    event?.preventDefault();
    if (recorderRef.current?.state === 'recording') recorderRef.current.stop();
  };

  const sendMessage = async (message) => {
    // Text remains a convenient test path; voice turns use processRecording above.
    setConversationStatus('Processing...');
    try {
      if (!studentId) throw new Error('Add VITE_STUDENT_ID to connect turns to a profile.');
      const response = await fetch(`${apiUrl}/assistant/chat`, {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ student_id: studentId, message, language, session_id: conversationId }),
      });
      if (!response.ok) throw new Error(`Assistant returned ${response.status}`);
      const data = await response.json();
      setMessages((current) => [...current, { role: 'user', text: message }, { role: 'assistant', text: data.reply }]);
      setOpportunities(data.referenced_opportunities || []);
      setConversationId(data.session_id || conversationId);
      setConversationStatus('Call connected');
    } catch (error) {
      setAudioError(error.message);
      setConversationStatus('Call connected');
    }
  };

  const submitDraft = (event) => {
    event.preventDefault();
    const message = messageDraft.trim();
    if (!message) return;
    setMessageDraft('');
    sendMessage(message);
  };

  const acceptCall = () => {
    setCallState('active');
    const opening = openingPrompts[language];
    setMessages([{ role: 'assistant', text: opening }]);
    setConversationId(null);
    if (!import.meta.env.VITE_STUDENT_ID) setStudentId(null);
    setConversationStatus('Call connected');
  };
  const endCall = () => {
    recorderRef.current?.stop();
    stopTracks();
    playbackRef.current?.pause();
    setCallState('ended');
  };

  if (callState === 'language') return <main className="phone-shell setup-shell"><StatusBar /><section className="language-view">
    <span className="eyebrow">DREAMCATCHER COUNSELLING</span><h1>Choose your language</h1><p>We will speak with you in the language you are most comfortable using.</p>
    <div className="language-list">{languages.map((item) => <button className={language === item.code ? 'language-option selected' : 'language-option'} key={item.code} onClick={() => setLanguage(item.code)}><span>{item.label}</span><small>{item.code.toUpperCase()}</small></button>)}</div>
    <button className="start-call-button" onClick={() => setCallState('incoming')}><PhoneCall size={18} /> Place call</button>
  </section></main>;

  if (callState === 'ended') {
    return <main className="phone-shell"><StatusBar /><section className="ended-state"><Avatar name={contactName} avatarUrl={avatarUrl} /><h1>Call Ended</h1><p>{contactName}</p><button className="redial-button" onClick={() => setCallState('incoming')}><PhoneCall size={18} /> Call Again</button></section></main>;
  }

  return <main className={`phone-shell ${callState === 'active' ? 'active-shell' : 'incoming-shell'}`}>
    <StatusBar />
    <PermissionAlert message={permissionDismissed ? '' : (conversationStatus === 'unsupported' ? 'Speech recognition is unavailable here. Try Chrome on Android.' : '')} onClose={() => setPermissionDismissed(true)} />
    {callState === 'incoming' ? <section className="incoming-view">
      <div className="incoming-top"><ChevronDown size={22} className="dismiss-icon" /><Avatar name={contactName} avatarUrl={avatarUrl} large /><div className="contact-copy"><h1>{contactName}</h1><p>{selectedLanguage.label} · {contactLabel}</p></div></div>
      <div className="incoming-actions"><div className="action-wrap"><button className="call-action decline" onClick={endCall} aria-label="Decline call"><Phone size={30} fill="currentColor" /></button><span>Decline</span></div><div className="action-wrap"><button className="call-action accept" onClick={acceptCall} aria-label="Accept call"><Phone size={30} fill="currentColor" /></button><span>Accept</span></div></div>
    </section> : <section className="active-view">
      <div className="active-header"><p>{duration}</p><h1>{contactName}</h1><span>{selectedLanguage.label} · {conversationStatus}</span></div>
      <div className="conversation">{messages.map((message, index) => <div className={`${message.role}-bubble`} key={`${message.role}-${index}`}>{message.text}</div>)}{opportunities.length > 0 && <div className="opportunity-list"><h2>Good matches for you</h2>{opportunities.map((opportunity) => <a href={opportunity.official_url || '#'} target="_blank" rel="noreferrer" key={opportunity.id}><span>{opportunity.title}<small>{opportunity.type}{opportunity.deadline ? ` · Deadline ${opportunity.deadline}` : ''}</small></span><ExternalLink size={16} /></a>)}</div>}</div>
      <button className={`listen-button ${isRecording ? 'recording' : ''}`} onPointerDown={startRecording} onPointerUp={stopRecording} onPointerLeave={stopRecording} disabled={conversationStatus === 'Processing...' || conversationStatus === 'Pragati speaking…'}><Mic size={20} /> {isRecording ? 'Release to send' : 'Hold to speak'}</button>
      {audioError && <p className="audio-error" role="alert">{audioError}</p>}
      <form className="text-message-form" onSubmit={submitDraft}><input value={messageDraft} onChange={(event) => setMessageDraft(event.target.value)} placeholder="Or type your answer" aria-label="Type your answer" /><button type="submit" aria-label="Send message"><PhoneCall size={17} /></button></form>
      <div className="control-grid">{controls.slice(0, 3).map(({ label, icon: Icon }) => { const isOn = label === 'mute' ? muted : label === 'speaker' ? speakerOn : false; return <button className={`control ${isOn ? 'selected' : ''}`} key={label} onClick={() => label === 'mute' ? setMuted(!muted) : label === 'speaker' ? setSpeakerOn(!speakerOn) : undefined}><span><Icon size={27} strokeWidth={1.8} />{label === 'mute' && muted ? <MicOff size={13} className="control-badge" /> : null}</span><small>{label}</small></button>; })}</div>
      <div className="end-action-wrap"><button className="call-action decline" onClick={endCall} aria-label="End call"><Phone size={30} fill="currentColor" /></button></div>
    </section>}
  </main>;
}
