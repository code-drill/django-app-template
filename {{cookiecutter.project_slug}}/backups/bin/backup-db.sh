#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "${SCRIPT_DIR}/common.sh"

check_env_vars DATABASE_URL

TARGET_FILENAME="db_dump_$(date +%Y-%m-%d_%H%M%S).Fc.dump.zstd"

DUMP_DB_TO_STDOUT=(
  pg_dump -Fc --compress=zstd -c --if-exists "$DATABASE_URL"
)

mkdir -p "$BACKUP_LOCAL_DIR"
TARGET="$BACKUP_LOCAL_DIR/$TARGET_FILENAME"
"${DUMP_DB_TO_STDOUT[@]}" > "$TARGET"

echo "$TARGET_FILENAME"