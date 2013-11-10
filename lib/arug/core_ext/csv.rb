require 'csv'

class CSV
  class Row
    alias_method :each_pair, :each
  end
end
