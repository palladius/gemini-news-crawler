# Changelog

## [0.3.88] - 2026-04-29
### Fixed
- Replaced deprecated `gemini-1.5-pro-latest` model with environment variable `GEMINI_MODEL_DEFAULT` (fallback to `gemini-2.5-flash`) to fix API 404 errors causing Cloud Run crash loops.


