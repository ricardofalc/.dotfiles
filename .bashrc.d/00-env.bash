export EDITOR=vim
export VISUAL=vim
export PATH="$HOME/.local/bin:$PATH"

# Colored ls output.
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi
