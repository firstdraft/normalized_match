# frozen_string_literal: true

module NormalizedMatch
  module NormalizedMatchMatcher
    RSpec::Matchers.define :normalized_match do |expected|
  match do |actual|
    # Store the original values
    @original_expected = expected
    @original_actual = actual

    # Store normalized versions for cleaner diffs
    @expected = normalize_string(expected)
    @actual = normalize_string(actual)

    # Check if actual contains expected (substring match)
    @actual.include?(@expected)
  end

  failure_message do |actual|
    # Split into lines for side-by-side comparison
    orig_expected_lines = @original_expected.to_s.split("\n")
    orig_actual_lines = @original_actual.to_s.split("\n")
    norm_expected_lines = @expected.to_s.split("\n")
    norm_actual_lines = @actual.to_s.split("\n")

    # Check if normalization changed anything
    expected_changed = @original_expected.to_s != @expected.to_s
    actual_changed = @original_actual.to_s != @actual.to_s
    normalization_needed = expected_changed || actual_changed

    # Calculate column widths
    max_orig_expected = orig_expected_lines.map(&:length).max || 0
    max_orig_actual = orig_actual_lines.map(&:length).max || 0
    max_norm_expected = norm_expected_lines.map(&:length).max || 0
    max_norm_actual = norm_actual_lines.map(&:length).max || 0

    # Ensure minimum column width for headers
    expected_col_width = [max_orig_expected, max_norm_expected, "EXPECTED".length].max + 4  # 2 spaces padding each side
    actual_col_width = [max_orig_actual, max_norm_actual, "ACTUAL".length].max + 4

    # Calculate label column width (for "NORMALIZED" and "ORIGINAL")
    label_col_width = ["NORMALIZED".length, "ORIGINAL".length].max + 4  # padding

    # Build the side-by-side table components

    # Helper to pad and center text
    def center_pad(text, width)
      text = text.to_s
      padding = width - text.length
      left_pad = padding / 2
      right_pad = padding - left_pad
      " " * left_pad + text + " " * right_pad
    end

    # Helper to left-pad text with 2 spaces on each side
    def pad_line(text, width)
      "  #{text.to_s.ljust(width - 4)}  "
    end

    # Build header output
    header_output = []
    header_output << "Normalized match failed!"
    header_output << ""

    if normalization_needed
      header_output << "To make it easier to match the expected output,"
      header_output << "we are \"normalizing\" both the actual output and"
      header_output << "expected output in this test. That means we"
      header_output << "lowercased, removed punctuation, and compacted"
      header_output << "whitespace in both."
      header_output << ""
      header_output << "But the actual output still doesn't contain the"
      header_output << "expected output. Can you spot the difference?"
      header_output << ""
    else
      header_output << "The actual output doesn't contain the expected"
      header_output << "output. Can you spot the difference?"
      header_output << ""
    end

    # Helper to center label text (FUZZY/ORIGINAL) in first column
    def center_label(label, width, total_rows)
      middle_row = total_rows / 2
      (0...total_rows).map do |i|
        if i == middle_row
          label.center(width)
        else
          " " * width
        end
      end
    end

    # Build the table
    table_output = []

    if normalization_needed
      # Build two-section table with labels
      # Top border
      table_output << "╔" + "═" * label_col_width + "╦" + "═" * expected_col_width + "╦" + "═" * actual_col_width + "╗"

      # Header row
      table_output << "║" + " " * label_col_width + "║" + center_pad("EXPECTED", expected_col_width) + "║" + center_pad("ACTUAL", actual_col_width) + "║"

      # Header separator
      table_output << "╠" + "═" * label_col_width + "╬" + "═" * expected_col_width + "╬" + "═" * actual_col_width + "╣"

      # NORMALIZED section
      max_norm_lines = [norm_expected_lines.length, norm_actual_lines.length].max
      normalized_labels = center_label("NORMALIZED", label_col_width - 2, max_norm_lines)  # -2 for borders

      max_norm_lines.times do |i|
        expected_line = norm_expected_lines[i] || ""
        actual_line = norm_actual_lines[i] || ""
        label = normalized_labels[i]
        table_output << "║ #{label} ║" + pad_line(expected_line, expected_col_width) + "║" + pad_line(actual_line, actual_col_width) + "║"
      end

      # Middle separator
      table_output << "╠" + "═" * label_col_width + "╬" + "═" * expected_col_width + "╬" + "═" * actual_col_width + "╣"

      # ORIGINAL section
      max_lines = [orig_expected_lines.length, orig_actual_lines.length].max
      original_labels = center_label("ORIGINAL", label_col_width - 2, max_lines)  # -2 for borders

      max_lines.times do |i|
        expected_line = orig_expected_lines[i] || ""
        actual_line = orig_actual_lines[i] || ""
        label = original_labels[i]
        table_output << "║ #{label} ║" + pad_line(expected_line, expected_col_width) + "║" + pad_line(actual_line, actual_col_width) + "║"
      end

      # Bottom border
      table_output << "╚" + "═" * label_col_width + "╩" + "═" * expected_col_width + "╩" + "═" * actual_col_width + "╝"
    else
      # Build simple table without labels column
      # Top border
      table_output << "╔" + "═" * expected_col_width + "╦" + "═" * actual_col_width + "╗"

      # Header row
      table_output << "║" + center_pad("EXPECTED", expected_col_width) + "║" + center_pad("ACTUAL", actual_col_width) + "║"

      # Header separator
      table_output << "╠" + "═" * expected_col_width + "╬" + "═" * actual_col_width + "╣"

      # Data rows (using original since no normalization happened)
      max_lines = [orig_expected_lines.length, orig_actual_lines.length].max

      max_lines.times do |i|
        expected_line = orig_expected_lines[i] || ""
        actual_line = orig_actual_lines[i] || ""
        table_output << "║" + pad_line(expected_line, expected_col_width) + "║" + pad_line(actual_line, actual_col_width) + "║"
      end

      # Bottom border
      table_output << "╚" + "═" * expected_col_width + "╩" + "═" * actual_col_width + "╝"
    end

    # Combine all parts - header, then table (with extra newline between)
    # Add a trailing newline so there's a blank line before RSpec's diff (when it appears)
    message = header_output.join("\n") + "\n" + table_output.join("\n") + "\n"

    message
  end

  # These methods make the matcher work better with rspec-enriched_json
  attr_reader :expected, :actual

  # Provide access to original values if needed
  attr_reader :original_expected, :original_actual

  # Tell RSpec that expected and actual can be diffed
  def diffable?
    true
  end

  def normalize_string(str)
    str.to_s
      .gsub(/[^a-zA-Z0-9\s]/, "")  # Remove punctuation but keep all whitespace
      .downcase
      .split("\n")                  # Split by newlines to preserve them
      .map { |line| line.gsub(/\s+/, " ").strip }  # Normalize spaces within each line
      .reject(&:empty?)             # Remove empty lines
      .join("\n")                   # Rejoin with newlines
  end
    end
  end
end
