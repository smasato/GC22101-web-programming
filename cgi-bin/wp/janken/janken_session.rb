#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'cgi/session'
require_relative './lib'

cgi = CGI.new
session = CGI::Session.new(cgi)

if cgi.request_method == 'POST' && cgi['reset'] == 'reset'
  session.delete
  session = CGI::Session.new(cgi)
end

janken = if session['result']
           Janken.new(result_string: session['result'])
         else
           Janken.new
         end
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
      <h1>じゃんけん</h1>
      <p>現在の勝敗: #{janken.result}</p>
      <form action="#{url('janken/judge_session.rb')}" method="post">
        <p>今度の手は?
HTML
Choice::CHOICES.each_value do |c|
  print <<~HTML
    <span>
      <input type="radio" name="choice" value="#{cgi.escapeHTML(c.str)}" required>
      <label for="choice">#{cgi.escapeHTML(c.to_s)}</label>
    </span>
  HTML
end

print <<~HTML
        </p>
        <input type="submit" value="勝負！">
      </form>
      <form action="#{url('janken/janken_session.rb')}" method="post">
        <p>
          <input type="hidden" name="reset" value="reset">
          <input type="submit" value="勝敗をリセット">
        </p>
      </form>
    </body>
  </html>
HTML
