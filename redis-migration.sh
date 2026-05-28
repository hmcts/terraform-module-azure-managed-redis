#!/bin/sh
set -e

echo "Starting Redis migration..."
echo "Source: $OLD_HOST:6380"
echo "Target: $NEW_HOST:10000"

# Run the copy
redis-cli -h $OLD_HOST -p 6380 --tls -a $OLD_KEY \
  --scan --pattern '*' | while read key; do
    echo "Migrating: $key"
    redis-cli -h $OLD_HOST -p 6380 --tls -a $OLD_KEY \
      DUMP "$key" | redis-cli -h $NEW_HOST -p 10000 \
      --tls --user default -a $NEW_KEY \
      -x RESTORE "$key" 0 REPLACE
done

echo "Migration complete!"