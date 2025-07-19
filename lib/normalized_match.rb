# frozen_string_literal: true

require "zeitwerk"
require "rspec/matchers"

Zeitwerk::Loader.new.then do |loader|
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module NormalizedMatch
  def self.loader registry = Zeitwerk::Registry
    @loader ||= registry.loaders.each.find { |loader| loader.tag == File.basename(__FILE__, ".rb") }
  end
end

# Include the matcher in RSpec when this gem is loaded
if defined?(RSpec)
  RSpec.configure do |config|
    config.include NormalizedMatch::NormalizedMatchMatcher
  end
end
