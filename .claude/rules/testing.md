---
paths:
  - "spec/**/*"
  - "test/**/*"
---

# Testing Rules

- Run the smallest relevant set first (a single spec file or example). Don't run the full suite for minor changes or rerun passing tests without reason.
- Check existing spec conventions before writing new tests. Test the requested behavior plus relevant edge cases; no redundant tests.
- If a test fails, investigate that failure before changing anything. No speculative fixes, and don't modify unrelated tests to get green.
- Report which tests ran, pass/fail, failures, and what remains unverified.
