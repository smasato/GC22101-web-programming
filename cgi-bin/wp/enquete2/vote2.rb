#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'csv'
require_relative './lib'

cgi = CGI.new

message = if cgi.request_method == 'POST' && vote_enquete(cgi['id'], cgi.params['choices'])
            '投票ありがとうございます。'
          else
            '投票の保存に失敗しました。'
          end

print cgi.header('text/html; charset=utf-8')
print <<~HTML
  <!doctype html>

  <html lang="ja">
    <head>
      <meta charset="utf-8">
      <title>投票システム</title>
    </head>
    <body>
      <p>#{message}</p>
      <a href="#{url("enquete2/view_result2.rb?id=#{cgi['id']}")}">投票結果を見る</a>
      <a href="#{url('enquete2/enquete_form2.rb')}">投票に戻る</a>
HTML

print <<~HTML
    </body>
  </html>
HTML
