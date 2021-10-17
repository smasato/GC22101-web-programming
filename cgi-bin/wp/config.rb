# frozen_string_literal: true

IS_LOCAL = File.file?(File.expand_path('.local', __dir__))

BASE_URL = if IS_LOCAL
             'http://localhost:3000/wp/'
           else
             'http://cgi.u.tsukuba.ac.jp/~s1711452/wp/'
           end

BBS_DATA = if IS_LOCAL
             'bbsdata_local.txt'
           else
             'bbsdata.txt'
           end
