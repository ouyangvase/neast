import { create } from 'zustand';

/** MainScreen tabs (IndexedStack parity — tabs are app state, not routes). */
export type MainTab = 'home' | 'payRent' | 'reward' | 'account';

interface TabsState {
  tab: MainTab;
  select: (tab: MainTab) => void;
  /** Back to Home (post-login / logout reset). */
  reset: () => void;
}

export const useTabsStore = create<TabsState>()((set) => ({
  tab: 'home',
  select: (tab) => set({ tab }),
  reset: () => set({ tab: 'home' }),
}));
