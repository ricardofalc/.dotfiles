# Per-shell Kubernetes config selection and tmux pane status.

__dotfiles_kubeconfig_sync_tmux() {
  local context="${1:-}"
  local namespace="${KUBE_NAMESPACE:-}"

  # A namespace override must not leak across manually changed kubeconfigs.
  if [[ -n "${__dotfiles_last_kubeconfig+x}" && "${KUBECONFIG:-}" != "$__dotfiles_last_kubeconfig" ]]; then
    unset KUBE_NAMESPACE
    namespace=""
  fi
  __dotfiles_last_kubeconfig="${KUBECONFIG:-}"

  [[ -n "${TMUX_PANE:-}" ]] || return 0
  command -v tmux >/dev/null 2>&1 || return 0

  if [[ -z "${KUBECONFIG:-}" ]]; then
    command tmux set-option -p -u -t "$TMUX_PANE" @kube_context >/dev/null 2>&1 || true
  else
    if [[ -z "$context" ]]; then
      context="$(command kubectl config current-context 2>/dev/null)" || context=""
    fi

    if [[ -z "$context" ]]; then
      context="context-unavailable"
    fi

    # Keep arbitrary context names from being interpreted as tmux format strings.
    context="${context//[^[:alnum:]_.:@+-]/_}"
    context="${context:0:40}"
    command tmux set-option -p -t "$TMUX_PANE" @kube_context "$context" >/dev/null 2>&1 || true
  fi

  if [[ -n "${KUBECONFIG:-}" && -n "$namespace" ]]; then
    namespace="${namespace//[^[:alnum:]_.-]/_}"
    namespace="${namespace:0:63}"
    command tmux set-option -p -t "$TMUX_PANE" @kube_namespace "$namespace" >/dev/null 2>&1 || true
  else
    command tmux set-option -p -u -t "$TMUX_PANE" @kube_namespace >/dev/null 2>&1 || true
  fi

  command tmux refresh-client -S >/dev/null 2>&1 || true
}

kubeconfig_select() {
  local no_context="[No context]"
  local selected

  if ! command -v fzf >/dev/null 2>&1; then
    printf 'kubeconfig_select: fzf is required.\n' >&2
    return 127
  fi

  if [[ ! -d "$HOME/.kube" ]]; then
    printf 'kubeconfig_select: %s/.kube does not exist.\n' "$HOME" >&2
    return 1
  fi

  if ! selected="$({
    printf '%s\n' "$no_context"
    find "$HOME/.kube" -path '*/cache' -prune -o \( -type f -o -type l \) -print 2>/dev/null
  } | fzf --prompt='Kubeconfig> ' --header='Choose a kubeconfig or [No context] to clear')"; then
    return 0
  fi

  [[ -n "$selected" ]] || return 0

  if [[ "$selected" == "$no_context" ]]; then
    kubeconfig_clear
    return 0
  fi

  local context
  if ! context="$(command kubectl --kubeconfig "$selected" config current-context 2>/dev/null)" || [[ -z "$context" ]]; then
    printf 'kubeconfig_select: could not read a current context from %s.\n' "$selected" >&2
    return 1
  fi

  unset KUBE_NAMESPACE
  export KUBECONFIG="$selected"
  __dotfiles_kubeconfig_sync_tmux "$context"
  printf 'Kubernetes context set to %s.\n' "$context"
}

kubeconfig_clear() {
  unset KUBECONFIG
  unset KUBE_NAMESPACE
  __dotfiles_kubeconfig_sync_tmux
  printf 'Kubernetes context cleared for this shell.\n'
}

kube_namespace_select() {
  local no_namespace="[No namespace override]"
  local namespaces
  local selected

  if [[ -z "${KUBECONFIG:-}" ]]; then
    printf 'kube_namespace_select: select a kubeconfig first with kubeconfig_select.\n' >&2
    return 1
  fi

  if ! command -v fzf >/dev/null 2>&1; then
    printf 'kube_namespace_select: fzf is required.\n' >&2
    return 127
  fi

  # Apply any manually changed KUBECONFIG before querying the namespace list.
  __dotfiles_kubeconfig_sync_tmux

  if ! namespaces="$(kubectl get namespaces -o custom-columns=:metadata.name --no-headers)"; then
    return 1
  fi

  if ! selected="$(printf '%s\n%s\n' "$no_namespace" "$namespaces" | fzf \
    --prompt='Namespace> ' \
    --header="Choose a namespace; current: ${KUBE_NAMESPACE:-none}" \
    --preview="value={}; if [ \"\$value\" = \"[No namespace override]\" ]; then printf 'Use the kubeconfig context default namespace'; else kubectl get pods --namespace \"\$value\"; fi" \
    --preview-window=right,60%,border-left)"; then
    return 0
  fi

  [[ -n "$selected" ]] || return 0

  if [[ "$selected" == "$no_namespace" ]]; then
    kube_namespace_clear
    return 0
  fi

  export KUBE_NAMESPACE="$selected"
  __dotfiles_kubeconfig_sync_tmux
  printf 'Kubernetes namespace set to %s.\n' "$selected"
}

kube_namespace_clear() {
  unset KUBE_NAMESPACE
  __dotfiles_kubeconfig_sync_tmux
  printf 'Kubernetes namespace override cleared for this shell.\n'
}

# Match explicit, nonempty targeting options before any command payload (`--`).
__dotfiles_kube_has_option() {
  local option="$1"
  shift
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --) return 1 ;;
      "$option")
        [[ $# -gt 1 && -n "$2" && "$2" != -* ]] && return 0
        ;;
      "$option"=*)
        [[ -n "${1#*=}" ]] && return 0
        ;;
    esac
    shift
  done
  return 1
}

k() {
  kubectl "$@"
}

__dotfiles_kube_has_namespace() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      --) break ;;
      -n|--namespace|--namespace=*|-n?*|-A|--all-namespaces|--all-namespaces=*) return 0 ;;
    esac
  done
  return 1
}

kubectl() {
  # Completion must use the same target/namespace without changing pane status.
  if [[ "${1:-}" == __complete || "${1:-}" == __completeNoDesc ]]; then
    local completion_command="$1"
    shift
    if __dotfiles_kube_has_option --kubeconfig "$@"; then
      command kubectl "$completion_command" "$@"
    elif __dotfiles_kube_has_option --context "$@"; then
      KUBECONFIG="$HOME/.kube/config" command kubectl "$completion_command" "$@"
    elif [[ -z "${KUBECONFIG:-}" ]]; then
      # Never fall back to the default kubeconfig for implicit completion.
      KUBECONFIG=/dev/null command kubectl "$completion_command" "$@"
    elif [[ -n "${KUBE_NAMESPACE:-}" && "${__dotfiles_last_kubeconfig:-$KUBECONFIG}" == "$KUBECONFIG" ]] \
      && ! __dotfiles_kube_has_namespace "$@"; then
      case "${1:-}" in
        config|completion|version)
          command kubectl "$completion_command" "$@" ;;
        *)
          command kubectl "$completion_command" --namespace "$KUBE_NAMESPACE" "$@" ;;
      esac
    else
      command kubectl "$completion_command" "$@"
    fi
    return $?
  fi

  # Explicit targets apply only to this command, never to the shell selection.
  if __dotfiles_kube_has_option --kubeconfig "$@"; then
    command kubectl "$@"
    return $?
  fi
  if __dotfiles_kube_has_option --context "$@"; then
    KUBECONFIG="$HOME/.kube/config" command kubectl "$@"
    return $?
  fi

  if [[ -z "${KUBECONFIG:-}" ]]; then
    __dotfiles_kubeconfig_sync_tmux
    printf 'kubectl: select a kubeconfig or pass --context or --kubeconfig explicitly.\n' >&2
    return 1
  fi

  # Update before running so a manually changed KUBECONFIG is visible first.
  __dotfiles_kubeconfig_sync_tmux
  local explicit_namespace=0
  local namespace_command=1
  case "${1:-}" in
    config|completion|version) namespace_command=0 ;;
  esac
  if __dotfiles_kube_has_namespace "$@"; then
    explicit_namespace=1
  fi

  local kubectl_status=0
  if [[ -n "${KUBE_NAMESPACE:-}" && "$explicit_namespace" -eq 0 && "$namespace_command" -eq 1 ]]; then
    command kubectl --namespace "$KUBE_NAMESPACE" "$@" || kubectl_status=$?
  else
    command kubectl "$@" || kubectl_status=$?
  fi

  # A config command may have changed the active context in the selected file.
  if [[ "${1:-}" == config ]]; then
    if [[ "${2:-}" == use-context && "$kubectl_status" -eq 0 ]]; then
      unset KUBE_NAMESPACE
    fi
    __dotfiles_kubeconfig_sync_tmux
  fi

  return "$kubectl_status"
}

# The completion framework is loaded after this file in ~/.bashrc.local.
complete -o default -F __start_kubectl k 2>/dev/null || true
