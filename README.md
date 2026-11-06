# Dotfiles

Install the shared shell, tmux, Vim, Ghostty and VS Code configuration on a
fresh Fedora or macOS machine:

```bash
git clone https://github.com/ricardofalchi/.dotfiles.git ~/git/.dotfiles
cd ~/git/.dotfiles
./bin/install-dotfiles
```

The installer makes timestamped backups before replacing existing files. On
macOS it installs Homebrew Bash and makes it the default login shell. Use
`--no-shell-change` to keep the current shell, `--skip-devops-tools` to skip
the extra DevOps tooling, or `--dry-run` to inspect the actions first.
