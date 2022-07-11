<div align="center">

# kd
Kubernetes secrets Decoder

![Version](https://img.shields.io/github/v/tag/shini4i/kd?style=plastic)
![license](https://img.shields.io/github/license/shini4i/kd?style=plastic)

![demo](https://i.ibb.co/TbcXn8c/demo.png)
</div>

<b>kd</b> is yet another attempt to create a super simple and easy to use cli tool
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
If the namespace is omitted, the currently selected namespace will be used.
