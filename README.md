# kd

This script is yet another attempt to create a super simple and easy to use cli tool
that will help with kubernetes secrets decoding.

There are alternatives to this script, but they are either not maintained or require way too many dependencies.

## Requirements
- kubectl
- yq

## Usage
```bash
kd <secret-name> <namespace>
```
If the namespace is omitted, the current namespace will be used.
