#!/usr/bin/env bash
#
# kd - Kubernetes secrets Decoder
# A simple tool to decode and display Kubernetes secrets.
#
# Usage: kd <secret_name> [namespace]
#

set -euo pipefail

readonly VERSION="0.2.0"

# Prints an error message to stderr in red.
# Arguments:
#   $@ - The error message to print
# Returns:
#   None
error() {
  echo -e "\033[0;31mError: $*\033[0m" >&2
}

# Prints an info message to stderr in yellow.
# Arguments:
#   $@ - The info message to print
# Returns:
#   None
info() {
  echo -e "\033[0;33m$*\033[0m" >&2
}

# Prints the help message to stdout.
# Arguments:
#   None
# Returns:
#   None
print_help() {
  cat <<EOF
Usage: kd <secret_name> [namespace]

Arguments:
  <secret_name>   Name of the secret to decode
  [namespace]     Namespace of the secret (optional, defaults to current namespace)

Options:
  -h, --help      Show this help message
  -v, --version   Show version information

Examples:
  kd my-secret          # Decode the 'my-secret' secret in the current namespace
  kd my-secret my-ns    # Decode the 'my-secret' secret in the 'my-ns' namespace
EOF
}

# Prints the version information to stdout.
# Arguments:
#   None
# Returns:
#   None
print_version() {
  echo "kd version ${VERSION}"
}

# Determines the namespace to use for the secret lookup.
# If a namespace is provided, it is used directly.
# Otherwise, attempts to get the current namespace from kubectl config.
# Arguments:
#   $1 - The namespace provided by the user (may be empty)
# Returns:
#   Prints the namespace to stdout on success, exits with error on failure.
get_namespace() {
  local ns="${1:-}"
  local kubectl_output

  if [[ -n "$ns" ]]; then
    echo "$ns"
    return 0
  fi

  if ! kubectl_output=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>&1); then
    error "Failed to query kubectl config: ${kubectl_output}"
    return 1
  fi

  if [[ -z "$kubectl_output" ]]; then
    error "Unable to determine current namespace from kubectl config"
    return 1
  fi

  info "No namespace specified, using currently selected namespace: ${kubectl_output}"
  echo "$kubectl_output"
}

# Main entry point for the script.
# Parses arguments and decodes the specified Kubernetes secret.
# Arguments:
#   $1 - Secret name or option flag
#   $2 - Namespace (optional)
# Returns:
#   0 on success, non-zero on failure
main() {
  local secret_name="${1:-}"
  local namespace
  local secret_content
  local kubectl_output

  case "$secret_name" in
    -h | --help | "")
      print_help
      return 0
      ;;
    -v | --version)
      print_version
      return 0
      ;;
    -*)
      error "Invalid secret name '${secret_name}': cannot start with '-'"
      return 1
      ;;
  esac

  if ! namespace=$(get_namespace "${2:-}"); then
    return 1
  fi

  if ! kubectl_output=$(kubectl get secret "$secret_name" -n "$namespace" -o yaml 2>&1); then
    error "Unable to get secret '${secret_name}' in namespace '${namespace}'"
    echo "kubectl: ${kubectl_output}" >&2
    return 1
  fi
  secret_content="$kubectl_output"

  echo "$secret_content" | yq e '.data | to_entries | .[] | .key + ": " + (.value | @base64d)'
}

main "$@"
