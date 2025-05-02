# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.4.1"

# Authentication
gem "devise"
gem "devise-jwt"
gem "rack-cors"

# Background Jobs
gem "thruster", require: false

# Deployment
gem "kamal", require: false

# Framework
gem "rails", "~> 8.0.2"

# MongoDB
gem "mongoid"

# Performance
gem "bootsnap", require: false

# Serialization
gem "blueprinter"

# Server
gem "puma", ">= 5.0"

# Timezone
gem "tzinfo-data", platforms: %i[windows jruby]

# Twilio API
gem "twilio-ruby"

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
  gem "pry"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "simplecov"
  gem "simplecov-json"
  gem "vcr"
end

# Test Gems
group :test do
  gem "database_cleaner-mongoid"
  gem "mongoid-rspec"
  gem "rspec-github", require: false
  gem "webmock"
end
