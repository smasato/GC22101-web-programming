# frozen_string_literal: true

require_relative '../wp_lib'

def get_enquete
  question_title = ''
  choices = []

  File.open(get_filepath(File.expand_path('question.txt', __dir__)), 'r:UTF-8') do |f|
    question_title = f.gets&.chomp&.strip
    choices = f.readlines.map { |l| l.to_s.chomp.strip }
  end

  if question_title && !choices.empty?
    { title: question_title, choices: choices }
  end
end

def get_result
  result = Hash.new(0)
  File.open(get_filepath(File.expand_path('vote_result.txt', __dir__)), 'r:UTF-8') do |f|
    f.each_line do |l|
      result[l.to_s.strip.chomp] += 1
    end
  end
  result
end

def vote(choices)
  return false if choices.empty?

  File.open(get_filepath(File.expand_path('vote_result.txt', __dir__)), 'a') do |f|
    f.flock(File::LOCK_EX)
    f.print(choices.join("\n"), "\n")
  end

  true
rescue Errno::ENOENT => e
  warn "Caught the exception: #{e}"
  false
end
