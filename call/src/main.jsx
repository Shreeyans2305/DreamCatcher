import React from 'react';
import { createRoot } from 'react-dom/client';
import { CallScreen } from './components/CallScreen';
import './styles.css';

function App() {
  return (
    <CallScreen
      contactName="Maya Thompson"
      contactLabel="mobile"
      onRecordingComplete={(audioBlob) => {
        console.info('Recording ready for upload:', audioBlob);
      }}
    />
  );
}

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
