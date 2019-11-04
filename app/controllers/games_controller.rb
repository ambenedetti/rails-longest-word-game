require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def compare_words
    @letter_array = params[:letters].split(' ')
    @word_array = params[:word].split('')
    @results = []
    @word_array.each do |let|
      if @letter_array.include?(let)
        @results << let
        @letter_array.delete(let)
      end
    end
  end

  def word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    @answer = json['found']
  end

  def final_result
    if @answer == true && @results.length == @word_array.length
      @reply = "yes, that's a word"
    elsif @answer == true && @results.length != @word_array.length
      @reply = "sorry, you can't build that word"
    else
      @reply = 'try again'
    end
  end

  def score
    compare_words
    word?(@results.join)
    final_result
  end
end
