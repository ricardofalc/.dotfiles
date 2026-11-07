# Dotfiles

Install the shared shell, tmux, Vim, Ghostty, Vicinae and VS Code configuration
on a fresh Fedora or macOS machine:

```bash
git clone https://github.com/ricardofalchi/.dotfiles.git ~/git/.dotfiles
cd ~/git/.dotfiles
./bin/install-dotfiles
```

The installer makes timestamped backups before replacing existing files. On
macOS it installs Homebrew Bash and makes it the default login shell. Use
`--no-shell-change` to keep the current shell, `--skip-devops-tools` to skip
the extra DevOps tooling, or `--dry-run` to inspect the actions first.

On Fedora, the installer installs Vicinae from its COPR repository, keeps any
existing launcher installed, installs and enables the official Vicinae GNOME
extension when GNOME is detected, configures the Deep Nord theme, and pins
window search as the first favorite. GNOME autostart and global shortcuts are
not enabled by default; `--enable-vicinae-gnome-shortcut` is an explicit opt-in.
Vicinae's browser integration still requires installing its official browser
extension in Chrome/Brave/Firefox.
