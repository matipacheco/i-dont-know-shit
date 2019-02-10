require_relative 'character'
require_relative '../mongo_connection'

# Game class. It represents the fight between two Character's
# The fight logic isnt 100% correct, but you get the idea of it :smirk:
class Battle
  attr_accessor :fighter1, :fighter2, :game_over, :winner

  def initialize(fighters_json = nil)
    fighters = fighters_json.nil? ? fighters_from_collection : fighters_from_json(fighters_json)

    @game_over = !fighters.map(&:alive?).all?
    @fighter1, @fighter2 = fighters.sort_by(&:dice_roll).reverse
  end

  def fighters_from_json(fighters_json)
    fighters_json.map { |fighter|
      Character.new.from_json(fighter)
    }
  end

  def fighters_from_collection
    collection = connect_to_mongo

    collection.aggregate([{ '$sample' => { 'size' => 2 } }]).map { |fighter|
      Character.new.from_json(fighter.to_json)
    }
  end

  def attack(fighter1, fighter2)
    unless fighter1.alive?
      @game_over = true
      @winner    = fighter2
      return
    end

    fighter2.hp -= fighter1.str
  end

  def fight!
    attack(@fighter1, @fighter2) unless @game_over
    attack(@fighter2, @fighter1) unless @game_over
  end

  def and_the_winner_is
    @winner.name + ' WINS!'
  end

  def give_em_hell!
    while !@game_over
      fight!
    end

    return and_the_winner_is
  end
end
