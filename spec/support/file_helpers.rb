require 'tempfile'

module Helpers
  module Wrapping
    module_function
    def with_temp_file(file_name, data = nil)
      ext  = File.extname(file_name)
      base = File.basename(file_name, ext)

      file = Tempfile.new([ base, ext ])
      file.write(data)
      file.close

      yield file.path

    ensure
       file.close
       file.unlink
    end
  end
end
