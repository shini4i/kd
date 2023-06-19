#!/usr/bin/env bash

print_help() {
    cat << EOF
Usage: $(basename "$0") <secret_name> <namespace>
  <secret_name>   Name of the secret to decode
  <namespace>     Namespace of the secret (optional)

Examples:
  $(basename "$0") my-secret          # Decode the 'my-secret' secret in the current namespace
  $(basename "$0") my-secret my-ns    # Decode the 'my-secret' secret in the 'my-ns' namespace
EOF
}

set_namespace() {

    output=$(kubectl config view --minify -o jsonpath='{..namespace}')
    exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        echo "Error: Unable to get current namespace"
        exit 1
    fi

    if [ $# -eq 1 ]; then
        namespace=$1
    else
        namespace=$(kubectl config view --minify -o jsonpath='{..namespace}')
        exit_code=$?
        if [[ "$exit_code" -ne 0 ]]; then
          echo "Error: Unable to get current namespace"
          exit 1
        fi
        echo "No namespace specified, using currently selected namespace: $namespace"
    fi
}

main() {
    local secret_name=$1
    local secret_content

    case $secret_name in
        -h|--help|"") print_help; exit 0;;
    esac

    set_namespace "$2"

    secret_content=$(kubectl get secret "$secret_name" -n "$namespace" -o yaml) || { echo "Error: Unable to get secret $secret_name in namespace $namespace"; exit 1; }
    echo "$secret_content" | yq e '.data | to_entries | .[] | .key + ": " + (.value | @base64d)'
}

main "$@"
