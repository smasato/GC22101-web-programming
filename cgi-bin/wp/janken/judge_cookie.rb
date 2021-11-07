#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require_relative './lib'

cgi = CGI.new
cookies = cgi.cookies

result = if cookies.key?('result')
           cookies['result']
         else
           CGI::Cookie.new('result', '0_0_0')
         end

choice = Choice::CHOICES[cgi['choice'].to_s.intern]
janken = Janken.new(result_string: result.value[0].gsub(/_/, ' '))
ret = janken.game(choice)

result.value = janken.result.string.gsub(/ /, '_')
print cgi.header({
                   'type' => 'text/html',
                   'charset' => 'utf-8',
                   'cookie' => [result]
                 })

print <<~HTML
  <!doctype html>
  <html lang="ja">
    <head>
      <meta charset="utf-8">
      <title>じゃんけんシステム cookie</title>
    </head>
    <body>
      <h1>勝負</h1>
      <div>
        <p>あなた:#{choice}</p>
        <p>コンピュータ:#{ret[0]}</p>
      </div>
      <p>#{ret[1]}</p>
      <p>現在の勝敗: #{janken.result}</p>
      <a href="#{url('janken/janken_cookie.rb')}">もう一度勝負する?</a>
    </body>
  </html>
HTML
