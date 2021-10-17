#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
cgi = CGI.new
name = cgi['family'] + cgi['given']
print cgi.header('text/plain; charset=utf-8')
print <<~HTML
  <html lang="ja">
    <body>
      <p>入力された氏名は#{name}です</p>
    </body>
  </html>
HTML
