# Sync configuration/dot files.
syncconfig() {
  local files=(
    ~/.inputrc
    ~/.bashrc
    ~/.bashrc.d
    ~/.bashrc.local.example
    ~/.gitconfig
    ~/.pshellrc
    ~/.tmux.conf
    ~/.tmux.d
    ~/.tmux.local.example.conf
    ~/.tmux.after.example.conf
    ~/.vimrc
    ~/.vimrc.d
    ~/.vimrc.local.example
    ~/.git_hooks
    ~/.vdi-config-files
    ~/.local/bin
  )

  local dest=~/git/.dotfiles/
  local file expanded_file

  for file in "${files[@]}"; do
    expanded_file="${file/#\~/$HOME}"

    if [ ! -e "$expanded_file" ]; then
      continue
    fi

    rsync -av --exclude="*.pem" "$expanded_file" "$dest"
    echo "$expanded_file synced to $(basename "$dest")"
  done
}
