#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'csv'
require_relative 'lib'

cgi = CGI.new

message = if save_message(cgi['name'], cgi['message'])
            '書き込みありがとうございます。'
          else
            '書き込みの保存に失敗しました。'
          end

print cgi.header('text/html; charset=utf-8')
print <<~HTML
  <!doctype html>

  <html lang="ja">
    <head>
      <meta charset="utf-8">
      <title>1行掲示板</title>
    </head>
    <body>
      <p>#{message}</p>
      <a href="#{url('bbs.rb')}">1行掲示板に戻る</a>
HTML

print <<~HTML
    </body>
  </html>
HTML
