# Rightflick

Experimental approach to Git hooks

## WIP

### Ideas / principles

- Optional
- Secure
  - Simple so it's easy to audit
  - Updates to hooks are **not** accepted automatically; a locking mechanism
- Shifts CI from a feedback source to an enforcer
- rightflick is not responsible for committing autofixes; a developer should configure their editor in a way that upon saves autofixes are applied
- Operates at two levels
  1. pre-commit
     - performance
       - is only concerned with the contents of the latest commit
       - is only concerned with contents of individual files; cross-file linting is out of question; this way git operations such as rebases are not slowed down due to pre-commit hooks
     - configured in a CI workflow; tight integration and ensures enforcement
       - consumes only one runner, is only concerned with files that have changed in the given PR
  2. pre-push
     - correctness & ease of integration
       - if a push goes through, CI jobs should never fail, barring flaky tests
         - potential cost savings and operational excellence through better runner availability
       - existing CI jobs should only need minor adjustments
     - ease of integration to existing CI jobs is also a priority

move testing left; closer to developer; tight feedback loop, ...
