#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require_relative './lib'

cgi = CGI.new
cookies = cgi.cookies

if (cgi.request_method == 'POST' && cgi['reset'] == 'reset') || !cookies.key?('result')
  result = CGI::Cookie.new('result', '0_0_0')
  print cgi.header({
                     'type' => 'text/html',
                     'charset' => 'utf-8',
                     'cookie' => [result]
                   })
else
  result = cookies['result']
  print cgi.header({
                     'type' => 'text/html',
                     'charset' => 'utf-8'
                   })
end
janken = Janken.new(result_string: result.value[0].gsub(/_/, ' '))

print <<~HTML
  <!doctype html>
  <html lang="ja">
    <head>
      <meta charset="utf-8">
      <title>じゃんけんシステム cookie</title>
    </head>
    <body>
      <h1>じゃんけん</h1>
      <p>現在の勝敗: #{janken.result}</p>
      <form action="#{url('janken/judge_cookie.rb')}" method="post">
        <p>今度の手は?
HTML

Choice::CHOICES.each_value do |c|
  print <<~HTML
    <span>
      <input type="radio" name="choice" value="#{c.str}" required>
      <label for="choice">#{c}</label>
    </span>
  HTML
end

print <<~HTML
        </p>
        <input type="submit" value="勝負！">
      </form>
      <form action="#{url('janken/janken_cookie.rb')}" method="post">
        <p>
          <input type="hidden" name="reset" value="reset">
          <input type="submit" value="勝敗をリセット">
        </p>
      </form>
    </body>
  </html>
HTML
