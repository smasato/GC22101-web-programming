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

print cgi.header('text/html; charset=utf-8')
print <<~HTML
  <!doctype html>

  <html lang="ja">
  <head>
    <meta charset="utf-8">
    <title>じゃんけんシステム session</title>
  </head>
  <body>
HTML

print <<~HTML
  <h1>じゃんけん</h1>
  <div><p>現在の勝敗: #{janken.result}</p></div>
  <span>今度の手は?</span>
      <form action="#{url('janken/judge_session.rb')}" method="post">
HTML
Choice::CHOICES.each_value do |c|
  print <<~HTML
    <div>
      <input type="radio" name="choice" value="#{cgi.escapeHTML(c.str)}" required>
      <label for="choice">#{cgi.escapeHTML(c.to_s)}</label>
    </div>
  HTML
end
print <<~HTML
      <div>
        <input type="submit" value="勝負！">
      </div>
    </form>
    <form action="#{url('janken/janken_session.rb')}" method="post">
      <input type="hidden" name="reset" value="reset">
      <input type="submit" value="勝敗をリセット">
    </form>
    </body>
  </html>
HTML
session.close
