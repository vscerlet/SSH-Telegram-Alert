#!/usr/bin/env bash
# Hard-fail only if messaging is critical; otherwise exit 0 on error
set -o pipefail

TOKEN=""
CHAT_ID=""

# Trigger only once the session is fully opened
[ "$PAM_TYPE" = "open_session" ] || exit 0

USER="$PAM_USER"
SRC_IP="$PAM_RHOST"
HOSTNAME="$(hostname -f)"
WHEN="$(date '+%Y-%m-%d %H:%M:%S %Z')"

read -r -d '' MSG <<EOF
⚠️ <b>SSH Login</b>
<b>Server:</b> $HOSTNAME
<b>User:</b> $USER
<b>Source:</b> $SRC_IP
<b>Time:</b> $WHEN
EOF

curl --silent --output /dev/null \
     --data-urlencode chat_id="$CHAT_ID" \
     --data-urlencode text="$MSG" \
     --data-urlencode parse_mode=HTML \
     "https://api.telegram.org/bot${TOKEN}/sendMessage"
