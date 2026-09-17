export function audioFormatToMime(audioFormat = '') {
  const format = audioFormat.toLowerCase();
  if (format.includes('wav') || format.includes('linear16')) return 'audio/wav';
  if (format.includes('ogg')) return 'audio/ogg';
  if (format.includes('mp3') || format.includes('mpeg')) return 'audio/mpeg';
  if (format.includes('webm')) return 'audio/webm';
  return 'audio/mpeg';
}

export async function blobToLinear16Wav(blob) {
  if (!blob || blob.size === 0) {
    throw new Error('Audio recording was empty. Please hold and speak into your microphone.');
  }

  const AudioContextClass = window.AudioContext || window.webkitAudioContext;
  if (!AudioContextClass) throw new Error('Web Audio is unavailable in this browser.');
  const context = new AudioContextClass();

  try {
    const rawBuffer = await blob.arrayBuffer();
    if (rawBuffer.byteLength < 64) {
      throw new Error('Recording was too short. Please speak for a moment before releasing.');
    }

    // Safely copy buffer to prevent buffer-detachment issues on Safari/WebKit
    const bufferCopy = rawBuffer.slice(0);
    let decoded;
    try {
      decoded = await context.decodeAudioData(bufferCopy);
    } catch (err) {
      // Fallback for older Safari callback signature
      decoded = await new Promise((resolve, reject) => {
        context.decodeAudioData(rawBuffer.slice(0), resolve, reject);
      });
    }

    if (!decoded || decoded.length === 0 || decoded.duration < 0.1) {
      throw new Error('Recording was too short to transcribe. Please speak clearly.');
    }

    const targetRate = 16000;
    const frameCount = Math.max(1, Math.ceil(decoded.duration * targetRate));
    const offline = new OfflineAudioContext(1, frameCount, targetRate);
    const source = offline.createBufferSource();
    source.buffer = decoded;
    source.connect(offline.destination);
    source.start(0);

    const rendered = await offline.startRendering();
    const samples = rendered.getChannelData(0);
    const wav = new ArrayBuffer(44 + samples.length * 2);
    const view = new DataView(wav);

    const write = (offset, value) => {
      for (let i = 0; i < value.length; i += 1) {
        view.setUint8(offset + i, value.charCodeAt(i));
      }
    };

    write(0, 'RIFF');
    view.setUint32(4, 36 + samples.length * 2, true);
    write(8, 'WAVE');
    write(12, 'fmt ');
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true); // PCM
    view.setUint16(22, 1, true); // Mono
    view.setUint32(24, targetRate, true);
    view.setUint32(28, targetRate * 2, true); // Byte rate
    view.setUint16(32, 2, true); // Block align
    view.setUint16(34, 16, true); // Bits per sample
    write(36, 'data');
    view.setUint32(40, samples.length * 2, true);

    for (let index = 0; index < samples.length; index += 1) {
      const sample = Math.max(-1, Math.min(1, samples[index]));
      view.setInt16(44 + index * 2, sample < 0 ? sample * 0x8000 : sample * 0x7fff, true);
    }

    return { blob: new Blob([wav], { type: 'audio/wav' }), sampleRate: targetRate };
  } catch (err) {
    if (err.message) {
      throw err;
    }
    throw new Error('Audio could not be processed. Please try speaking again.');
  } finally {
    try {
      await context.close();
    } catch {
      // Ignore context close errors
    }
  }
}

export async function blobToBase64(blob) {
  const bytes = new Uint8Array(await blob.arrayBuffer());
  let binary = '';
  const chunkSize = 0x8000;
  for (let index = 0; index < bytes.length; index += chunkSize) {
    binary += String.fromCharCode(...bytes.subarray(index, index + chunkSize));
  }
  return btoa(binary);
}

// Robust Browser Web Speech API TTS with sentence chunking & Chrome keepalive
let activeTtsInterval = null;

function getVoiceForLanguage(voices, langCode) {
  const normalizedLanguage = langCode.toLowerCase();
  const prefix = normalizedLanguage.split('-')[0];
  return voices.find((voice) => voice.lang.toLowerCase() === normalizedLanguage)
    || voices.find((voice) => voice.lang.toLowerCase().split('-')[0] === prefix)
    || null;
}

function waitForVoices() {
  const voices = window.speechSynthesis.getVoices();
  if (voices.length > 0) return Promise.resolve(voices);

  return new Promise((resolve) => {
    let settled = false;
    const finish = () => {
      if (settled) return;
      settled = true;
      window.speechSynthesis.removeEventListener('voiceschanged', finish);
      resolve(window.speechSynthesis.getVoices());
    };
    window.speechSynthesis.addEventListener('voiceschanged', finish, { once: true });
    window.setTimeout(finish, 500);
  });
}

export function stopBrowserTTS() {
  if (activeTtsInterval) {
    clearInterval(activeTtsInterval);
    activeTtsInterval = null;
  }
  if ('speechSynthesis' in window) {
    try {
      window.speechSynthesis.cancel();
    } catch {
      // ignore
    }
  }
  window.__activeUtterances = [];
}

export async function speakWithBrowserTTS(rawText, langCode = 'hi-IN', onStart, onEnd, onError) {
  if (!('speechSynthesis' in window) || !rawText) {
    onEnd?.();
    return null;
  }

  stopBrowserTTS();

  // 1. Clean markdown artifacts so speech doesn't stutter on formatting symbols
  let clean = rawText
    .replace(/\[([^\]]+)\]\([^)]+\)/g, '$1') // link text
    .replace(/[*#_`•💡🙏✓ℹ️]/g, '')
    .replace(/\s+/g, ' ')
    .trim();

  if (!clean) {
    onEnd?.();
    return null;
  }

  // 2. Split text into natural sentence chunks (Indic danda ।, periods, exclamation, question marks, newlines)
  const sentenceRegex = /[^।\.!\?\n]+[।\.!\?\n]+/g;
  let matches = clean.match(sentenceRegex);
  let chunks = matches ? matches.map((s) => s.trim()).filter(Boolean) : [];
  if (chunks.length === 0) {
    chunks = [clean];
  }

  // Voice lists load asynchronously in Chrome and Safari.
  const voices = await waitForVoices();
  const matchedVoice = getVoiceForLanguage(voices, langCode);

  window.__activeUtterances = [];
  let currentIndex = 0;
  let hasStarted = false;

  // Chrome 15-second pause bug workaround
  activeTtsInterval = setInterval(() => {
    if (window.speechSynthesis.speaking) {
      window.speechSynthesis.pause();
      window.speechSynthesis.resume();
    } else if (!window.speechSynthesis.pending && hasStarted) {
      clearInterval(activeTtsInterval);
      activeTtsInterval = null;
    }
  }, 10000);

  const speakChunk = (index) => {
    if (index >= chunks.length) {
      if (activeTtsInterval) {
        clearInterval(activeTtsInterval);
        activeTtsInterval = null;
      }
      window.__activeUtterances = [];
      onEnd?.();
      return;
    }

    try {
      const textChunk = chunks[index];
      const utterance = new SpeechSynthesisUtterance(textChunk);
      utterance.lang = langCode;
      utterance.rate = 0.95;
      utterance.pitch = 1.0;
      if (matchedVoice) utterance.voice = matchedVoice;

      utterance.onstart = () => {
        if (!hasStarted) {
          hasStarted = true;
          onStart?.();
        }
      };

      utterance.onend = () => {
        currentIndex += 1;
        speakChunk(currentIndex);
      };

      utterance.onerror = (err) => {
        if (err.error !== 'canceled' && err.error !== 'interrupted') {
          console.warn('Browser TTS chunk notice:', err);
        }
        currentIndex += 1;
        speakChunk(currentIndex);
      };

      // Keep reference in window to avoid V8 garbage-collecting utterance
      window.__activeUtterances.push(utterance);
      window.speechSynthesis.speak(utterance);
    } catch (e) {
      console.warn('Error speaking chunk:', e);
      onEnd?.();
    }
  };

  speakChunk(0);

  return {
    cancel: () => stopBrowserTTS(),
  };
}

// Browser Web Speech Recognition with interim streaming & cumulative transcription
export function startBrowserSpeechRecognition(langCode = 'hi-IN', onTranscript, onError, onEnd) {
  const SpeechRec = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!SpeechRec) return null;
  try {
    const recognition = new SpeechRec();
    recognition.lang = langCode;
    recognition.interimResults = true;
    recognition.maxAlternatives = 1;
    recognition.continuous = true;

    let finalTranscript = '';
    let currentInterim = '';

    recognition.onresult = (event) => {
      let final = '';
      let interim = '';
      for (let i = 0; i < event.results.length; i += 1) {
        const result = event.results[i];
        if (result && result[0]) {
          const text = result[0].transcript || '';
          if (result.isFinal) {
            final += (final ? ' ' : '') + text.trim();
          } else {
            interim += (interim ? ' ' : '') + text.trim();
          }
        }
      }
      finalTranscript = final;
      currentInterim = interim;
      const combined = (finalTranscript + (currentInterim ? ' ' + currentInterim : '')).trim();
      onTranscript?.(combined, finalTranscript);
    };

    recognition.onerror = (event) => {
      if (event.error !== 'no-speech' && event.error !== 'aborted') {
        onError?.(event.error);
      }
    };

    recognition.onend = () => {
      const combined = (finalTranscript + (currentInterim ? ' ' + currentInterim : '')).trim();
      onEnd?.(combined);
    };

    recognition.start();
    return {
      stop: () => {
        try { recognition.stop(); } catch { /* ignore */ }
      },
      abort: () => {
        try { recognition.abort(); } catch { /* ignore */ }
      },
      getTranscript: () => (finalTranscript + (currentInterim ? ' ' + currentInterim : '')).trim(),
    };
  } catch (err) {
    onError?.(err);
    return null;
  }
}


// DTMF Frequencies for telephone keypad
const DTMF_FREQS = {
  '1': [697, 1209], '2': [697, 1336], '3': [697, 1477],
  '4': [770, 1209], '5': [770, 1336], '6': [770, 1477],
  '7': [852, 1209], '8': [852, 1336], '9': [852, 1477],
  '*': [941, 1209], '0': [941, 1336], '#': [941, 1477],
};

export function playDTMFTone(key) {
  const freqs = DTMF_FREQS[key];
  if (!freqs) return;
  try {
    const AudioContextClass = window.AudioContext || window.webkitAudioContext;
    if (!AudioContextClass) return;
    const ctx = new AudioContextClass();
    const osc1 = ctx.createOscillator();
    const osc2 = ctx.createOscillator();
    const gain = ctx.createGain();

    osc1.frequency.value = freqs[0];
    osc2.frequency.value = freqs[1];
    gain.gain.value = 0.12;

    osc1.connect(gain);
    osc2.connect(gain);
    gain.connect(ctx.destination);

    osc1.start();
    osc2.start();

    setTimeout(() => {
      gain.gain.exponentialRampToValueAtTime(0.0001, ctx.currentTime + 0.05);
      setTimeout(() => {
        osc1.stop();
        osc2.stop();
        ctx.close();
      }, 60);
    }, 120);
  } catch {
    // Ignore audio context errors
  }
}

export function playCallTone(type = 'connect') {
  try {
    const AudioContextClass = window.AudioContext || window.webkitAudioContext;
    if (!AudioContextClass) return;
    const ctx = new AudioContextClass();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.connect(gain);
    gain.connect(ctx.destination);

    if (type === 'connect') {
      osc.type = 'sine';
      osc.frequency.setValueAtTime(440, ctx.currentTime);
      osc.frequency.exponentialRampToValueAtTime(880, ctx.currentTime + 0.15);
      gain.gain.setValueAtTime(0.08, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.25);
      osc.start();
      osc.stop(ctx.currentTime + 0.25);
    } else if (type === 'end') {
      osc.type = 'sine';
      osc.frequency.setValueAtTime(480, ctx.currentTime);
      osc.frequency.setValueAtTime(400, ctx.currentTime + 0.12);
      gain.gain.setValueAtTime(0.09, ctx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.35);
      osc.start();
      osc.stop(ctx.currentTime + 0.35);
    }
    setTimeout(() => ctx.close(), 400);
  } catch {
    // Ignore tone errors
  }
}