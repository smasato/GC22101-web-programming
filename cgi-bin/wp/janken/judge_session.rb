#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'cgi/session'
require_relative './lib'

cgi = CGI.new
session = CGI::Session.new(cgi)

janken = if session['result']
           Janken.new(result_string: session['result'])
         else
           Janken.new
         end
choice = Choice::CHOICES[cgi['choice'].to_s.intern]
ret = janken.game(choice)

session['result'] = janken.result.string
session.close
print cgi.header('text/html; charset=utf-8')

print <<~HTML
  <!doctype html>
  <html lang="ja">
    <head>
      <meta charset="utf-8">
      <title>じゃんけんシステム session</title>
    </head>
    <body>
      <h1>勝負</h1>
      <div>
        <p>あなた:#{choice}</p>
        <p>コンピュータ:#{ret[0]}</p>
      </div>
      <p>#{ret[1]}</p>
      <p>現在の勝敗: #{janken.result}</p>
      <a href="#{url('janken/janken_session.rb')}">もう一度勝負する?</a>
    </body>
  </html>
HTML
