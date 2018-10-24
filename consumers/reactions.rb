require 'redis'

trap(:INT) { puts; exit }

client = Redis.new

client.psubscribe('*reaction*') do |on|
  on.pmessage do |*args|
    puts "[reaction] received #{args.inspect}"
  end
end
