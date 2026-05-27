# Azure Cache for Redis (source)
OLD_HOST="test"
OLD_KEY="test"

# Azure Managed Redis (destination)
NEW_HOST="test"
NEW_KEY="test"

# Run the copy
redis-cli -h $OLD_HOST -p 6380 --tls -a $OLD_KEY \
  --scan --pattern '*' | while read key; do
    redis-cli -h $OLD_HOST -p 6380 --tls -a $OLD_KEY \
      DUMP "$key" | redis-cli -h $NEW_HOST -p 10000 \
      --tls --user default -a $NEW_KEY \
      -x RESTORE "$key" 0
done