import { defineConfig, presetAttributify, presetWind3 } from 'unocss';

export default defineConfig({
  presets: [
    presetAttributify({}),
    presetWind3(),
  ],
  content: {
    filesystem: ['./src/**/*.{html,ts,scss}'],
  },
  theme: {
    colors: {
      base: '#191724',
      surface: '#1f1d2e',
      overlay: '#26233a',
      muted: '#6e6a86',
      subtle: '#908caa',
      text: '#e0def4',
      love: '#eb6f92',
      gold: '#f6c177',
      rose: '#ebbcba',
      pine: '#31748f',
      foam: '#9ccfd8',
      iris: '#c4a7e7',
      highlightLow: '#21202e',
      highlightMed: '#403d52',
      highlightHigh: '#524f67',
    },
    fontSize: {
      xs: ['16px', '1.4rem'],
      sm: ['18px', '1.6rem'],
      base: ['18px', '1.6rem'],
      lg: ['21px', '1.8rem'],
      xl: ['24px', '2rem'],
      '2xl': ['28px', '2.25rem'],
      '3xl': ['34px', '2.5rem'],
      '4xl': ['42px', '3rem'],
      '5xl': ['56px', '4rem'],
      '6xl': ['72px', '5rem'],
    },
    fontFamily: {
      sans: '"Mona Sans", sans-serif',
    },
  },
  rules: [
    ['bg-base', { backgroundColor: '#191724' }],
    ['bg-surface', { backgroundColor: '#1f1d2e' }],
    ['bg-overlay', { backgroundColor: '#26233a' }],
    ['text-muted', { color: '#6e6a86' }],
    ['text-subtle', { color: '#908caa' }],
    ['text-text', { color: '#e0def4' }],
    ['text-love', { color: '#eb6f92' }],
    ['text-gold', { color: '#f6c177' }],
    ['text-rose', { color: '#ebbcba' }],
    ['text-pine', { color: '#31748f' }],
    ['text-foam', { color: '#9ccfd8' }],
    ['text-iris', { color: '#c4a7e7' }],
  ],
});
