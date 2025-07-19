# frozen_string_literal: true

require "spec_helper"

# Mock methods for the example
def replace_read_only_value(variable_name:, new_value:)
  # Mock implementation
end

def run_codeblock
  # This would be the actual output from running the code
  # For testing purposes, we'll return different variations
end

RSpec.describe "normalized_match matcher" do
  describe "Letter count example" do
    it "should match standard output format" do
      output = <<~OUTPUT
        l appears 1 times
        o appears 2 times
        o appears 2 times
        p appears 1 times
      OUTPUT

      expected = <<~EXPECTED
        l appears 1 times
        o appears 2 times
        o appears 2 times
        p appears 1 times
      EXPECTED

      expect(output).to normalized_match(expected)
    end

    it "should match output with quotes (like pp output)" do
      output = <<~OUTPUT
        "l appears 1 times"
        "o appears 2 times"
        "o appears 2 times"
        "p appears 1 times"
      OUTPUT

      expected = <<~EXPECTED
        l appears 1 times
        o appears 2 times
        o appears 2 times
        p appears 1 times
      EXPECTED

      expect(output).to normalized_match(expected)
    end

    it "should match with different casing and extra whitespace" do
      output = <<~OUTPUT
        "L appears 1 times"


        "O appears 2 times"


                "O appears 2 times"
        "P appears 1 times"
      OUTPUT

      expected = <<~EXPECTED
        l appears 1 times
        o appears 2 times
        o appears 2 times
        p appears 1 times
      EXPECTED

      expect(output).to normalized_match(expected)
    end

    it "should match with mixed punctuation and formatting" do
      output = ">>> L appears 1 times!!! <<< O appears 2 times... O appears 2 times??? P appears 1 times."

      expected = "l appears 1 times o appears 2 times o appears 2 times p appears 1 times"

      expect(output).to normalized_match(expected)
    end
  end

  describe "Edge cases" do
    it "should handle empty strings" do
      expect("").to normalized_match("")
    end

    it "should handle strings with only punctuation" do
      expect("!!!...???").to normalized_match("@#$%^&*()")
    end

    it "should handle numbers correctly" do
      expect("The answer is 42!").to normalized_match("THE ANSWER IS 42")
    end

    it "should fail when content doesn't match" do
      expect("hello world").not_to normalized_match("goodbye world")
    end

    it "should fail when order is different" do
      expect("a b c").not_to normalized_match("c b a")
    end
  end

  describe "Substring matching" do
    it "should match when expected is contained in actual" do
      expect("1   23   4").to normalized_match("23")
    end

    it "should match with extra content before and after" do
      expect("prefix: The answer is 42! suffix").to normalized_match("answer is 42")
    end

    it "should match multiline content that contains expected" do
      output = <<~OUTPUT
        Starting process...
        l appears 1 times
        o appears 2 times
        Process complete.
      OUTPUT

      expected = <<~EXPECTED
        l appears 1 times
        o appears 2 times
      EXPECTED

      expect(output).to normalized_match(expected)
    end

    it "should still fail when expected is not contained" do
      expect("hello world").not_to normalized_match("goodbye")
    end

    it "should match partial content with punctuation differences" do
      expect("Error: User not found!!!").to normalized_match("user not found")
    end
  end

  describe "Failure message formatting" do
    it "displays a helpful table when normalization is needed" do
      expect {
        expect("Hello, World!").to normalized_match("goodbye world")
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError) do |error|
        expect(error.message).to include("Normalized match failed!")
        expect(error.message).to include("To make it easier to match the expected")
        expect(error.message).to include("NORMALIZED")
        expect(error.message).to include("ORIGINAL")
        expect(error.message).to include("hello world")
        expect(error.message).to include("Hello, World!")
      end
    end

    it "displays simple table when no normalization is needed" do
      expect {
        expect("hello").to normalized_match("goodbye")
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError) do |error|
        expect(error.message).to include("The actual output doesn't contain the expected")
        expect(error.message).not_to include("NORMALIZED")
        expect(error.message).to include("EXPECTED")
        expect(error.message).to include("ACTUAL")
      end
    end
  end

  describe "Integration with rspec-enriched_json" do
    it "provides expected and actual methods" do
      matcher = normalized_match("test")
      matcher.matches?("actual test")
      expect(matcher.expected).to eq("test")
      expect(matcher.actual).to eq("actual test")
    end

    it "provides original_expected and original_actual methods" do
      matcher = normalized_match("Test!")
      matcher.matches?("ACTUAL TEST!")
      expect(matcher.original_expected).to eq("Test!")
      expect(matcher.original_actual).to eq("ACTUAL TEST!")
    end

    it "responds to diffable?" do
      matcher = normalized_match("test")
      expect(matcher.diffable?).to eq(true)
    end
  end
end