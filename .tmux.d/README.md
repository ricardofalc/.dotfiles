# tmux.d

`~/.tmux.conf` sets shared defaults, then loads `~/.tmux.local.conf`, then loads these modules.

Use `~/.tmux.local.conf` for machine-specific feature flags:

```tmux
set -g @tmux_enable_fzf 0
set -g @tmux_enable_wayland_clipboard 0
```

Use `~/.tmux.after.conf` for overrides that must run after all modules.

