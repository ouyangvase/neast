import { useCallback, useEffect, useState } from 'react';

/** 60s OTP resend countdown (countdownProvider parity). */
export function useCountdown(initialSeconds: number) {
  const [remaining, setRemaining] = useState(initialSeconds);

  useEffect(() => {
    if (remaining <= 0) {
      return;
    }
    const timer = setTimeout(() => setRemaining((value) => value - 1), 1000);
    return () => clearTimeout(timer);
  }, [remaining]);

  const restart = useCallback(() => setRemaining(initialSeconds), [initialSeconds]);

  return { remaining, restart, active: remaining > 0 };
}
