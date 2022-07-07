# kd

This script is yet another attempt to create a super simple and easy to use cli tool
that will help with kubernetes secrets decoding.

There are alternatives to this script, but they are either not maintained or require way too many dependencies.

## Requirements
- kubectl
- yq

## Installation
The script can be installed using brew:
```bash
brew install shini4i/tap/kd
```

## Usage
```bash
kd <secret-name> <namespace>
```
If the namespace is omitted, the current namespace will be used.
