# Normalized Match

A normalized string matcher for RSpec that ignores case, punctuation, and whitespace differences.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'normalized_match'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install normalized_match

## Usage

```ruby
require 'normalized_match'

RSpec.describe "My test" do
  it "matches strings normalized" do
    actual = "Hello, World!"
    expected = "hello world"
    
    expect(actual).to normalized_match(expected)
  end
end
```

The `normalized_match` matcher normalizes both strings by:

- Converting to lowercase
- Removing all punctuation
- Normalizing whitespace (multiple spaces become single spaces)
- Preserving line breaks for multi-line comparisons

When a match fails, it displays a helpful side-by-side comparison table showing both the normalized and original values.

## Example Output

When strings don't match after normalization:

```
Normalized match failed!

To make it easier to match the expected output,
we are using normalized matching in this test. That means
we took your actual output and the expected
output and "normalized" them both — downcased,
removed punctuation, and compacted whitespace.

Unfortunately, your actual output still doesn't
match the expected output. Can you spot the
difference?

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
