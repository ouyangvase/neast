import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettier from 'eslint-config-prettier';

// Mirrors the repo-root flat config, plus Node globals for the plain-JS
// Metro/Babel config files (the root config only ignores *.mjs).
export default tseslint.config(
  {
    ignores: ['**/node_modules/**', '**/dist/**', '**/.expo/**', '**/mock-api/**'],
  },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    files: ['**/*.js', '**/*.cjs'],
    languageOptions: {
      globals: {
        module: 'readonly',
        require: 'readonly',
        __dirname: 'readonly',
        process: 'readonly',
        console: 'readonly',
      },
    },
    rules: {
      // Metro/Babel config files are CommonJS by convention.
      '@typescript-eslint/no-require-imports': 'off',
    },
  },
  prettier,
);
