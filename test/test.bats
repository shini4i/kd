#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
}

@test "script should return specific output when no parameters are provided" {
  run ./src/kd.sh

  local expected_output

  expected_output=$(
    cat <<EOF
Usage: kd.sh <secret_name> <namespace>
  <secret_name>   Name of the secret to decode
  <namespace>     Namespace of the secret (optional)

Examples:
  kd.sh my-secret          # Decode the 'my-secret' secret in the current namespace
  kd.sh my-secret my-ns    # Decode the 'my-secret' secret in the 'my-ns' namespace
EOF
  )

  # Check if the entire output matches the expected output
  assert_output "$expected_output"
}

@test "script should fail if it can't detect currently selected namespace" {
  export KUBECONFIG=non-existent-file

  run ./src/kd.sh my-secret

  assert_equal "$status" 1
  assert_output --partial "Error: Unable to get current namespace"
}

@test "script should take value from specific secret in a provided namespace" {
  run ./src/kd.sh example-secret example-ns
  assert_output "example: provided"
}

@test "script should fall back to current namespace when no namespace is provided" {
  run ./src/kd.sh example-secret

  local expected_output

  expected_output=$(
    cat <<EOF
No namespace specified, using currently selected namespace: default
example: not-provided
EOF
  )

  assert_output "${expected_output}"
}

@test "script should fail to get the non-existing secret with reasonable error " {
  run ./src/kd.sh non-existing-secret

  assert_output --partial "Error: Unable to get secret non-existing-secret in namespace default"
}
