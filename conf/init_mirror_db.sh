#!/bin/bash
set -e

# Check if PGDATA is empty
if [ -z "$(ls -A "$PGDATA")" ]; then
    echo "Initializing mirror database..."
    
    # Take a base backup from the primary
    PGPASSWORD=$REPLICATION_PASSWORD pg_basebackup -h $PRIMARY_IP -p $PRIMARY_PORT -D "$PGDATA" -U $REPLICATION_USER -v -P -X stream
    
    # Create recovery.signal file to start in recovery mode
    touch "$PGDATA/recovery.signal"
    
    # Create or update recovery configuration
    cat > "$PGDATA/postgresql.auto.conf" << EOF
primary_conninfo = 'host=$PRIMARY_IP port=$PRIMARY_PORT user=$REPLICATION_USER password=$REPLICATION_PASSWORD'
restore_command = 'cp /var/lib/postgresql/data/pgdata/pg_wal/%f %p'
EOF
    echo "Mirror database initialized and configured for replication."
else
    echo "PGDATA is not empty. Skipping initialization."
fi

# Start PostgreSQL
exec postgres -c config_file=/etc/postgresql/postgresql.conf