# frozen_string_literal: true

require_relative '../wp_lib'
require 'sqlite3'
require 'csv'

# load_enquete  ->  hash
#
# @param [Integer] id
#
# @return [Hash{Symbol->String | Array}]
def load_enquete(id)
  question_title = String.new
  choices = []

  db = SQLite3::Database.new(get_filepath(File.expand_path('report1028.db', __dir__)), results_as_hash: true)
  db.prepare('select * from questions where id=? limit 1;').execute(id) do |rows|
    row = rows.first
    if row.nil?
      return nil
    else
      question_title = row['title']
      choices = CSV.parse(row['choices']).first
    end
  end

  return if question_title.empty? || choices.empty?

  { title: question_title, choices: choices }
end

# add_enquete(title, choices)
#
# @param [String] title
# @param [Array] choices
def add_enquete(title, choices)
  db = SQLite3::Database.new(get_filepath(File.expand_path('report1028.db', __dir__)), results_as_hash: true)
  db.transaction do
    db.prepare('insert into questions(title, choices) values(?, ?);').execute(title, choices.to_csv)
  end
end

# list_enquetes  ->  array
#
# @return [Array[Hash{Symbol->String | String}]]
def list_enquetes
  enquetes = []

  db = SQLite3::Database.new(get_filepath(File.expand_path('report1028.db', __dir__)), results_as_hash: true)
  db.prepare('select id, title from questions;').execute.each do |row|
    enquetes.push({ id: row['id'], title: row['title'] })
  end

  enquetes
end

# vote_enquete(question_id, choice) -> true or false
# @param [Integer] question_id
# @param [String] choice
#
# @return [Boolean]
def vote_enquete(question_id, choice)
  return false unless load_enquete(question_id)['choices'].include?(choice)

  db = SQLite3::Database.new(get_filepath(File.expand_path('report1028.db', __dir__)), results_as_hash: true)
  db.transaction do
    db.prepare('insert into votes(question_id, choice) values(?, ?);').execute(id, choice)
  end

  true
end
