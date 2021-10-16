# frozen_string_literal: true

BASE_URL = if ENV['RUBY_ENVIRONMENT'] == 'DEV'
             'http://localhost:3000/wp/'
           else
             'http://cgi.u.tsukuba.ac.jp/~s1711452/wp/'
           end
