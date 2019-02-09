require_relative 'character'
require_relative '../mongo_connection'

# Game class. It represents the fight between two Character's
class Battle
  attr_accessor :fighter_1, :fighter_2, :game_over

  def initialize
    # fighters sorted by luck (descending order)
    fighters   = []
    collection = connect_to_mongo

    collection.aggregate([{ '$sample'=> { 'size' => 2 } }]).each do |fighter|
      fighters << Character.new().from_json(fighter.to_json)
    end

    @game_over = (not fighters.map(&:alive?).all?)
    @fighter_1, @fighter_2 = fighters.sort_by(&:LUCK).reverse
  end

  def attack(fighter_1, fighter_2)
    unless fighter_1.alive?
      puts fighter_1.name + " is dead!"
      puts fighter_2.name + " WINS!"

      puts "GAME OVER!"
      @game_over = true

      return
    end

    puts fighter_1.name + " attacks " + fighter_2.name
    fighter_2.HP -= fighter_1.hit
  end

  def fight!
    attack(@fighter_1, @fighter_2)
    attack(@fighter_1, @fighter_1)
  end

  def give_em_hell!
  	while (not @game_over) do
  		fight!
  	end
  end
end

Battle.new().give_em_hell!
