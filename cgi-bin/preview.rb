# frozen_string_literal: true

require 'webrick'

WEBrick::HTTPServlet::FileHandler.add_handler('rb', WEBrick::HTTPServlet::CGIHandler)
WEBrick::HTTPServlet::FileHandler.add_handler('rhtml', WEBrick::HTTPServlet::ERBHandler)

s = WEBrick::HTTPServer.new(
  Port: 3000,
  DocumentRoot: File.join(Dir.pwd),
  DirectoryIndex: ['index.rb']
)
s.config[:MimeTypes]['rhtml'] = 'text/html'
trap('INT') { s.shutdown }
s.start
