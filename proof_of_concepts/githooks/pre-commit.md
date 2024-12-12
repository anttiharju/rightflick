This is example of a rendered

```sh
#!/bin/sh
set -eu

execute_if_modified() {
	command="$1"
	shift # Remove the first argument, which is the command, to leave the patterns
	patterns="$*"

	untracked_changes=$(git ls-files --others --exclude-standard)
	# shellcheck disable=2086 # Expanding patterns is the desired behavior here
	unstaged_changes=$(git diff --name-only -- $patterns)
	# shellcheck disable=2086
	staged_changes=$(git diff --staged --name-only -- $patterns)

	if [ -n "$untracked_changes" ] || [ -n "$unstaged_changes" ] || [ -n "$staged_changes" ]; then
		echo "Changes detected in $patterns. Executing $command..."
		eval "$command"
	fi
}
```

- .githooks directory needs to be configured outside the repo so pulled updates are not automatically accepted
- Rightflick extracts configuration from CI files via `rightflick update`
- terminal seems to remember if sudo is accepted so need to wrap it in a temporary shell
- version control includes .rightflick-lock which offloads "are hooks up-to-date" computation to CI, basically just store a sha for the rendered hooks under .rightflick also in version control
- different devs may have different version of Rightflick. All devs should have the same pre-commit hooks and not deviating ones depending on whatever they have locally. Do not even include hook rendering in local utility? `npx rightflick` so it's easy to call in CI too, no need for an action. Lock Rightflick version with .rightflick-version file
- unsure of the above. PoC for pre-commit hook config file next

```sh
# Not executing everything always is what keeps this script fast.
execute_if_modified 'make shellcheck' '*.sh' '.githooks/*'
execute_if_modified 'make lint' '*.go'
```

This will be offloaded to pre-push:

```sh
if ! git diff --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
	echo "You have unstaged changes; commit contents might not pass 'make ci'."
	exit 1
fi
```
