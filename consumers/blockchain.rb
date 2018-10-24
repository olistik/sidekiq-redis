require 'redis'

trap(:INT) { puts; exit }

client = Redis.new

client.psubscribe('*blockchain*') do |on|
  on.pmessage do |*args|
    puts "[blockchain] received #{args.inspect}"
  end
end
