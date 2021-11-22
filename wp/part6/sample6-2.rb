#!/usr/bin/env ruby
# encoding: utf-8
# print "Pattern: "
# pattern = STDIN.gets.chomp
# regexp = Regexp.new(pattern, false)
#regexp = Regexp.new(pattern, true)

# gets は実行時に引数として与えられたファイルから
# 一行読み込んだ文字列を返す組み込み関数。

pattern1 = /(SATOH|SAITOH)+/
pattern2 = /(ヒデユキ|ヒロユキ)+/
pattern3 = /^サ/
pattern4 = /^(ナ|サ).*ユキ+.*/
pattern5 = /(\S)\1+/
kadai3 = /^st.*(([a-z])(\2.*l$|ll$))/

while line = gets
  if kadai3 =~ line
    print line
  end
end


a = /([0-9])*(0|2|4|6|8)$/
b = /^[0-9]{3}-{0,1}[0-9]{4}$/