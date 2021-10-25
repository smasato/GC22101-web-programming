# frozen_string_literal: true

require_relative '../wp_lib'

def load_enquete
  question_title = String.new
  choices = []

  File.open(get_filepath(File.expand_path('question.txt', __dir__)), 'r:UTF-8') do |f|
    question_title = f.gets&.chomp&.strip
    choices = f.readlines.map { |l| l.chomp.strip }.select { |c| !c.empty? }
  end

  return unless question_title || choices

  { title: question_title, choices: choices }
end

def load_result
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
