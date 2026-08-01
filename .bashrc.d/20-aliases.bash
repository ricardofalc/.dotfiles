# Aliases and functions.
alias c='clear'
alias pls='sudo !!'
alias h='history'
alias la='ls -AlL'
alias ls='ls --color=auto'
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

# Git command aliases.
alias gs='git status'
alias gclone='git clone'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gd='git diff'
