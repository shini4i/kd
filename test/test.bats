#!/usr/bin/env bats

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'
}

@test "script should return help output when no parameters are provided" {
  run ./src/kd.sh

  assert_success
  assert_output --partial "Usage: kd <secret_name> [namespace]"
  assert_output --partial "-h, --help"
  assert_output --partial "-v, --version"
}

@test "script should return help output when -h flag is provided" {
  run ./src/kd.sh -h

  assert_success
  assert_output --partial "Usage: kd <secret_name> [namespace]"
}

@test "script should return help output when --help flag is provided" {
  run ./src/kd.sh --help

  assert_success
  assert_output --partial "Usage: kd <secret_name> [namespace]"
}

@test "script should return version when -v flag is provided" {
  run ./src/kd.sh -v

  assert_success
  assert_output "kd version 0.1.4"
}

@test "script should return version when --version flag is provided" {
  run ./src/kd.sh --version

  assert_success
  assert_output "kd version 0.1.4"
}

@test "script should fail if it can't detect currently selected namespace" {
  export KUBECONFIG=non-existent-file

  run ./src/kd.sh my-secret

  assert_failure
  assert_output --partial "Unable to determine current namespace"
}

@test "script should take value from specific secret in a provided namespace" {
  run ./src/kd.sh example-secret example-ns

  assert_success
  assert_output "example: provided"
}

@test "script should fall back to current namespace when no namespace is provided" {
  run ./src/kd.sh example-secret

  assert_success
  assert_output --partial "No namespace specified, using currently selected namespace: default"
  assert_output --partial "example: not-provided"
}

@test "script should fail to get the non-existing secret with reasonable error" {
  run ./src/kd.sh non-existing-secret

  assert_failure
  assert_output --partial "Unable to get secret 'non-existing-secret' in namespace 'default'"
  assert_output --partial "kubectl:"
}

@test "script should handle secrets with multiple keys" {
  run ./src/kd.sh multi-key-secret

  assert_success
  assert_output --partial "key1: value1"
  assert_output --partial "key2: value2"
  assert_output --partial "key3: value3"
}

@test "script should handle secret values with special characters" {
  run ./src/kd.sh special-secret

  assert_success
  assert_output --partial "key: value with spaces"
}

@test "script should reject secret names starting with dash" {
  run ./src/kd.sh -invalid-name

  assert_failure
  assert_output --partial "Invalid secret name '-invalid-name': cannot start with '-'"
}
