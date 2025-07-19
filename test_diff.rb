require 'rspec'
require_relative 'lib/normalized_match'

RSpec.describe "Diff display" do
  it "shows diff when strings don't match" do
    actual = "Line 1: Hello\nLine 2: Universe\nLine 3: Testing"
    expected = "Line 1: Hello\nLine 2: World\nLine 3: Testing"
    
    expect(actual).to normalized_match(expected)
  end
end