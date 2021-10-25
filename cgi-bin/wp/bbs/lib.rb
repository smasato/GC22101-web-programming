# frozen_string_literal: true

require_relative '../wp_lib'
require 'date'
require 'csv'

def save_message(name, message)
  return false if name.empty? || message.empty?

  File.open(get_filepath(File.expand_path('bbsdata.txt', __dir__)), 'a') do |f|
    f.print([Time.now.to_s, name, message].to_csv)
  end

  true
rescue Errno::ENOENT => e
  warn "Caught the exception: #{e}"
  false
end
