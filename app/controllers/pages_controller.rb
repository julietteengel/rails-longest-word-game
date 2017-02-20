require 'open-uri'
require 'json'


class PagesController < ApplicationController


  def game
    @grid = generate_grid((1..10).to_a.sample).join(',')
    # @grid = generate_grid(@grid_size)
    @time = Time.now
  end

  def score
    @grid = params[:grid].split(",")
    @answer = params[:guess]
    @start_time = params[:time]
    @end_time = Time.now
    @score = run_game(@answer, @grid, @start_time, @end_time)
  end



private


def generate_grid(grid_size)
  # TODO: generate random grid of letters
  Array.new(grid_size) {[*'A'..'Z'].sample}
  #create a new empty array and we tell it how many items to store inside it
end

def run_game(attempt, grid, start_time, end_time)
  api_url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=fd3178f8-afe3-4653-8722-23c2431c9c93&input=#{attempt}"
      json = open(api_url).read
      @data = JSON.parse(json)
      output =Hash.new

  if attempt_in_grid?(attempt, grid) == false
    output[:translation] = nil
    output[:time] = end_time - Time.parse(start_time)
    # il faut parser la string start_time. cest une string car cest un param. il faut la cnvertir en time object
    output[:score] = 0
    output[:message] = "not in the grid"

  elsif english_word?(attempt, grid) == false

    output[:translation] = nil
    output[:time] = end_time - Time.parse(start_time)
    output[:score] = 0
    output[:message] = "not an english word"

  else

    output[:translation] = data["output"][0]["output"]
    output[:time] = end_time - Time.parse(start_time)
    output[:score] = compute_score(attempt, time)
    output[:message] = "well done"
  end
end

def compute_score(attempt, time)
  final_score = (attempt.size)*((1-time)/60)
  # l = attempt.length
  # final_score = l - (end_time - start_time)
end


def attempt_in_grid?(attempt, grid)
attempt.split
attempt.split.all? {|letter| grid.include? (letter)}
# attempt.split.all? {|letter| grid.join.include? (letter)}
end


def english_word?(attempt, grid)
  if @data["outputs"][0]["output"] != attempt #mot anglais
    return true
  else
    return false
  end
end



end

