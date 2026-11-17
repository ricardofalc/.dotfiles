# Per-shell Kubernetes config selection and tmux pane status.

__dotfiles_kubeconfig_sync_tmux() {
  local context="${1:-}"

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

  export KUBECONFIG="$selected"
  __dotfiles_kubeconfig_sync_tmux "$context"
  printf 'Kubernetes context set to %s.\n' "$context"
}

kubeconfig_clear() {
  unset KUBECONFIG
  __dotfiles_kubeconfig_sync_tmux
  printf 'Kubernetes context cleared for this shell.\n'
}

kubectl() {
  if [[ -z "${KUBECONFIG:-}" ]]; then
    __dotfiles_kubeconfig_sync_tmux
    printf 'kubectl: no kubeconfig selected; run kubeconfig_select first.\n' >&2
    return 1
  fi

  # Update before running so a manually changed KUBECONFIG is visible first.
  __dotfiles_kubeconfig_sync_tmux
  local kubectl_status=0
  command kubectl "$@" || kubectl_status=$?

  # A config command may have changed the active context in the selected file.
  if [[ "${1:-}" == config ]]; then
    __dotfiles_kubeconfig_sync_tmux
  fi

  return "$kubectl_status"
}
