require 'net/http'
require 'json'

class GamesController < ApplicationController
  def new
    # display grid + form
    my_letters = ('a'..'z').to_a
    @letters = Array.new(10) { my_letters.sample }
  end

  def score
    # retrieve word from submitted form + calculate score
    @guessedWord = params[:word]

    # to be able to use the @letters from new inside of form -> hidden_field_tag in new.html
    @letters = params[:letters].split(',')

    # 1. check if word can be built from grid (is a subset)
    letter_set = @letters.to_set
    guessed_word_set = @guessedWord.chars.to_set
    @result = guessed_word_set.subset?(letter_set) ? 'Valid' : 'Invalid'

    #2. check if valid english word

    url = URI.parse("https://wagon-dictionary.herokuapp.com/#{@guessedWord}")
    response = Net::HTTP.get_response(url)
    json = JSON.parse(response.body)
    @valid = json['found'] # Returns true if the word is found in the dictionary, false otherwise
  end
end
