# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


# Shell prompt with git branch
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Nord Palette for Bash:
# Cyan/Frost: 36 -> 38;5;110
# Blue/Frost: 34 -> 38;5;109
# Green/Aura: 32 -> 38;5;143
# Grey/Slate: 37 -> 38;5;246

export PS1="\[\e[34m\]\u\[\e[m\]\[\e[38;5;246m\]@\[\e[m\]\[\e[38;5;109m\]\h\[\e[m\]\[\e[38;5;239m\] \t \[\e[m\]\[\e[38;5;143m\]\w\[\e[m\] \[\e[1;36m\]\$(parse_git_branch)\[\e[00m\]\n$ "


# Sync configuration/dot files
syncconfig() {
  files=(
    ~/.inputrc
    ~/.bashrc
    ~/.gitconfig
    ~/.pshellrc
    ~/.tmux.conf
    ~/.vimrc
    ~/.git_hooks
    ~/.vdi-config-files
    ~/.local/bin
  )

  dest=~/git/.dotfiles/

  for file in "${files[@]}"; do
    # Use eval to expand ~ into variabele
    eval rsync -av --exclude="*.pem" "$file" "$dest"
    echo "$file synced to $(basename "$dest")"
  done
}

# Aliasses and functions
alias c='clear'
alias h='history'
alias la='ls -AlL'
alias ..='cd ..'
alias ...='cd ../..'

alias grepo='cd ~/git'
alias ff='firefox'
firefox() {
  command firefox "$@" & disown
}


ssh9090() {
  local server="$1"
  if [ -z "$server" ]; then
    echo "Usage: ssh9090 <servername>"
    return 1
  fi
  firefox "localhost:9090"
  echo "Starting SSH tunnel"
  ssh -L 9090:127.0.0.1:9090 "$server"
}

# Git command aliases
alias gs='git status'
alias gclone='git clone'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gd='git diff'


export PATH="$HOME/.local/bin:$PATH"
