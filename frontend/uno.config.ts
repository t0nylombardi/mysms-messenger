import { defineConfig, presetAttributify, presetWind3 } from 'unocss'

export default defineConfig({
  presets: [
    presetAttributify({ /* preset options */}),
    presetWind3(),
  ],
  content: {
    filesystem: [
      './src/**/*.{html,ts,scss}',
    ],
  },
  theme: {
    colors: {
      primary: '#1DA1F2',
      secondary: '#14171A',
      accent: '#657786',
    },
  },
  rules: [
    ['bg-primary', { backgroundColor: '#1DA1F2' }],
    ['text-secondary', { color: '#14171A' }],
    ['text-accent', { color: '#657786' }],
  ],
});
