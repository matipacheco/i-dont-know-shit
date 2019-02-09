require_relative 'character'
require_relative '../mongo_connection'

# Game class. It represents the fight between two Character's
# The fight logic isnt 100% correct, but you get the idea of it :smirk:
class Battle
  attr_accessor :fighter1, :fighter2, :game_over

  def initialize(fighters_json = nil)
    fighters = fighters_json.nil? ? fighters_from_collection : fighters_from_json(fighters_json)

    @game_over = !fighters.map(&:alive?).all?
    @fighter1, @fighter2 = fighters.sort_by(&:luck).reverse
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
      return fighter2.name + ' WINS!'
    end

    fighter2.hp -= fighter1.hit
  end

  def fight!
    attack(@fighter1, @fighter2)
    attack(@fighter2, @fighter1)
  end

  def give_em_hell!
    while !@game_over
      fight!
    end
  end
end
