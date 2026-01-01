# Bash completion script for kd (Kubernetes secrets Decoder)
#
# This script provides tab completion for:
#   - First argument: Kubernetes secret names in the current namespace
#   - Second argument: Kubernetes namespace names
#
# Installation:
#   Source this file in your .bashrc:
#     source /path/to/_kd.bash
#
#   Or copy to /etc/bash_completion.d/ (system-wide)

_kd_completions() {
  local cur secrets namespaces

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  case $COMP_CWORD in
    1)
      # Complete secret names
      if secrets=$(kubectl get secrets --no-headers -o custom-columns=':metadata.name' 2>/dev/null); then
        # shellcheck disable=SC2207
        COMPREPLY=($(compgen -W "$secrets" -- "$cur"))
      fi
      ;;
    2)
      # Complete namespace names
      if namespaces=$(kubectl get namespaces --no-headers -o custom-columns=':metadata.name' 2>/dev/null); then
        # shellcheck disable=SC2207
        COMPREPLY=($(compgen -W "$namespaces" -- "$cur"))
      fi
      ;;
  esac

  return 0
}

complete -F _kd_completions kd
