#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require_relative './lib'

cgi = CGI.new

enquete = load_enquete(cgi['id'])

print cgi.header('text/html; charset=utf-8')
print <<~HTML
  <!doctype html>

  <html lang="ja">
  <head>
    <meta charset="utf-8">
    <title>投票結果</title>
  </head>
  <body>
  <h1>投票結果</h1>
  <h2>#{cgi.escapeHTML(enquete[:title])}</h2>
HTML

result = load_votes(cgi['id'])

print('<p>投票数 = ', result.values.inject(:+), '</p>')
print '<ul>'
(result).each do |k, v|
  print "<li>#{cgi.escapeHTML(k)}: #{v}</li>"
end
print '</ul>'

print <<~HTML
  <a href="#{url('enquete2/enquete_form2.rb')}">投票に戻る</a>
  </body>
  </html>
HTML
