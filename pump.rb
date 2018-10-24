require 'redis'
require 'sidekiq'
require 'json'

class Pump
  attr_reader :sidekiq_client, :redis_client

  def initialize
    redis_pool = ConnectionPool.new { Redis.new }
    @sidekiq_client = Sidekiq::Client.new(redis_pool)
    @redis_client = Redis.new
  end

  def perform
    Dir['json/*.json'].each do |filename|
      json = File.read(filename)
      items = JSON.parse(json)
      items.each do |item|
        deliver(item)
      end
    end
  end

  private

  def deliver(item)
    uuid = item['uuid']
    json = JSON.generate(item)
    redis_client.set("batch-#{uuid}", json)
    sidekiq_client.push(
      'queue' => 'batch-import',
      'class' => 'BatchImport',
      'args' => [uuid],
    )
  end
end

pump = Pump.new
pump.perform
