# Shared Bash config.

# Source global definitions.
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

for bashrc_file in "$HOME"/.bashrc.d/*.bash; do
  [ -r "$bashrc_file" ] && . "$bashrc_file"
done
unset bashrc_file

# Machine-specific shell config. Put work-only aliases, exports, and secrets here.
if [ -f "$HOME/.bashrc.local" ]; then
  . "$HOME/.bashrc.local"
fi
