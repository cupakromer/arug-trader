require 'rspec/expectations/errors'

module RSpec::Expectations
  PreconditionNotMetError = Class.new(RSpec::Expectations::ExpectationNotMetError) do
    def message
      "Precondition Failed: #{super}"
    end
  end
end

def precondition
  yield if block_given?
rescue => e
  raise RSpec::Expectations::PreconditionNotMetError.new(e)
end
