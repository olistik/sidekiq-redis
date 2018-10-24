require_relative 'lib/entropy'
require 'fileutils'

BATCHES_SIZE = 100

FileUtils.rm_rf('json')
entropy = Entropy.new
puts ''
BATCHES_SIZE.times do |index|
  print '.'
  entropy.step(index: index)
end
puts "\nDone"
