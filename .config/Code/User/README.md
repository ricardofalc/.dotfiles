# Portable VS Code configuration

This is the VS Code equivalent of the shared Vim/tmux/Bash configuration.

Install it from the dotfiles repository with:

```sh
bin/install-vscode-config
```

The configuration intentionally keeps VS Code useful as a GUI editor. In
particular, multi-cursor editing remains native VS Code behavior:

- `Ctrl+D` adds the next matching selection.
- `Ctrl+Shift+Up/Down` adds a cursor above or below.

VSCodeVim is installed for modes, motions, operators, and normal-mode editing,
but these multi-cursor shortcuts are not remapped to Vim behavior.

Formatting is conservative: YAML and JSON format on save, while Python and
Shell formatting/linting can be enabled later once the relevant local tools are
standardized at work and at home.
