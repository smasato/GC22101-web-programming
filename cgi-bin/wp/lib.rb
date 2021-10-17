# frozen_string_literal: true

require_relative 'config'
require 'uri'
require 'date'
require 'csv'

def url(path)
  URI.join(BASE_URL, path)
end

def save_message(name, message)
  return false if name.empty? || message.empty?

  File.open(File.expand_path(BBS_DATA, __dir__), 'a') do |f|
    f.print([Time.now.to_s, name, message].to_csv)
  end

  true
rescue Errno::ENOENT => e
  warn "Caught the exception: #{e}"
  false
end
