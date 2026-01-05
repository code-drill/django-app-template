#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${SCRIPT_DIR}/common.sh"

if [[ $# -ne 1 ]]; then
    echo "Usage: ./restore-db.sh <FILE>"
    "${SCRIPT_DIR}"/list-backups.sh
    exit 2
fi

pg_restore -c -d "$DATABASE_URL" < "$1"

echo 'restore finished'