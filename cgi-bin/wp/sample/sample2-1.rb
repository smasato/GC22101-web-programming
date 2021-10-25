#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
cgi = CGI.new
print cgi.header('text/plain; charset=utf-8')
print Time.new.to_s
print RUBY_VERSION
