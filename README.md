# Bellroy Product Card Component

This project recreates a product card component from Bellroy's website using Elm, integrated with Astro and styled with Tailwind CSS.

## Features

- Elm-based interactive product card component
- Color selection functionality
- Responsive design
- Loading states and error handling
- Fetches product data from an API
- Integration with Astro build system
- Comprehensive tests

## Tech Stack

- Elm for the interactive component
- Astro as the build system
- Tailwind CSS for styling
- Unit tests with elm-test

## Getting Started

1. Clone this repository
2. Install dependencies:
   ```
   npm install
   ```
3. Start the development server:
   ```
   npm run dev
   ```
4. Open your browser at http://localhost:4321

## Component Structure

The main component is structured as:

- **ProductCard.elm**: The core Elm component implementing the product card UI and interactions
- **Main.elm**: The Elm application entry point that integrates the component
- **Astro pages**: Integration with Astro for page rendering
- **Styling**: Tailwind CSS with custom utility classes and transitions

## Testing

Run the tests with:

```
npx elm-test
```

## Notes on Implementation

- The component uses a clean TEA (The Elm Architecture) design
- Responsive design is implemented with Tailwind's utility classes
- Color selection is handled through message passing in Elm
- Animation effects are added with CSS transitions
- Data fetching is simulated through a mock API response 