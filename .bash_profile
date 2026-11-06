# Load the shared interactive Bash configuration for login shells.
# macOS starts terminal sessions as login shells by default.
if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
fi
