module LetPreloadable
  def preload(*names)
    before do
      names.each { |name| __send__ name }
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend LetPreloadable
end
