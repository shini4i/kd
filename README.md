<div align="center">

# kd
Kubernetes secrets Decoder

![Shell](https://img.shields.io/badge/shell-bash-green)
![Version](https://img.shields.io/github/v/tag/shini4i/kd)
![license](https://img.shields.io/github/license/shini4i/kd)

<img src="https://raw.githubusercontent.com/shini4i/assets/main/src/kd/demo.png" alt="Showcase" height="441" width="620">
</div>

`kd` is a bash script that decodes Kubernetes secrets. It makes it easy to view the contents of secrets stored in a Kubernetes cluster.

There are alternatives to this script, but they are either not maintained or require way too many dependencies.

## Prerequisites

Before you can use `kd`, you need to have the following installed:

- `kubectl`: the Kubernetes command-line tool
- `yq`: a YAML parser and processor

## Installation

### Option 1: Install with Homebrew (macOS and Linux)

If you're using macOS or Linux, you can install `kd` using Homebrew. To do so, run the following command:

```bash
brew install shini4i/tap/kd
```

### Option 2: Install manually

To install `kd` manually, download the `src/kd.sh` script and add it to your PATH. You can do this by running the following commands:

```bash
curl https://raw.githubusercontent.com/shini4i/kd/main/src/kd.sh -o kd
chmod +x kd
sudo mv kd /usr/local/bin/
````

## Usage
Here are some examples of how to use kd:

```bash
# Decode a secret in the current namespace
kd my-secret

# Decode a secret in a specific namespace
kd my-secret my-namespace
```

## Contributing

Contributions to `kd` are welcome! Please open an issue or a pull request if you find a bug or want to submit a patch.

New feature requests are not expected, but suggestions for improving the existing functionality or fixing bugs are appreciated.
