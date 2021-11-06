#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require_relative './lib'

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

print('<h1>投票システム</h1>')

if cgi['id'].empty?
  enquetes = list_enquetes
  if list_enquetes.empty?
    print('<p>アンケートを取得できませんでした。</p>')
  else
    print("#{enquetes.count} のアンケートがあります。")
    print('<ul>')
    enquetes.each do |enquete|
      print <<~HTML
        <li>#{cgi.escapeHTML(enquete[:title])}</li>
        <ul>
           <li><a href="#{url("enquete2/enquete_form2.rb?id=#{enquete[:id]}")}">投票する</a></li>
           <li><a href="#{url("enquete2/view_result2.rb?id=#{enquete[:id]}")}">結果をみる</a></li>
        </ul>
      HTML
    end
    print('</ul>')

  end
else
  enquete = load_enquete(cgi['id'])
  print <<~HTML
    <h2>#{enquete[:title]}</h2>
    <form action="#{url('enquete2/vote2.rb')}" method="post">
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
      <input type="hidden" name="id" value="#{cgi['id']}">
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
