#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'csv'
require_relative '../lib'

cgi = CGI.new

print cgi.header('text/html; charset=utf-8')
print <<~HTML
  <!doctype html>

  <html lang="ja">
  <head>
    <meta charset="utf-8">
    <title>1行掲示板</title>
  </head>
  <body>
  <p>メッセージをどうぞ。</p>
  <form action=#{url('bbs/update.rb')} method="post">
    <div>
      <label for="message">メッセージ: </label>
      <input type="text" name="message" id="message" required>
    </div>
    <div>
      <label for="name">お名前: </label>
      <input type="text" name="name" id="name" required>
    </div>
    <div>
      <input type="submit" value="書き込む">
    </div>
    <div>
      <input type="reset" value="クリア">
    </div>
  </form>
HTML

begin
  CSV.foreach(BBS_DATA) do |row|
    print("<p>#{cgi.escapeHTML(row[1])} : #{cgi.escapeHTML(row[2])}</p>")
  end
rescue Errno::ENOENT => e
  warn "Caught the exception: #{e}"
  print('<p>', 'エラーが発生しました。', e, '</p>')
end

print <<~HTML
  </body>
  </html>
HTML
