#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}"  )" &> /dev/null && pwd  )
SERVICE_NAME=$(basename $SCRIPT_DIR)

rm /service/$SERVICE_NAME
kill $(ps | grep "supervise $SERVICE_NAME" | grep -wv 'grep\|vi\|vim' | awk '{print $1}')
chmod a-x $SCRIPT_DIR/service/run
$SCRIPT_DIR/restart.sh
