# bashrc.d

`~/.bashrc` loads `*.bash` here, then `~/.bashrc.local`.

Put shared shell config here. Put work-specific config in `~/.bashrc.local`.

`40-kubeconfig.bash` provides `kubeconfig_select` and `kubeconfig_clear` for
choosing a kubeconfig in the current shell. In tmux, the selected context is
shown for that pane only. `kubectl` refuses to run until a kubeconfig has been
selected, avoiding an implicit fallback to `~/.kube/config`. K9s is not
wrapped: it uses the selected `KUBECONFIG` when set, or defaults to
`~/.kube/config` when unset.
