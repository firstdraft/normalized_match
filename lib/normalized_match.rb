# frozen_string_literal: true

require "rspec/matchers"
require_relative "normalized_match/normalized_match_matcher"

# Main namespace.
module NormalizedMatch
end

# Include the matcher in RSpec when this gem is loaded
if defined?(RSpec)
  RSpec.configure do |config|
    config.include NormalizedMatch::NormalizedMatchMatcher
  end
end
