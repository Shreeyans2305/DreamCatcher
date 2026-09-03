import { useEffect, useState } from 'react';
import {
  Battery, ChevronDown, Contact, Grid3X3, Mic, MicOff, Phone, PhoneCall,
  Plus, Signal, Speaker, Video, Wifi, X,
} from 'lucide-react';
import { useAudioRecorder } from '../hooks/useAudioRecorder';
import { useCallTimer } from '../hooks/useCallTimer';

const controls = [
  { label: 'mute', icon: Mic },
  { label: 'keypad', icon: Grid3X3 },
  { label: 'speaker', icon: Speaker },
  { label: 'add call', icon: Plus },
  { label: 'FaceTime', icon: Video },
  { label: 'contacts', icon: Contact },
];

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

export function CallScreen({ contactName = 'Maya Thompson', contactLabel = 'mobile', avatarUrl, onRecordingComplete }) {
  const [callState, setCallState] = useState('incoming');
  const [muted, setMuted] = useState(false);
  const [speakerOn, setSpeakerOn] = useState(false);
  const [connecting, setConnecting] = useState(false);
  const [permissionDismissed, setPermissionDismissed] = useState(false);
  const { isRecording, permissionError, startRecording, stopRecording } = useAudioRecorder(onRecordingComplete);
  const duration = useCallTimer(callState === 'active');

  useEffect(() => {
    if (permissionError) setPermissionDismissed(false);
  }, [permissionError]);

  useEffect(() => {
    if (!connecting) return undefined;
    const timeout = window.setTimeout(() => {
      setConnecting(false);
      setCallState('active');
      startRecording();
    }, 1350);
    return () => window.clearTimeout(timeout);
  }, [connecting, startRecording]);

  const acceptCall = () => setConnecting(true);
  const endCall = () => {
    stopRecording();
    setConnecting(false);
    setCallState('ended');
  };

  if (callState === 'ended') {
    return <main className="phone-shell"><StatusBar /><section className="ended-state"><Avatar name={contactName} avatarUrl={avatarUrl} /><h1>Call Ended</h1><p>{contactName}</p><button className="redial-button" onClick={() => setCallState('incoming')}><PhoneCall size={18} /> Call Again</button></section></main>;
  }

  return <main className={`phone-shell ${callState === 'active' ? 'active-shell' : 'incoming-shell'}`}>
    <StatusBar />
    <PermissionAlert message={permissionDismissed ? '' : permissionError} onClose={() => setPermissionDismissed(true)} />
    {callState === 'incoming' || connecting ? <section className="incoming-view">
      <div className={`incoming-top ${connecting ? 'is-connecting' : ''}`}><ChevronDown size={22} className="dismiss-icon" /><Avatar name={contactName} avatarUrl={avatarUrl} large /><div className="contact-copy"><h1>{contactName}</h1><p>{connecting ? 'connecting...' : contactLabel}</p></div></div>
      <div className="incoming-actions"><div className="action-wrap"><button className="call-action decline" onClick={endCall} aria-label="Decline call"><Phone size={30} fill="currentColor" /></button><span>Decline</span></div><div className="action-wrap"><button className="call-action accept" onClick={acceptCall} aria-label="Accept call"><Phone size={30} fill="currentColor" /></button><span>Accept</span></div></div>
    </section> : <section className="active-view">
      <div className="active-header"><p>{duration}</p><h1>{contactName}</h1><span>{contactLabel}</span></div>
      <div className="control-grid">{controls.map(({ label, icon: Icon }) => { const isOn = label === 'mute' ? muted : label === 'speaker' ? speakerOn : false; return <button className={`control ${isOn ? 'selected' : ''}`} key={label} onClick={() => label === 'mute' ? setMuted(!muted) : label === 'speaker' ? setSpeakerOn(!speakerOn) : undefined}><span><Icon size={27} strokeWidth={1.8} />{label === 'mute' && muted ? <MicOff size={13} className="control-badge" /> : null}</span><small>{label}</small></button>; })}</div>
      <div className="end-action-wrap"><button className="call-action decline" onClick={endCall} aria-label="End call"><Phone size={30} fill="currentColor" /></button>{isRecording && <i className="recording-dot" aria-label="Recording" />}</div>
    </section>}
  </main>;
}
