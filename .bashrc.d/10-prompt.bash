# Shell prompt with git branch.
parse_git_branch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Nord Palette for Bash:
# Cyan/Frost: 36 -> 38;5;110
# Blue/Frost: 34 -> 38;5;109
# Green/Aura: 32 -> 38;5;143
# Grey/Slate: 37 -> 38;5;246
export PS1="\[\e[34m\]\u\[\e[m\]\[\e[38;5;246m\]@\[\e[m\]\[\e[38;5;109m\]\h\[\e[m\]\[\e[38;5;239m\] \t \[\e[m\]\[\e[38;5;143m\]\w\[\e[m\] \[\e[1;36m\]\$(parse_git_branch)\[\e[00m\]\n$ "
