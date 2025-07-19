# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "normalized_match"
  spec.version = "0.0.0"
  spec.authors = ["Raghu Betina"]
  spec.email = ["raghu@firstdraft.com"]
  spec.homepage = "https://github.com/firstdraft/normalized_match"
  spec.summary = "A normalized string matcher for RSpec that ignores case, punctuation, and whitespace differences"
  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/firstdraft/normalized_match/issues",
    "changelog_uri" => "https://github.com/firstdraft/normalized_match/blob/main/CHANGELOG.md",
    "homepage_uri" => "https://github.com/firstdraft/normalized_match",
    "label" => "Normalized Match",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/firstdraft/normalized_match"
  }

  # spec.signing_key = Gem.default_key_path
  # spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = ">= 3.0"
  spec.add_dependency "rspec", "~> 3.0"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
