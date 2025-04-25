/** 
 * Tailwind CSS Configuration
 * 
 * This file extends Tailwind's default configuration to include custom
 * colors, fonts, and other theme settings specific to the Bellroy design system.
 * 
 * @type {import('tailwindcss').Config} 
 */
export default {
  // Define where to look for classes that should be processed by Tailwind
  // Includes all file types used in the project
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue,elm}'],
  
  theme: {
    extend: {
      // Custom color palette matching Bellroy's brand colors
      colors: {
        'bellroy-orange': '#FF5D00', // Primary brand color for accents and CTAs
        'bellroy-black': '#1D1D1D',  // Used for text and dark UI elements
        'bellroy-gray': '#F5F5F5'    // Used for backgrounds and subtle UI elements
      },
      
      // Typography configuration matching Bellroy's brand guidelines
      fontFamily: {
        sans: ['Inter', 'sans-serif'] // Using Inter as the primary font
      }
    },
  },
  
  // No plugins are currently used, but can be added here if needed
  plugins: [],
} 