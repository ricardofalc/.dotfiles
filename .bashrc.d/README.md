# bashrc.d

`~/.bashrc` loads `*.bash` here, then `~/.bashrc.local`.

Put shared shell config here. Put work-specific config in `~/.bashrc.local`.

`40-kubeconfig.bash` provides `kubeconfig_select` and `kubeconfig_clear` for
choosing a kubeconfig in the current shell. In tmux, the selected context is
shown for that pane only. `kubectl` requires a selected kubeconfig unless an
explicit `--context` or `--kubeconfig` is provided. `--context` uses
`~/.kube/config` for that command, even when another file is selected; an
explicit `--kubeconfig` takes precedence. Both `--flag value` and `--flag=value`
are supported. These one-command overrides leave the shell selection and its
tmux labels unchanged. Without a selection or explicit target, commands remain
blocked. K9s is not
wrapped: it uses the selected `KUBECONFIG` when set, or defaults to
`~/.kube/config` when unset.

`kube_namespace_select` and `kube_namespace_clear` manage a shell-local
namespace override. Both `k` and `kubectl` use that namespace unless a command
specifies `-n`, `--namespace`, or `--all-namespaces` (`-A`). An explicit
`--context` or `--kubeconfig` also bypasses the saved namespace override;
pass `-n` when needed for that target. The tmux label shows the saved shell
selection, not a one-off command's target or namespace.
Selecting or clearing a kubeconfig, or switching context
with `kubectl config use-context`, clears the namespace override. A manual
`KUBECONFIG` change is detected before the next `k`/`kubectl` command. The
namespace picker lists namespaces and previews pods using read-only requests.
The `kns` and `kns-` aliases select and clear the namespace, respectively.

Tab completion for `k` and `kubectl` uses the selected namespace too, including
resource-name completion. Explicit namespace and target flags take precedence
for completion just as they do for normal commands. Resource-name completion
may make read-only requests to the selected cluster.
