# frozen_string_literal: true

require 'webrick'

module WEBrick
  module HTTPServlet
    FileHandler.add_handler('rb', CGIHandler)
    FileHandler.add_handler('rhtml', CGIHandler)
  end
end

s = WEBrick::HTTPServer.new(
  Port: 3000,
  DocumentRoot: File.join(Dir.pwd),
  DirectoryIndex: ['index.rb']
)
trap('INT') { s.shutdown }
s.start
