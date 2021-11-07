#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'cgi/session'
require_relative './lib'

cgi = CGI.new
session = CGI::Session.new(cgi)
janken = Janken.new(session['result'] || '0 0 0')

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
  <div><p>現在の勝敗: #{janken.result.win}勝　#{janken.result.lose}敗 #{janken.result.lose}分け</p></div>
  <span>今度の手は?</span>
      <form action="#{url('janken/judge_session.rb')}" method="post">
HTML
Choice::CHOICES.each do |c|
  print <<~HTML
    <div>
      <input type="radio" name="choices" value="#{cgi.escapeHTML(c.str)}" required>
      <label for="choices">#{cgi.escapeHTML(c.str)}</label>
    </div>
  HTML
end
print <<~HTML
      <input type="hidden" name="hidden" value="hidden">
      <div>
        <input type="submit" value="勝負！">
      </div>
    </form>
    <form action="#{url('janken/judge_session.rb')}" method="post">
      <input type="hidden" name="reset" value="reset">
      <input type="submit" value="勝敗をリセット">
    </form>
    </body>
  </html>
HTML
session.close
