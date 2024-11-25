require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def run_game(attempt, grid)
    # TODO: runs the game and return detailed hash of result (with `:score`, `:message` and `:time` keys)
    url = "https://dictionary.lewagon.com/#{attempt}"
    word_check = JSON.parse(URI.parse(url).read)
    # raise
    if word_check["found"] == true
      check = true
      attempt.upcase.chars.tally.each do |key, value|
        if grid.tally.include?(key)
          check = check && false if grid.tally.fetch(key) < value
        else
          check = false
        end
      end
      if check == true
        message = "well done ! #{attempt} is valid !"
      else
        message = "Sorry ! your word is not in the grid."
      end
    else
      message = "Your word is not an english word."
    end
   return message
  end

  def score
    grid = params["letters"].gsub(/\s+/, "").chars
    # raise
    @score = run_game(params["word"], grid)
  end
end
