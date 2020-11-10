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
    data_yml = JSON.dump(game)
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
    puts loading_game[3]
    puts '--------------------'
    puts "Loading #{load_save}"
    puts ' - - - - - - - - - '
    sleep(1)
    puts 'Deleting Save File'
    puts '------------------'
    File.delete("./saved_games/#{load_save}.yml")
    sleep(1)
    puts 'Game starting...'
    sleep(1)
    puts ' '
    puts ' '
    game_logic(loading_game[0],loading_game[1],loading_game[2],loading_game[3])
  end

  def load_saved_game(saveload)
    data = YAML.load(File.read("./saved_games/#{saveload}.yml"))
    @game_word = data['game_word']
    @guessed_incorrect = data['guessed_incorrect']
    @guessed_correct = data['guessed_correct']
    @guesses_available = data['guesses_available']
    [@game_word, @guessed_incorrect, @guessed_correct, @guesses_available]
  end
end
