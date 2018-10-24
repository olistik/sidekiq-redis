require 'securerandom'
require 'json'
require_relative 'batch'

URLS = []

class Entropy
  def initialize
    @start = Time.now.strftime('%Y%m%d%H%M%s')
  end

  def step(index:)
    uuid = SecureRandom.uuid
    batch_size = (rand * 9).to_i + 1
    batch = build_batch(size: batch_size)
    json = JSON.generate(batch)
    FileUtils.mkdir_p('json')
    File.write("json/#{@start}-#{index}.json", json)
  end
end
