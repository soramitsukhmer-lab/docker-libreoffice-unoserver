#!/bin/sh
set -e
source /etc/os-release

# And add a trap for CTRL + C

ME=$(basename $0)
PID=$$

LIBREOFFICE_VERSION=$(libreoffice --version)
PYTHON_VERSION=$(python --version)

function logv() {
	echo "$ME [$(date)]: $@ "
}

function trap_SIGINT() {
	logv "Process interrupted by user!"
	CMD_TERM_SIGNAL=1

	if [ -f "/run/s6-linux-init-container-results/exitcode" ]; then
		echo "${1:-0}" > /run/s6-linux-init-container-results/exitcode
	fi

	test -f "/run/s6/basedir/bin/halt" && /run/s6/basedir/bin/halt
}

logv "Main process running pid $PID"
trap 'trap_SIGINT' SIGINT

logv "$PRETTY_NAME"
logv "LibreOffice version: $LIBREOFFICE_VERSION"
logv "Python version: $PYTHON_VERSION"

while true; do sleep 2; done
