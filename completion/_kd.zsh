#compdef kd

# Zsh completion script for kd (Kubernetes secrets Decoder)
#
# This script provides tab completion for:
#   - First argument: Kubernetes secret names in the current namespace
#   - Second argument: Kubernetes namespace names

_kd() {
  local -a secrets namespaces

  case $CURRENT in
    2)
      # Complete secret names
      secrets=(${(f)"$(kubectl get secrets --no-headers -o custom-columns=':metadata.name' 2>/dev/null)"})
      if (( ${#secrets} > 0 )); then
        _describe -t secrets 'secret' secrets
      fi
      ;;
    3)
      # Complete namespace names
      namespaces=(${(f)"$(kubectl get namespaces --no-headers -o custom-columns=':metadata.name' 2>/dev/null)"})
      if (( ${#namespaces} > 0 )); then
        _describe -t namespaces 'namespace' namespaces
      fi
      ;;
  esac
}

_kd "$@"
