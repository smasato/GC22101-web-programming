#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'csv'
require_relative './lib'

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
  <form action=#{url('bbs/update.rb')} method="post" name="bbs" onsubmit="return check()">
    <div>
      <label for="message">メッセージ: </label>
      <input type="text" name="message" id="message">
    </div>
    <div>
      <label for="name">お名前: </label>
      <!-- 結局、JavaScriptが無効になっていたら突破されるので  -->
      <!-- <input type="text" name="name" id="name" required> とするだけで事足りるはず  -->
      <input type="text" name="name" id="name">
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
  CSV.foreach(get_filepath('bbsdata.txt')) do |row|
    print("<p>#{cgi.escapeHTML(row[1])} : #{cgi.escapeHTML(row[2])}</p>")
  end
rescue Errno::ENOENT => e
  warn "Caught the exception: #{e}"
  print('<p>', 'エラーが発生しました。', e, '</p>')
end

print <<~HTML
  <script type="text/javascript">
    // ブラウザ上でチェックしてもJavaScriptが無効になっていたら(無効にされたら)意味がないのでサーバーサイドでもチェックするべき
    // 正規表現でXSSの対策をしても絶対に漏れるのでエスケープを前提にするべき
    // プログラマーの人生において正規表現でXSS対策をすることはあってはならない
    function check() {
      const name = document.forms["bbs"]["name"].value;
      const message = document.forms["bbs"]["message"].value;
      if ((name == null || name === "") || (message == null || message === "")) {
        alert("入力してください！");
        return false;
      } 

      const re = /.*<[^/].*>.*|(<.+>.*<\\/.+>.*)/;
      if (re.test(name)||re.test(message)){
        alert("HTMLの要素っぽいものは入力しないでください！");
        return false;
      }
      return true 
    }
    // このプログラムはbbs.rbを改良したとは言えない
  </script>
  </body>
  </html>
HTML
