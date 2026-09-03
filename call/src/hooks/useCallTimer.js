import { useEffect, useState } from 'react';

export function useCallTimer(isActive) {
  const [seconds, setSeconds] = useState(0);

  useEffect(() => {
    if (!isActive) {
      setSeconds(0);
      return undefined;
    }

    const timerId = window.setInterval(() => setSeconds((value) => value + 1), 1000);
    return () => window.clearInterval(timerId);
  }, [isActive]);

  const minutes = Math.floor(seconds / 60).toString().padStart(2, '0');
  const remainder = (seconds % 60).toString().padStart(2, '0');
  return `${minutes}:${remainder}`;
}
