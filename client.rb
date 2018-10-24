require 'sidekiq'
require 'redis'

# We can pass the URL of the instance or even the Sentinel conf
redis_options = {}
pool = ConnectionPool.new { Redis.new(redis_options) } 
client = Sidekiq::Client.new(pool)

client.push(
  'queue' => 'default',
  'class' => 'Minion',
  'args' => [10, 'Kevin']
)

client.push(
  'queue' => 'default',
  'class' => 'Minion',
  'args' => [5, 'Bob']
)

