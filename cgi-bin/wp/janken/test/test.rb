# frozen_string_literal: true

require_relative '../lib'
require 'rspec/expectations'

include RSpec::Matchers

j = Janken.new
expect(j.judge(Choice::ROCK, Choice::SCISSORS)).to eq 'win'
expect(j.judge(Choice::PAPER, Choice::ROCK)).to eq 'win'
expect(j.judge(Choice::SCISSORS, Choice::PAPER)).to eq 'win'
expect(j.judge(Choice::ROCK, Choice::ROCK)).to eq 'draw'
expect(j.judge(Choice::PAPER, Choice::PAPER)).to eq 'draw'
expect(j.judge(Choice::SCISSORS, Choice::SCISSORS)).to eq 'draw'
expect(j.judge(Choice::ROCK, Choice::PAPER)).to eq 'lose'
expect(j.judge(Choice::PAPER, Choice::SCISSORS)).to eq 'lose'
expect(j.judge(Choice::SCISSORS, Choice::ROCK)).to eq 'lose'

expect(j.result.string).to match(/(\d+)\s(\d+)\s(\d+)/)
