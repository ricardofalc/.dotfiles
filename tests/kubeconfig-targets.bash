#!/usr/bin/env bash
# Offline regression tests: never run the real kubectl or contact a cluster.
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
temp_root="${TMPDIR:-/tmp}"
fixture="$(mktemp -d "$temp_root/kubeconfig-targets.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT
mkdir -p "$fixture/bin" "$fixture/home/.kube"
cat > "$fixture/bin/kubectl" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "${KUBECONFIG:-unset}" > "$TEST_LOG"
printf '%s\n' "$@" >> "$TEST_LOG"
exit "${TEST_EXIT:-0}"
MOCK
chmod +x "$fixture/bin/kubectl"
export PATH="$fixture/bin:$PATH" HOME="$fixture/home" TEST_LOG="$fixture/call"
unset TMUX_PANE KUBECONFIG KUBE_NAMESPACE
# shellcheck source=.bashrc.d/40-kubeconfig.bash
source "$root/.bashrc.d/40-kubeconfig.bash"

# No target remains blocked and never invokes the executable.
if kubectl get pods 2>/dev/null; then exit 1; fi
[[ ! -e "$TEST_LOG" ]]

kubectl --context rg04 -n team get pods
[[ "$(head -n 1 "$TEST_LOG")" == "$HOME/.kube/config" ]]
[[ -z "${KUBECONFIG+x}" ]]
grep -Fx -- rg04 "$TEST_LOG" >/dev/null

export KUBECONFIG=/selected KUBE_NAMESPACE=saved
kubectl --context=rg05 get pods
[[ "$(head -n 1 "$TEST_LOG")" == "$HOME/.kube/config" ]]
[[ "$KUBECONFIG" == /selected && "$KUBE_NAMESPACE" == saved ]]

kubectl --kubeconfig /explicit --context rg06 get pods
grep -Fx -- /explicit "$TEST_LOG" >/dev/null
[[ "$(head -n 1 "$TEST_LOG")" == /selected ]]

unset KUBECONFIG
kubectl --kubeconfig=/explicit get pods
[[ -z "${KUBECONFIG+x}" ]]
grep -Fx -- --kubeconfig=/explicit "$TEST_LOG" >/dev/null

export KUBECONFIG=/selected KUBE_NAMESPACE=saved
k --context rg04 -n team get pods
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
[[ "$KUBE_NAMESPACE" == saved && "$KUBECONFIG" == /selected ]]

k --kubeconfig=/explicit get pods
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
__dotfiles_kubeconfig_sync_tmux
export KUBE_NAMESPACE=saved
k get pods
grep -Fx -- saved "$TEST_LOG" >/dev/null
kubectl get pods
grep -Fx -- saved "$TEST_LOG" >/dev/null
[[ "$KUBE_NAMESPACE" == saved ]]

kubectl get pods -n other
grep -Fx -- other "$TEST_LOG" >/dev/null
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
[[ "$KUBE_NAMESPACE" == saved ]]

kubectl get pods -A
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
[[ "$KUBE_NAMESPACE" == saved ]]

kubectl config current-context
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
[[ "$KUBE_NAMESPACE" == saved ]]

if TEST_EXIT=42 kubectl config use-context another; then exit 1; fi
[[ "$KUBE_NAMESPACE" == saved ]]
kubectl config use-context another
[[ -z "${KUBE_NAMESPACE:-}" ]]

export KUBE_NAMESPACE=saved
k __complete get pods ''
grep -Fx -- saved "$TEST_LOG" >/dev/null
[[ "$(sed -n '2p' "$TEST_LOG")" == __complete ]]
[[ "$(tail -n 1 "$TEST_LOG")" == '' ]]
kubectl __complete get pods -n other ''
grep -Fx -- other "$TEST_LOG" >/dev/null
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
kubectl __complete get pods -A ''
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
kubectl __complete --context rg04 get pods ''
[[ "$(head -n 1 "$TEST_LOG")" == "$HOME/.kube/config" ]]
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
kubectl __complete --kubeconfig=/explicit get pods ''
grep -Fx -- --kubeconfig=/explicit "$TEST_LOG" >/dev/null
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
[[ "$KUBE_NAMESPACE" == saved && "$KUBECONFIG" == /selected ]]
kubectl __completeNoDesc get pods ''
grep -Fx -- saved "$TEST_LOG" >/dev/null
[[ "$(sed -n '2p' "$TEST_LOG")" == __completeNoDesc ]]
kubectl __complete config get-contexts ''
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi

kube_namespace_clear >/dev/null
kubectl get pods
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi
kubectl __complete get pods ''
if grep -Fx -- saved "$TEST_LOG" >/dev/null; then exit 1; fi

if TEST_EXIT=42 kubectl --context rg04 get pods; then
  exit 1
else
  [[ $? -eq 42 ]]
fi

unset KUBECONFIG
kubectl __complete get pods ''
[[ "$(head -n 1 "$TEST_LOG")" == /dev/null ]]
rm -- "$TEST_LOG"
if kubectl --context= get pods 2>/dev/null; then exit 1; fi
if kubectl exec pod -- tool --context rg04 2>/dev/null; then exit 1; fi
[[ ! -e "$TEST_LOG" ]]
printf 'Explicit kubeconfig/context tests passed.\n'
