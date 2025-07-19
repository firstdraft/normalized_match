# Normalized Match

A normalized string matcher for RSpec that ignores case, punctuation, and some whitespace differences.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "normalized_match"
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install normalized_match
```

## Usage

```ruby
require "normalized_match"

RSpec.describe "My test" do
  it "matches strings normalized" do
    actual = "Hello, World!"
    expected = "hello world"
    
    expect(actual).to normalized_match(expected)
  end
end
```

The `normalized_match` matcher normalizes both strings by:

- Converting to lowercase.
- Removing all punctuation.
- Collapsing internal whitespace (multiple spaces/tabs become single spaces).
- Preserving line breaks for multi-line comparisons.
- Stripping leading and trailing whitespace from lines.

When a match fails, it displays a helpful side-by-side comparison table showing both the normalized and original values.

## Using Heredocs

When testing output that contains multiple lines, you can use Ruby's squiggly heredoc (`<<~`) to maintain nice indentation in your test files while automatically stripping leading whitespace:

```ruby
RSpec.describe "Letter counter" do
  it "displays the letter count analysis" do
    # Your actual output might come from a method, script, etc.
    actual = run_codeblock(filename)
    
    # Use squiggly heredoc for expected output
    # This strips leading whitespace while preserving internal formatting
    expected = <<~EXPECTED
      Letter count:
      H: 1
      e: 1
      l: 3
      o: 2
      W: 1
      r: 1
      d: 1
    EXPECTED
    
    expect(actual).to normalized_match(expected)
  end
end
```

**Important:** The squiggly heredoc (`<<~`) technique is especially useful because newlines _within_ the expected content are significant to the matcher. In other words, the above test would not pass if it was written as:

```ruby
expected = "Letter count: H: 1 e: 1 l: 3 o: 2 W: 1 r: 1 d: 1"
```

And the actual output was:

```
Letter count:
H: 1
e: 1
l: 3
o: 2
W: 1
r: 1
d: 1
```

## Example Output

When strings don't match after normalization:

```
Normalized match failed!

To make it easier to match the expected output,
we are "normalizing" both the actual output and
expected output in this test. That means we
lowercased, removed punctuation, and compacted
whitespace in both.

But the actual output still doesn't contain the
expected output. Can you spot the difference?

╔════════════╦══════════════════╦══════════════════╗
║            ║     EXPECTED     ║      ACTUAL      ║
╠════════════╬══════════════════╬══════════════════╣
║ NORMALIZED ║  hello world     ║  goodbye world   ║
╠════════════╬══════════════════╬══════════════════╣
║  ORIGINAL  ║  Hello, World!   ║  Goodbye, World! ║
╚════════════╩══════════════════╩══════════════════╝
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/firstdraft/normalized_match.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
