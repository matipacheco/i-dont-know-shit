require_relative 'character'
require_relative '../mongo_connection'

# Game class. It represents the fight between two Character's
# The fight logic isnt 100% correct, but you get the idea of it :smirk:
class Battle
  attr_accessor :fighter1, :fighter2, :game_over

  def initialize
    fighters   = []
    collection = connect_to_mongo

    collection.aggregate([{ '$sample' => { 'size' => 2 } }]).each do |fighter|
      fighters << Character.new.from_json(fighter.to_json)
    end

    @game_over = !fighters.map(&:alive?).all?
    @fighter1, @fighter2 = fighters.sort_by(&:luck).reverse

    puts '---------------------------------'
    puts @fighter1.to_json
    puts '---------------------------------'
    puts @fighter2.to_json
  end

  def attack(fighter1, fighter2)
    unless fighter1.alive?
      @game_over = true
      puts fighter2.name + ' WINS!'

      return
    end

    fighter2.HP -= fighter1.hit
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

Battle.new.give_em_hell!
