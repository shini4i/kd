#compdef kd

_kd() {
  secrets=$(kubectl get secrets -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

  _arguments "1: :($secrets)"
}

_kd "$@"
