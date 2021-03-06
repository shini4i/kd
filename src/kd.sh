#!/usr/bin/env bash

print_help() {
    echo "Usage: $(basename "$0") <secret_name> <namespace>"
    echo "  <secret_name>   Name of the secret to decode"
    echo "  <namespace>     Namespace of the secret (optional)"
}

parse_args() {
    secret_name=$1

    if [ $# -eq 2 ]; then
        namespace=$2
    else
        namespace=$(kubectl config view --minify -o jsonpath='{..namespace}')
        echo "No namespace specified, using currently selected namespace: $namespace"
    fi
}

main() {
    local secret

    if [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ $# -lt 1 ]; then
      print_help
      exit 0
    fi

    parse_args "$@"

    secret=$(kubectl get secret "$secret_name" -n "$namespace" -o yaml)
    echo "$secret" | yq e '.data | to_entries | .[] | .key + ": " + (.value | @base64d)'
}

main "$@"
