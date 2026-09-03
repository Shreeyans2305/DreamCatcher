import { useCallback, useEffect, useRef, useState } from 'react';

export function useAudioRecorder(onRecordingComplete) {
  const recorderRef = useRef(null);
  const streamRef = useRef(null);
  const chunksRef = useRef([]);
  const [permissionError, setPermissionError] = useState('');
  const [isRecording, setIsRecording] = useState(false);

  const stopTracks = useCallback(() => {
    streamRef.current?.getTracks().forEach((track) => track.stop());
    streamRef.current = null;
  }, []);

  const stopRecording = useCallback(() => {
    const recorder = recorderRef.current;
    if (recorder && recorder.state !== 'inactive') recorder.stop();
    stopTracks();
    setIsRecording(false);
  }, [stopTracks]);

  const startRecording = useCallback(async () => {
    if (!navigator.mediaDevices?.getUserMedia || !window.MediaRecorder) {
      setPermissionError('Audio recording is not supported in this browser.');
      return false;
    }

    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mimeType = MediaRecorder.isTypeSupported('audio/webm;codecs=opus')
        ? 'audio/webm;codecs=opus'
        : '';
      const recorder = new MediaRecorder(stream, mimeType ? { mimeType } : undefined);
      chunksRef.current = [];
      streamRef.current = stream;
      recorderRef.current = recorder;
      setPermissionError('');

      recorder.addEventListener('dataavailable', (event) => {
        if (event.data.size > 0) chunksRef.current.push(event.data);
      });
      recorder.addEventListener('stop', () => {
        const blob = new Blob(chunksRef.current, { type: recorder.mimeType || 'audio/webm' });
        if (blob.size > 0) onRecordingComplete?.(blob);
        chunksRef.current = [];
      }, { once: true });
      recorder.start();
      setIsRecording(true);
      return true;
    } catch (error) {
      stopTracks();
      setPermissionError(error.name === 'NotAllowedError'
        ? 'Microphone access is off. Allow microphone access in your browser settings to record this call.'
        : 'Microphone could not be connected. Please try again.');
      return false;
    }
  }, [onRecordingComplete, stopTracks]);

  useEffect(() => () => {
    if (recorderRef.current && recorderRef.current.state !== 'inactive') recorderRef.current.stop();
    stopTracks();
  }, [stopTracks]);

  return { isRecording, permissionError, startRecording, stopRecording };
}
