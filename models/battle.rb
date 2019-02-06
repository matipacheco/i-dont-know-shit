# Game class. It represents the fight between two Character's
class Battle
  attr_accessor :fighters, :game_over

  def initialize(fighters)
    # fighters sorted by luck (descending order)
    @fighters  = fighters
    @game_over = (not fighters.map(&:alive?).all?)
  end

  def attack
    
  end

  def fight!
  	while (not @game_over) do
  		
  	end
  end
end