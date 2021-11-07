# frozen_string_literal: true

require_relative '../wp_lib'

class Choice
  attr_reader :str

  DICT = {
    rock: 'グー',
    scissors: 'チョキ',
    paper: 'パー'
  }.freeze

  def initialize(choice)
    @str = choice
  end

  def ==(other)
    @str == other.str
  end

  def >(other)
    if (@str == 'rock' && other.str == 'scissors') ||
       (@str == 'scissors' && other.str == 'paper') ||
       (@str == 'paper' && other.str == 'rock')
      true
    else
      false
    end
  end

  # rubocop:disable Style/InverseMethods
  def <(other)
    !(self > other)
  end

  # rubocop:enable Style/InverseMethods

  def to_s
    DICT[str.intern]
  end
end

class Choice
  ROCK = Choice.new('rock')
  PAPER = Choice.new('paper')
  SCISSORS = Choice.new('scissors')
  CHOICES = {
    rock: ROCK,
    paper: PAPER,
    scissors: SCISSORS
  }.freeze

  def self.rand
    CHOICES.values.sample
  end
end

class Janken
  attr_reader :result

  def initialize(result_string = '0 0 0')
    @result = Result.new(result_string)
  end

  def game(user_choice)
    bot = Choice.rand
    case judge(user_choice, bot)
    when 'win'
      @result.win += 1
    when 'lose'
      @result.lose += 1
    when 'draw'
      @result.draw += 1
    end
    bot
  end

  def judge(x, y)
    if x == y
      'draw'
    elsif x > y
      'win'
    elsif x < y
      'lose'
    end
  end

  class Result
    attr_reader :string

    def initialize(result_string = '0 0 0')
      @string = result_string # win lose draw
    end

    def win
      @string.gsub(/(\d+)\s(\d+)\s(\d+)/) { Regexp.last_match(1) }.to_i
    end

    def win=(value)
      @string = @string.gsub(/(\d+)\s(\d+)\s(\d+)/) { [value.to_s, Regexp.last_match(2), Regexp.last_match(3)].join(' ') }
      win
    end

    def lose
      @string.gsub(/(\d+)\s(\d+)\s(\d+)/) { Regexp.last_match(2) }.to_i
    end

    def lose=(value)
      @string = @string.gsub(/(\d+)\s(\d+)\s(\d+)/) { [Regexp.last_match(1), value.to_s, Regexp.last_match(3)].join(' ') }
      lose
    end

    def draw
      @string.gsub(/(\d+)\s(\d+)\s(\d+)/) { Regexp.last_match(3) }.to_i
    end

    def draw=(value)
      @string = @string.gsub(/(\d+)\s(\d+)\s(\d+)/) { [Regexp.last_match(1), Regexp.last_match(2), value.to_s].join(' ') }
      draw
    end
  end
end
