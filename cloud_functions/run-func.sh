#! /bin/bash

DEFAULT_PORT_HTTP=8000
DEFAULT_PORT_EVENT=9000
DEFAULT_FUNCTION_NAME=main

PROGNAME=$(basename $0)
get_usage() {
  cat <<<"usage: $PROGNAME [-f file] [-st signature-type=[event|http]] [-fn function-name] [-p port]"
  return
}

generate_error() {
  echo "$1"
  get_usage
  exit 1
}

[[ -z "$1" ]] && generate_error "Provide file to run" >&2

while [[ -n $1 ]]; do
  case $1 in
  -f | --file)
    shift
    filename=$1
    ;;
  -fn | --function-name)
    shift
    function_name=$1
    ;;
  -st | --signature-type)
    shift
    case $1 in
    event | pubsub)
      signature_type=event
      ;;
    http)
      signature_type=http
      ;;
    *)
      generate_error "Unknown signature type option: $1" >&2
      ;;
    esac
    ;;
  -p | --port)
    shift
    port_nr=$1
    ;;
  -h | --help)
    get_usage
    exit
    ;;
  *)
    generate_error "$PROGNAME: invalid option: $1" >&2
    ;;
  esac
  shift
done

source_dir="$(pwd)/$filename"
! [[ -f "$source_dir" ]] && generate_error "File does not exists in given directory: $source_dir" >&2
[[ -z "$signature_type" ]] && generate_error "Provide signature type to run [event|http]" >&2

function_name="${function_name:=$DEFAULT_FUNCTION_NAME}"
if [[ -z "$port_nr" ]]; then
  if [[ "$signature_type" == "event" ]]; then
    port_nr=$DEFAULT_PORT_EVENT
  else
    port_nr=$DEFAULT_PORT_HTTP
  fi
fi

cat <<-_EOF_
Run $PROGNAME with following options:
filename: $filename
function_name: $function_name
signature_type: $signature_type
port_nr: $port_nr
_EOF_

functions-framework \
  --source=${source_dir} \
  --target=${function_name} \
  --signature-type=${signature_type} \
  --port=${port_nr} \
  --debug
