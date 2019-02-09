require_relative 'mongo_connection'

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
    @fighter_1, @fighter_2 = fighters.order_by(&:LUCK).reverse
  end

  def attack
    puts @fighter_1.name + " attacks " + @fighter_2.name

    @fighter_2.HP -= @fighter_1.hit

    unless @fighter_2.alive?
      puts @fighter_2.name + " is dead!"
      puts @fighter_1.name + " WINS!"
      @game_over = true

      return
    end

    puts @fighter_2.name + " attacks " + @fighter_1.name
  end

  def fight!
  	while (not @game_over) do
  		
  	end
  end
end