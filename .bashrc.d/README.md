# bashrc.d

`~/.bashrc` loads `*.bash` here, then `~/.bashrc.local`.

Put shared shell config here. Put work-specific config in `~/.bashrc.local`.

`40-kubeconfig.bash` provides `kubeconfig_select` and `kubeconfig_clear` for
choosing a kubeconfig in the current shell. In tmux, the selected context is
shown for that pane only. `kubectl` refuses to run until a kubeconfig has been
selected, avoiding an implicit fallback to `~/.kube/config`. K9s is not
wrapped: it uses the selected `KUBECONFIG` when set, or defaults to
`~/.kube/config` when unset.

`kube_namespace_select` and `kube_namespace_clear` manage a shell-local
namespace override. The `k` function uses that namespace unless a command
specifies `-n` or `--namespace`; direct `kubectl` commands do not receive the
namespace override. Selecting or clearing a kubeconfig, or switching context
with `kubectl config use-context`, clears the namespace override. A manual
`KUBECONFIG` change is detected before the next `k`/`kubectl` command. The
namespace picker lists namespaces and previews pods using read-only requests.
The `kns` and `kns-` aliases select and clear the namespace, respectively.
