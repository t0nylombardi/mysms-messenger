# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.4.1"

gem "rails", "~> 8.0.2"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

# Development Gems
group :development do
  gem "annotaterb"
  gem "brakeman"
  gem "bundle-audit"
  gem "guard-rspec", require: false
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "rubocop-thread_safety"
  gem "ruby-lsp-rspec", require: false
  gem "ruby_audit"
  gem "standard"
  gem "standard-rails"
end

# Development and Test Gems
group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "factory_bot_rails"
  gem "faker"
  gem "irb"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "simplecov"
  gem "simplecov-json"
  gem "vcr"
end

# Test Gems
group :test do
  gem "mongoid-rspec"
  gem "rspec-github", require: false
  gem "webmock"
end
