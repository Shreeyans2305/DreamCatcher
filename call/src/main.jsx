import React from 'react';
import { createRoot } from 'react-dom/client';
import { CallScreen } from './components/CallScreen';
import './styles.css';

function App() {
  return (
    <CallScreen />
  );
}

createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);
