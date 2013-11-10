module Enumerable
  def find_map(ifnone = nil, &mapper)
    return to_enum(__callee__) unless mapper

    each do |item|
      result = mapper.call(item)
      return result if result
    end

    ifnone
  end
end
