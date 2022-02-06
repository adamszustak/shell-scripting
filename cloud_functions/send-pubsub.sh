#! /bin/bash

DEFAULT_PORT_EVENT=9000
DEFAULT_URL="http://localhost"

get_usage() {
  cat <<<"usage: $PROGNAME [-m message JSON] [-p port]"
  return
}

generate_error() {
  echo "$1"
  get_usage
  exit 1
}

[[ -z "$1" ]] && generate_error "Provide data to send" >&2

while [[ -n $1 ]]; do
  case $1 in
  -m | --message)
    shift
    raw_message=$1
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
    exit 1
    ;;
  esac
  shift
done

echo $raw_message | python -m json.tool >>/dev/null && valid=true
[[ -z "$valid" ]] && generate_error "invalid JSON $raw_message" >&2

message_base64=$(echo -n ${raw_message} | base64)

ready_event_payload=$(
  sed \
    "s#__DATA_BASE64_PLACEHOLDER__#${message_base64}#" \
    ./base_payload.json
)
port_nr="${port_nr:=$DEFAULT_PORT_EVENT}"

cat <<-_EOF_
Run $PROGNAME with following options:
URL: ${DEFAULT_URL}:${port_nr}
PAYLOAD: ${ready_event_payload}
_EOF_

curl -X POST "${DEFAULT_URL}:${port_nr}" \
  -H 'Content-type: application/json' \
  -d "${ready_event_payload}"
