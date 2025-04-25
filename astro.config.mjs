/**
 * Astro Configuration
 * 
 * This file configures the Astro framework and integrates necessary plugins,
 * including Tailwind CSS for styling and Elm for interactive components.
 */

import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';  // Tailwind CSS integration
import elm from 'vite-plugin-elm';         // Elm language integration

export default defineConfig({
  // Configure Astro integrations
  integrations: [
    tailwind()  // Enable Tailwind CSS processing
  ],
  
  // Configure Vite (the underlying build tool)
  vite: {
    plugins: [
      elm()  // Enable Elm compilation for .elm files
    ]
  }
}); 