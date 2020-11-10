# frozen_string_literal: true

require 'yaml'
require 'json'

module GameSave
  def save_game(game)
    puts 'Enter name of your save. (This will be what you type to load it)'
    saved_name = gets.chomp.downcase
    while File.exist?("./saved_games/#{saved_name}.yml")
      puts 'Sorry, that saved name already exists! Save with a different name please'
      saved_name = gets.chomp.downcase
    end
    data_yml = YAML.dump(game)
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    File.open("./saved_games/#{saved_name}.yml", 'w') { |f| f.write data_yml }
    abort("Your game has been saved! Load with: #{saved_name}")
  end

  def load_game
    unless Dir.exist?('saved_games')
      puts 'No saves found, sorry!'
      puts ' '
      sleep(3)
      Hangman.new.start
    end
    puts 'Input your save name:'
    load_save = gets.chomp
    unless File.exist?("./saved_games/#{load_save}.yml")
      puts "Sorry your save isn't there"
      puts ' '
      sleep(3)
      Hangman.new.start
    end
    loading_game = load_saved_game(load_save)
    puts loading_game
    puts "Loading #{load_save}"
    sleep(1)
    puts '~~~'
    sleep(1)
    puts '~~~'
    loading_game
  end

  def load_saved_game(saveload)
    data = YAML.load(File.read("./saved_games/#{saveload}.yml"))
    puts data
    @game_word = data[0]
    @guessed_incorrect = data[1]
    @guessed_correct = data[2]
    @guesses_available = data[3]
    puts @game_word, @guesses_available, @guessed_correct, @guessed_incorrect
  end
end
