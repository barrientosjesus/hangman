require_relative './game_save'
require_relative './hangedman'
require 'yaml'
require 'json'

class Hangman
  include HangedMan
  include GameSave

  attr_accessor :guessed_correct, :guessed_incorrect,
                :game_word, :guesses_available, :varhash

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
    puts (@guessed_incorrect.empty? ? 'No incorrect guesses yet' : 'Incorrect: ' + @guessed_incorrect.join(',')).to_s
  end

  def create_word
    dictionary = File.readlines('5desk.txt')
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
      game_logic(@game_word, @guessed_incorrect, @guessed_correct, @guesses_available)
    elsif start_type.to_i < 1 || start_type.to_i > 2
      puts '1 or 2, nothing else please! >=['
      sleep(1)
      Hangman.new.start
    else
      puts '!!Invalid input restarting game!!'
      Hangman.new.start
    end
  end

  def game_logic(word,incorrect,correct,guesses)
    @game_word = word
    @guessed_incorrect = incorrect
    @guessed_correct = correct
    @guesses_available = guesses
    gameover = false
    until gameover
      @varhash = {"game_word" => @game_word, "guessed_incorrect" => @guessed_incorrect,
        "guessed_correct" => @guessed_correct, "guesses_available" => @guesses_available}

      display_man
      retrieve_guess

      if @guessed_correct.sort == @game_word.split('').sort
        gameover = true
      elsif @guesses_available == 0
        gameover = true
      else
        gameover = false
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
    return save_game(@varhash) if guess == 'save'

    while guess.to_s.length > 1
        puts 'Seems to be something wrong with your input, please try again'
        guess = gets.chomp.downcase
        return save_game(@varhash) if guess == 'save'
    end

    while @guessed_incorrect.include?(guess) || @guessed_correct.include?(guess)
      puts 'Seems to be something wrong with your input, please try again'
      guess = gets.chomp.downcase
      return save_game(@varhash) if guess == 'save'
    end

    if @game_word.include?(guess)
      @game_word.count(guess).times do |e|
        @guessed_correct << guess
      end
      puts 'You got it pal!'
      puts ' '
    else
      @guessed_incorrect << guess
      puts "Sorry, bud that's incorrect"
      @guesses_available -= 1
    end
  end

  def keep_playing
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    puts "If you'd like to play again, please type 1"
    puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    play_again = gets.chomp.to_i
    if play_again == 1
      Hangman.new.start
    else
      abort("You didn't type 1, so I'll be shutting down now :(")
    end
  end
end

Hangman.new.start
