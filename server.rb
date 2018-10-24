require 'sidekiq'
require 'redis'

class BatchImport
  include Sidekiq::Worker

  def perform(uuid)
    start_time = Time.now.to_i
    puts "BatchImport[uuid:#{uuid}]: START"
    client = Redis.new
    json = client.get("batch-#{uuid}")
    data = JSON.parse(json)
    puts "BatchImport[uuid:#{uuid}]: {action:#{data['type']}}"

    # TODO: apply a transformation to the data
    # TODO: publish the result of the transformation to a list of topics
    # sleep (rand * 5).to_i # use this to simulate variable heavy computation

    host = URI.parse(data['payload']['url']).host
    topic = "#{data['type']}-#{host}"
    receivers = client.publish(topic, json)

    puts "BatchImport[uuid:#{uuid}]: published on topic #{topic}, {receivers:#{receivers}}"

    duration = Time.now.to_i - start_time
    puts "BatchImport[uuid:#{uuid}]: END"
    client.del("batch-#{uuid}")
  end
end
