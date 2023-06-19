#!/usr/bin/env bash

print_help() {
  cat <<EOF
Usage: $(basename "$0") <secret_name> <namespace>
  <secret_name>   Name of the secret to decode
  <namespace>     Namespace of the secret (optional)

Examples:
  $(basename "$0") my-secret          # Decode the 'my-secret' secret in the current namespace
  $(basename "$0") my-secret my-ns    # Decode the 'my-secret' secret in the 'my-ns' namespace
EOF
}

set_namespace() {
  namespace=$1
  if [ -z "$namespace" ]; then
    namespace=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null)
    [ -z "$namespace" ] && {
      echo "Error: Unable to get current namespace"
      exit 1
    }
    echo "No namespace specified, using currently selected namespace: $namespace"
  fi
}

main() {
  local secret_name=$1
  local secret_content

  case $secret_name in
  -h | --help | "")
    print_help
    exit 0
    ;;
  esac

  set_namespace "$2"

  if ! secret_content=$(kubectl get secret "$secret_name" -n "$namespace" -o yaml); then
    echo "Error: Unable to get secret $secret_name in namespace $namespace"
    exit 1
  fi

  echo "$secret_content" | yq e '.data | to_entries | .[] | .key + ": " + (.value | @base64d)'
}

main "$@"
