#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require_relative './lib'

enquete = load_enquete

cgi = CGI.new

print cgi.header('text/html; charset=utf-8')
print <<~HTML
  <!doctype html>

  <html lang="ja">
  <head>
    <meta charset="utf-8">
    <title>投票システム</title>
  </head>
  <body>
HTML

if enquete.nil?
  print('<p>アンケートを取得できませんでした。</p>')
else
  print <<~HTML
    <h1>#{cgi.escapeHTML(enquete[:title])}</h1>
        <form action="#{url('enquete/vote.rb')}" method="post">
  HTML
  enquete[:choices].each do |c|
    print <<~HTML
      <div>
        <input type="checkbox" name="choices" value="#{cgi.escapeHTML(c)}">
        <label for="choices">#{cgi.escapeHTML(c)}</label>
      </div>

    HTML
  end
  print <<~HTML
      <input type="hidden" name="hidden" value="hidden">
      <div>
        <input type="submit" value="送信">
      </div>
      <div>
        <input type="reset" value="クリア">
      </div>
    </form>
  HTML
end

print <<~HTML
    </body>
  </html>
HTML
