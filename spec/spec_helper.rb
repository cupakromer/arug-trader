if ENV['COVERALLS']
  require 'coveralls'
  Coveralls.wear_merged!
end

require 'pathname'

module RSpec
  def self.root
    @rspec_root ||= Pathname.new(__dir__)
  end
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[RSpec.root.join("support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Helpers::Wrapping

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  # Add some semantic aliases for including shared examples
  config.alias_it_should_behave_like_to :has_behavior
  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior:'
end
