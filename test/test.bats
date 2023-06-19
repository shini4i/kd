#!/usr/bin/env bats

@test "script should return specific output when no parameters are provided" {
  run ./src/kd.sh

  local expected_output

  expected_output=(
    "Usage: kd.sh <secret_name> <namespace>"
    "  <secret_name>   Name of the secret to decode"
    "  <namespace>     Namespace of the secret (optional)"
    "Examples:"
    "  kd.sh my-secret          # Decode the 'my-secret' secret in the current namespace"
    "  kd.sh my-secret my-ns    # Decode the 'my-secret' secret in the 'my-ns' namespace"
  )

  expected_lines="${#expected_output[@]}"
  actual_lines="${#lines[@]}"

  # Check if the number of lines match
  [ "$expected_lines" -eq "$actual_lines" ] || {
    echo "Error: Number of lines does not match. Expected: $expected_lines, Actual: $actual_lines"
    exit 1
  }

  # Check if each line matches the expected output
  for ((i = 0; i < expected_lines; i++)); do
    [ "${lines[i]}" = "${expected_output[i]}" ]
  done
}

@test "script should fail if it can't detect currently selected namespace" {
  export KUBECONFIG=non-existent-file

  run ./src/kd.sh my-secret

  local expected_status
  local expected_output

  expected_status=1
  expected_output="Error: Unable to get current namespace"

  [ "$status" -eq "$expected_status" ]

  echo "$output" | grep -q "$expected_output"
}

@test "script should take value from specific secret in a provided namespace" {
  run ./src/kd.sh example-secret example-ns

  local expected_output

  expected_output=(
    "example: provided"
  )
  expected_lines="${#expected_output[@]}"
  actual_lines="${#lines[@]}"

  # Check if the number of lines match
  [ "$expected_lines" -eq "$actual_lines" ] || {
    echo "Error: Number of lines does not match. Expected: $expected_lines, Actual: $actual_lines"
    exit 1
  }

  # Check if each line matches the expected output
  for ((i = 0; i < expected_lines; i++)); do
    if [ "${lines[i]}" != "${expected_output[i]}" ]; then
      echo "Error: Line $((i+1)) does not match. Expected: '${expected_output[i]}', Actual: '${lines[i]}'"
      exit 1
    fi
  done

}

@test "script should fall back to current namespace when no namespace is provided" {
  run ./src/kd.sh example-secret

  local expected_output

  expected_output=(
    "No namespace specified, using currently selected namespace: default"
    "example: not-provided"
  )

  expected_lines="${#expected_output[@]}"
  actual_lines="${#lines[@]}"

  # Check if the number of lines match
  [ "$expected_lines" -eq "$actual_lines" ] || {
    echo "Error: Number of lines does not match. Expected: $expected_lines, Actual: $actual_lines"
    exit 1
  }

  # Check if each line matches the expected output
  for ((i = 0; i < expected_lines; i++)); do
    if [ "${lines[i]}" != "${expected_output[i]}" ]; then
      echo "Error: Line $((i+1)) does not match. Expected: '${expected_output[i]}', Actual: '${lines[i]}'"
      exit 1
    fi
  done
}
