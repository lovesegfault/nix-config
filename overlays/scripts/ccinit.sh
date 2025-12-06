#!/usr/bin/env bash
set -euo pipefail

# Handle CLAUDE.md
if [[ -L ./CLAUDE.md ]]; then
	echo "CLAUDE.md symlink already exists"
elif [[ -e ./CLAUDE.md ]]; then
	echo "CLAUDE.md exists but is not a symlink - skipping"
elif [[ -e ../CLAUDE.md ]]; then
	ln -s ../CLAUDE.md ./CLAUDE.md
	echo "Created symlink: ./CLAUDE.md -> ../CLAUDE.md"
else
	echo "No ../CLAUDE.md found, running claude /init..."
	claude /init
	if [[ -e ./CLAUDE.md ]]; then
		mv ./CLAUDE.md ../CLAUDE.md
		ln -s ../CLAUDE.md ./CLAUDE.md
		echo "Moved CLAUDE.md to parent and created symlink"
	else
		echo "claude /init did not create CLAUDE.md"
		exit 1
	fi
fi

# Handle .claude directory
if [[ -L ./.claude ]]; then
	echo ".claude symlink already exists"
elif [[ -e ./.claude ]]; then
	echo ".claude exists but is not a symlink - skipping"
elif [[ -e ../.claude ]]; then
	ln -s ../.claude ./.claude
	echo "Created symlink: ./.claude -> ../.claude"
else
	mkdir -p ../.claude
	ln -s ../.claude ./.claude
	echo "Created ../.claude and symlink"
fi

# Add to .git/info/exclude if in a git repo
if [[ -d .git/info ]]; then
	exclude_file=".git/info/exclude"
	for entry in CLAUDE.md .claude; do
		if ! grep -qxF "$entry" "$exclude_file" 2>/dev/null; then
			echo "$entry" >>"$exclude_file"
			echo "Added $entry to $exclude_file"
		fi
	done
fi
