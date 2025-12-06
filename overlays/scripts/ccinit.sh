#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_CLAUDE_MD="$HOME/src/CLAUDE.md"
BEGIN_MARKER="<!-- BEGIN ~/src/CLAUDE.md -->"
END_MARKER="<!-- END ~/src/CLAUDE.md -->"

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

# Insert/update ~/src/CLAUDE.md section if it exists
if [[ -f $WORKSPACE_CLAUDE_MD && -f ../CLAUDE.md ]]; then
	workspace_content=$(cat "$WORKSPACE_CLAUDE_MD")
	new_section="${BEGIN_MARKER}
${workspace_content}
${END_MARKER}"

	# Remove existing section if present (wherever it may be)
	# Ensures exactly one blank line remains between preceding and succeeding content
	if grep -qF "$BEGIN_MARKER" ../CLAUDE.md; then
		gawk -i inplace -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
			$0 == begin { blanks=0; skip=1; next }
			$0 == end { skip=0; need_blank=1; next }
			need_blank {
				if ($0 == "") next
				print ""
				need_blank=0
				print
				next
			}
			skip { next }
			$0 == "" { blanks++; next }
			{
				for (i=0; i<blanks; i++) print ""
				blanks=0
				print
			}
			END { for (i=0; i<blanks; i++) print "" }
		' ../CLAUDE.md
		echo "Removed existing ~/src/CLAUDE.md section"
	fi

	# Insert after preamble (before second line starting with #)
	insert_line=$(awk '/^#/ { count++; if (count == 2) { print NR; exit } }' ../CLAUDE.md)

	if [[ -n $insert_line ]]; then
		# Insert before the second heading using gawk in-place
		# Ensures exactly one blank line before and after section
		gawk -i inplace -v line="$insert_line" -v section="$new_section" '
			$0 == "" && NR < line { blanks++; next }
			NR < line {
				for (i=0; i<blanks; i++) print ""
				blanks=0
				print
				next
			}
			NR == line {
				print ""
				n = split(section, lines, "\n")
				for (i = 1; i <= n; i++) print lines[i]
				print ""
				print
				next
			}
			{ print }
		' ../CLAUDE.md
		echo "Inserted ~/src/CLAUDE.md section into ../CLAUDE.md"
	else
		# Less than 2 headings found, append to end
		printf '\n%s\n' "$new_section" >>../CLAUDE.md
		echo "Appended ~/src/CLAUDE.md section to ../CLAUDE.md"
	fi
elif [[ ! -f $WORKSPACE_CLAUDE_MD ]]; then
	echo "No ~/src/CLAUDE.md found, skipping section insertion"
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
