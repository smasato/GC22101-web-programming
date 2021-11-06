# frozen_string_literal: true

require_relative '../wp_lib'
require 'sqlite3'
require 'csv'

# load_enquete  ->  hash
#
# @param [Integer] id
#
# @return [Hash{Symbol->Integer | String | Array}]
def load_enquete(id)
  question_title = String.new
  choices = []

  SQLite3::Database.new(get_filepath(File.expand_path('report1028.db', __dir__)), results_as_hash: true) do |db|
    db.execute('select * from questions where id=? limit 1;', id) do |row|
      question_title = row["title"]
      choices = CSV.parse(row["choices"]).first
    end
  end

  return if question_title.empty? || choices.empty?

  { id: id, title: question_title, choices: choices }
end

# add_enquete(title, choices)
#
# @param [String] title
# @param [Array] choices
def add_enquete(title, choices)
  db = SQLite3::Database.new(get_filepath(File.expand_path('report1028.db', __dir__)), results_as_hash: true)
  db.transaction do
    db.prepare('insert into questions(title, choices) values(?, ?);').execute(title, choices.to_csv).close
  end
end

# list_enquetes  ->  array
#
# @return [Array[Hash{Symbol->String | String}]]
def list_enquetes
  enquetes = []

  SQLite3::Database.new(get_filepath(File.expand_path('report1028.db', __dir__)), results_as_hash: true) do |db|
    db.execute('select id, title from questions;').collect { |row| enquetes.push({ id: row['id'], title: row['title'] }) }
  end

  enquetes
end

# vote_enquete(question_id, choice) -> true or false
# @param [Integer] question_id
# @param [Array] choices
#
# @return [Boolean]
def vote_enquete(question_id, choices)
  enquete = load_enquete(question_id)

  return false if enquete.nil? || choices.empty?
  unless (enquete[:choices] & choices.uniq).count == choices.uniq.count
    return false
  end

  SQLite3::Database.new(get_filepath(File.expand_path('report1028.db', __dir__)), results_as_hash: true) do |db|
    db.transaction do
      choices.each do |choice|
        db.execute('insert into votes(question_id, choice) values(?, ?);', question_id, choice)
      end
    end
  end

  true
end

def load_votes(question_id)
  votes = []
  SQLite3::Database.new(get_filepath(File.expand_path('report1028.db', __dir__)), results_as_hash: true) do |db|
    db.execute('select choice from votes where question_id=?;', question_id).collect { |row| votes.push(row['choice']) }
  end
  result = Hash.new(0)
  votes.each { |v| result[v] += 1 }
  result
end
