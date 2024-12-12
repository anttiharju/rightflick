This shall be the source-of-truth for the rendered pre-commit hooks:

```yml
name: Rightflick
on: [pull_request]

jobs:
  validate:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4
      - name: shellcheck
        run: find . -iname "*.sh" -exec shellcheck {} +
      - name: prettier markdown
        if: always()
        run: find . -iname "*.md" -exec npx prettier@3.4.2 {} +
```

* runs always, paths would introduce a possibility for discrepancies since there are two source of truths. YAML anchors are wip for github actions, but the workflow possibly being skipped would prevent effective use of branch protection rules: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/troubleshooting-required-status-checks#handling-skipped-but-required-checks "If a workflow is skipped due to path filtering, branch filtering or a commit message, then checks associated with that workflow will remain in a "Pending" state. A pull request that requires those checks to be successful will be blocked from merging."
* executes pre-commit hook for all matching files in the repo on a so-called merge candidate
  * pre-push hook needs to run all of these on the merge candidate too
    * use file:// protocol for merge candidates.
* no need to write to publish the tool on npm: can use Go, release via homebrew, debian package, nix, potentially more
  * use reproducible builds
    * bundle in exernal dependencies (sh?), don't know how that will clash with the above point
* some tools may not be included and require extra steps for setup, but that's ok because we can extract config by looking for the find commands which shouldn't clash with setup steps
