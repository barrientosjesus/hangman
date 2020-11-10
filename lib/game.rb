require_relative './game_save'
require_relative './hangedman'
require 'yaml'

class Hangman
  include HangedMan
  include GameSave

  attr_accessor :guessed_correct, :guessed_incorrect,
                :game_word, :guesses_available

  def initialize
    @game_word = create_word
    @guessed_incorrect = []
    @guessed_correct = []
    @guesses_available = 6
  end

  def display_man
    guessed = @game_word.split('').map do |i|
      if @guessed_correct.include?(i)
        i
      else
        '_'
      end
    end
    case @guesses_available
    when 6
      failures0
    when 5
      failures1
    when 4
      failures2
    when 3
      failures3
    when 2
      failures4
    when 1
      failures5
    when 0
      failures6
    end
    puts guessed.join(' ').to_s
    puts (@guessed_incorrect.empty? ? 'No incorrect gueeses yet' : 'Incorrect: ' + @guessed_incorrect.join(',')).to_s
  end

  def create_word
    dictionary = File.readlines('../5desk.txt')
    word = ''
    word = dictionary[rand(dictionary.length)].chomp.downcase until word.length > 4 && word.length < 13
    word
  end

  def start
    puts '~~~~~~~~~~~~~~~~~~'
    puts 'New Game - Type 1:'
    puts 'Load Game- Type 2:'
    puts '~~~~~~~~~~~~~~~~~~'
    start_type = gets.chomp
    return load_game if start_type == '2'

    if start_type == '1'
      game_logic
    elsif start_type.to_i < 1 || start_type.to_i > 2
      puts '1 or 2, nothing else please! >=['
      sleep(1)
      Hangman.new.start
    else
      puts '!!Invalid input restarting game!!'
      Hangman.new.start
    end
  end

  def game_logic
    gameover = false
    until gameover
      display_man
      retrieve_guess
      gameover = if @guessed_correct.sort == @game_word.split('').sort
                   true
                 else
                   @guesses_available += 1
                 end
    end
    game_over
    sleep(2)
    puts ' '
    keep_playing
  end

  def game_over
    if @guessed_correct.sort == @game_word.split('').sort
      puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
      puts "!! #{@game_word} !!"
      puts 'Yay! You got the word correct!'
      puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
      puts ' '
    else
      sleep(1)
      puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
      puts "You've ran out of attempts :("
      puts 'Dude is dead'
      puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
      sleep(1)
      puts ''
      keep_playing
    end
  end

  def retrieve_guess
    puts "To save progress, enter 'save', otherwise begin guessing!"
    guess = gets.chomp.downcase
    while guess.to_s.length > 1
      return save_game(self) if guess == 'save'

      if @guessed_incorrect.include?(guess) || @guessed_correct.include?(guess)
        puts 'Seems to be something wrong with your input, please try again'
        guess = gets.chomp.downcase
      elsif guess.to_s.length > 1
        puts 'Seems to be something wrong with your input, please try again'
        guess = gets.chomp.downcase
      else
        guess
      end
    end
    if @game_word.include?(guess)
      @guessed_correct << guess
      puts 'You got it pal!'
    else
      @guessed_incorrect << guess
      puts "Sorry, bud that's incorrect"
      @guesses_available -= 1
    end
  end

  def keep_playing
    puts "If you'd like to play again, please type 1"
    play_again = gets.chomp
    if play_again.to_i == 1
      Hangman.new.start
    else
      abort("You didn't type 1, so I'll be shutting down now :(")
    end
  end
end

Hangman.new.start
